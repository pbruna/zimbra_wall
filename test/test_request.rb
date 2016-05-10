require 'test_helper'

class Request < Minitest::Test
  
  def setup
    @done = false
    @auth_request = IO.read("./test/fixtures/auth_80.txt")
    @route_request = IO.read("./test/fixtures/route_7072.txt")
    @soap_auth_request = IO.read("./test/fixtures/zco_soap.xml")
    @connection = OpenStruct.new
    @parser = OpenStruct.new
  end
  
  def test_should_return_user_token_from_auth_request
    @parser.http_method = "POST"
    @parser.request_url = "/zimbra/"
    @connection.headers = {"Cookie" => "ZM_TEST=true"}
    @connection.body = "loginOp=login&username=pbruna&password=5693537374&client=preferred"
    request = ZimbraWall::Request.new @connection, @parser
    assert_equal("pbruna", request.user_token)
  end

  def test_should_return_user_token_from_route_request
    @parser.request_url = ZimbraWall::Config::ROUTE_URL
    @connection.headers = {"Auth-User" => "251b1902-2250-4477-bdd1-8a101f7e7e4e"}
    request = ZimbraWall::Request.new @connection, @parser
    assert_equal("251b1902-2250-4477-bdd1-8a101f7e7e4e", request.user_token)
  end

  def test_should_get_username_from_zco_auth_request
    @parser.http_method = "POST"
    @parser.request_url = "/service/soap/AuthRequest"
    @connection.headers = {"User-Agent" => "Zimbra-ZCO"}
    @connection.body = @soap_auth_request
    request = ZimbraWall::Request.new @connection, @parser
    assert_equal("watson@example.com", request.user_token)
  end

end