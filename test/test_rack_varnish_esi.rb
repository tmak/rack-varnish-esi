require 'minitest_helper'
require 'net/http'
require 'rack'
require 'webrick'
require File.expand_path('../static_server/app', __FILE__)

class TestRackVarnishEsi < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Rack::VarnishEsi::VERSION
  end

  def test_that_it_has_the_same_behavior_as_varnish
    WebMock.allow_net_connect!

    http_server_thread = start_http_server_with_varnish_esi_middleware(
      :locations => {/.*/ => 'http://localhost:8080'},
    )

    begin
      assert_equal File.read(File.expand_path('../fixtures/varnish_output.html', __FILE__)), Net::HTTP.get(URI('http://localhost:8080')).force_encoding('UTF-8')
    ensure
      http_server_thread.exit
    end
  end

  def test_that_it_accepts_content_type_parameters
    body_mock = Minitest::Mock.new
    app_mock = Minitest::Mock.new
    app_mock.expect(:call, [200, {"Content-Type" => "text/html; charset=utf-8"}, body_mock], ["test_env" => true])
    body_mock.expect(:close, nil)
    body_mock.expect(:each, nil)
    middleware = Rack::VarnishEsi.new(app_mock)
    middleware.call({"test_env" => true})
    app_mock.verify
    body_mock.verify
  end

protected

  def start_http_server_with_varnish_esi_middleware(varnish_esi_options)
    http_server_log_file = File.open(File.expand_path('../http_server.log', __FILE__), 'a')

    http_server_options = {
      :Port => 8080,
      :Logger => WEBrick::Log.new(http_server_log_file),
      :AccessLog => [
          [ http_server_log_file, WEBrick::AccessLog::COMMON_LOG_FORMAT ],
          [ http_server_log_file, WEBrick::AccessLog::REFERER_LOG_FORMAT ]
      ]
    }

    http_server_thread = Thread.new do
      Rack::Handler::WEBrick.run(StaticServer::App.new(::Rack::VarnishEsi, varnish_esi_options), http_server_options)
    end

    sleep(0.5)

    http_server_thread
  end
end
