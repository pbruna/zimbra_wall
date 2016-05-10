module ZimbraWall

  class User
    attr_accessor :email, :zimbraId

    @@db = {}

    # user_identifier can be an email address, zimbraId UUID or just the
    # local part of an email address, like user in user@example.com
    def initialize(user_identifier)
      @zimbraId = set_zimbraId user_identifier
      @email = set_email user_identifier
      User.load_migrated_users
    end

    # If user has email (unless email.nil?)
    def blocked?
      !find_in_db.nil?
    end

    def backend
      ZimbraWall::Config.backend
    end

    def find_in_db
      self.zimbraId = User.DB[email] if has_email?
      self.email = User.DB.invert[zimbraId] if has_zimbraId?
      User.DB[email] || User.DB.invert[zimbraId]
    end

    def has_email?
      !email.nil?
    end

    def has_zimbraId?
      !zimbraId.nil?
    end

    # Return the old DB if the YAML file has error
    def self.load_migrated_users
      data = ZimbraWall::Yamler.db
      return @@db unless data
      @@db = data
    end

    def self.DB
      load_migrated_users
      @@db
    end

    private
    def set_zimbraId user_identifier
      return user_identifier if UUID.validate user_identifier
      nil
    end

    def set_email user_identifier
      return nil if user_identifier.nil?
      return user_identifier if user_identifier.match(/@/)
      return "#{user_identifier}@#{ZimbraWall::Config.domain}" unless UUID.validate user_identifier
      nil
    end


  end

end
