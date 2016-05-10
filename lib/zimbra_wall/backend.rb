module ZimbraWall
  module Backend
   
    def self.for_user(user)
      return ZimbraWall::Config.new_backend if user.migrated?
      ZimbraWall::Config.old_backend
    end
    
  end
end