require 'test_helper'

class Backend < Minitest::Test
  
  def setup
    @user_migrated_email = ZimbraWall::User.new("watson@example.com")
    @user_migrated_zimbraId = ZimbraWall::User.new("251b1902-2250-4477-bdd1-8a101f7e7e4e")
    @user_not_migrated_email = ZimbraWall::User.new("jackbower@example.com")
    @user_not_migrated_zimbraId = ZimbraWall::User.new("251b1902-2250-4477-bdd1-8a101f7e7333")
  end
  
  def test_should_return_old_backend_if_user_email_is_not_migrated
    backend = ZimbraWall::Backend.for_user @user_not_migrated_email
    assert_equal(ZimbraWall::Config.old_backend, backend)
  end

  def test_should_return_old_backend_if_user_zimbraID_is_not_migrated
    backend = ZimbraWall::Backend.for_user @user_not_migrated_zimbraId
    assert_equal(ZimbraWall::Config.old_backend, backend)
  end

  def test_should_return_new_backend_if_user_email_was_migrated
    backend = ZimbraWall::Backend.for_user @user_migrated_email
    assert_equal(ZimbraWall::Config.new_backend, backend)
  end

  def test_should_return_new_backend_if_user_zimbraID_was_migrated
    backend = ZimbraWall::Backend.for_user @user_migrated_zimbraId
    assert_equal(ZimbraWall::Config.new_backend, backend)
  end
  
end