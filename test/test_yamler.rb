require 'test_helper'
require 'digest'

class Yamler < Minitest::Test
  
  def setup
    backup_map_file
  end
  
  def teardown
    restore_map_file
  end

  def test_yamler_db_must_return_the_yaml_file_hash
    db = ZimbraWall::Yamler.db
    assert_equal("251b1902-2250-4477-bdd1-8a101f7e7e4e", db["watson@example.com"])
  end
  
  def test_return_false_if_updated_files_has_error
    add_error_line
    assert(!ZimbraWall::Yamler.db, "Failure message.")
  end
  
end