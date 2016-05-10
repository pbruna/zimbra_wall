module ZimbraWall
  class Request
    require 'pp'

    attr_accessor :body, :headers, :parser

    def initialize(connection, parser = nil)
      @body = connection.body
      @headers = connection.headers
      @parser = parser
    end

    def auth_request?
      default_auth_request? || zco_auth_request?
    end

    # This is the post Auth request sent by Webmail, ActiveSync and POP and IMAP
    def default_auth_request?
      @parser.http_method == 'POST' && @parser.request_url == '/' && @headers["Cookie"] = "ZM_TEST=true" && auth_request_params?
    end

    def zco_auth_request?
      @parser.http_method == 'POST' && @parser.request_url == "/service/soap/AuthRequest" && @headers["User-Agent"].match(/Zimbra-ZCO/)
    end


    def blank_password_from_body
      params = CGI::parse(@body)
      params['password'] = ['']
      URI.encode_www_form params
    end

    def auth_request_params?
      uri = Addressable::URI.parse("#{@headers['Origin']}/?#{@body}")
      uri.query_values["loginOp"] == "login"
    end

    def modify_query_field(field, value)
      uri = Addressable::URI.parse("#{@headers['Referer']}?#{@body}")
      uri.query_values[field] = value
      uri.query_values
    end

    def route_request?
      @parser.request_url == ZimbraWall::Config::ROUTE_URL
    end

    def port
      return ZimbraWall::Config::ROUTE_REQUEST_PORT if route_request?
      return ZimbraWall::Config::AUTH_REQUEST_PORT if auth_request?
    end

    def user_token
      return auth_username if default_auth_request?
      return auth_zimbraId if route_request?
      return auth_zco_username if zco_auth_request?
    end

    def auth_zimbraId
      headers["Auth-User"]
    end

    def auth_zco_username
      # Hold on, we have to dig deeper
      xml = XmlSimple.xml_in @body
      xml["Body"].first["AuthRequest"].first["account"].first["content"]
    end

    def auth_username
      uri = Addressable::URI.parse("http://localhost/?#{@body}")
      uri.query_values["username"]
    end

  end
end
