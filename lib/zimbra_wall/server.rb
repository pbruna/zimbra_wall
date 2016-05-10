module ZimbraWall

  module Server
    require 'pp'


    def run
      debug = ZimbraWall::Debug
      host = ZimbraWall::Config.bind_address
      port = ZimbraWall::Config.bind_port

      Proxy.start(host: host, port: port) do |conn|
        debug.logger "Running on #{host}:#{port} - V. #{ZimbraWall::VERSION}"

        @backend = { host: ZimbraWall::Config.backend, port: '7072' }
        connection = ZimbraWall::Connection.new

        @parser = Http::Parser.new
        @parser.on_message_begin = proc { connection.started = true }
        @parser.on_headers_complete = proc { |e| connection.headers = e }
        @parser.on_body = proc { |chunk| connection.body << chunk }
        @parser.on_message_complete = proc do
          request = ZimbraWall::Request.new(connection, @parser)
          if request.auth_request?
            @backend[:port] = ZimbraWall::Config.backend_port
            user = User.new(request.user_token)
            if user.blocked?
              connection.buffer.gsub!(/(?<=&password=).*(?=(&|$))/, '')
              puts "User blocked: #{user.email} - #{user.zimbraId}"
            end
            conn.server @backend[:host], host: @backend[:host], port: @backend[:port]
            conn.relay_to_servers connection.buffer
          end
        end

        conn.server @backend[:host], host: @backend[:host], port: @backend[:port]
        conn.relay_to_servers connection.buffer
        connection.buffer.clear

        conn.on_connect do |data, b|
          debug.logger [:on_connect, data, b]
        end

        conn.on_data do |data|
          debug.logger [:on_data, data]
          connection.buffer << data
          @parser << data if data !~ /\/service\/extension\/nginx-lookup/
          data
        end

        conn.on_response do |backend, resp|
          debug.logger [:on_response, backend, resp]
          if resp =~ /Auth-Status/i
            lookup_resp = ZimbraWall::Connection.parse_lookup_response(resp)
            user = User.new(lookup_resp['Auth-User'])
            if user.blocked?
              puts "User blocked: #{user.email} - #{user.zimbraId}"
              resp.gsub!(/Auth-Status: OK/, 'Auth-Status: ERR')
            end
          end
          resp
        end

        conn.on_finish do |_, name|
          debug.logger [:on_finish, name].inspect
        end
      end
    end

    module_function :run
  end
end
