require "zimbra_intercepting_proxy"
require 'ostruct'

require 'minitest/autorun'
require 'minitest/reporters' # requires the gem

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new # spec-like progress

ZimbraWall::Config.domain="example.com"
ZimbraWall::Config.blocked_users_file="./test/fixtures/users.yml"
ZimbraWall::Config.old_backend = "old-mailbox.example.com"
ZimbraWall::Config.new_backend = "new-mailbox.zboxapp.com"

def add_error_line
  f = File.open ZimbraWall::Config.blocked_users_file, "a"
  f.puts "juan :94949494-9494949-040404"
  f.close
end

def restore_map_file
  backup_file = "./test/fixtures/users.yml.org"
  FileUtils.cp(backup_file, ZimbraWall::Config.blocked_users_file)
  FileUtils.rm "./test/fixtures/users.yml.org"
end

def backup_map_file
  backup_file = "./test/fixtures/users.yml.org"
  FileUtils.cp(ZimbraWall::Config.blocked_users_file, backup_file)
end
