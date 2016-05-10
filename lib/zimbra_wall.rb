require "yaml"
require "uuid"
require 'em-proxy'
require 'http/parser'
require "addressable/uri"
require 'logger'
require 'cgi'
require 'xmlsimple'
require "zimbra_wall/version"
require "zimbra_wall/user"
require "zimbra_wall/config"
require "zimbra_wall/backend"
require "zimbra_wall/request"
require "zimbra_wall/server"
require "zimbra_wall/debug"
require "zimbra_wall/connection"
require "zimbra_wall/yamler"

module ZimbraWall

  def self.start(options)
    config!(options)
    ZimbraWall::Server.run
  end

  def self.config!(options)
    ZimbraWall::Config.domain = options[:domain]
    ZimbraWall::Config.blocked_users_file = options[:blocked_users_file]
    ZimbraWall::Config.backend = options[:backend]
    ZimbraWall::Config.backend_port = options[:backend_port]
    ZimbraWall::Config.bind_address = options[:bind_address] || "0.0.0.0"
    ZimbraWall::Config.bind_port = options[:bind_port]
    ZimbraWall::Config.debug = options[:debug]
  end

end
