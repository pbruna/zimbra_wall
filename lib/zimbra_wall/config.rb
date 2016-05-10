module ZimbraWall
  module Config

    ROUTE_URL = "/service/extension/nginx-lookup"
    ROUTE_REQUEST_PORT = 7072
    AUTH_REQUEST_PORT = 80

    def self.domain=(domain)
      @domain = domain
    end

    def self.domain
      @domain
    end

    def self.blocked_users_file=(file)
      @blocked_users_file = file
    end

    def self.blocked_users_file
      @blocked_users_file
    end

    def self.backend=(backend)
      @backend = backend
    end

    def self.backend
      @backend
    end

    def self.backend_port=(port)
      @backend_port = port
    end

    def self.backend_port
      @backend_port
    end

    def self.bind_port=(bind_port)
      @bind_port = bind_port
    end

    def self.bind_port
      @bind_port
    end

    def self.bind_address=(bind_address)
      @bind_address = bind_address
    end

    def self.bind_address
      @bind_address
    end

    def self.debug=(debug)
      @debug = debug
    end

    def self.debug
      @debug
    end

  end
end
