module ZimbraWall
  module Debug

    require 'logger'

    def self.logger(data)
      return unless ZimbraWall::Config.debug
      return if data.nil?
      logger = Logger.new(STDOUT)
      logger.info { data }
    end
    
  end
end
    