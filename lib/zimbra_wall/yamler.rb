module ZimbraWall

  module Yamler
    require 'pp'

    def self.db
      begin
        YAML.load_file ZimbraWall::Config.blocked_users_file
      rescue Psych::SyntaxError => e
        puts "ERROR Yaml File: #{e}"
        return false
      end

    end

  end

end
