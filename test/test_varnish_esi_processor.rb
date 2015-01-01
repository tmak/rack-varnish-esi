require 'minitest_helper'

class TestRackVarnishEsiProcessor < Minitest::Test
  def test_that_it_forces_the_encoding_of_the_context
    WebMock.disable_net_connect!

    processor = Rack::VarnishEsiProcessor.new(
      /.*/ => 'http://rack-varnish-esi.test'
    )

    body = <<-eos
      <html>
        <body>
          <esi:include src="/some/location">
        </body>
      </html>
    eos

    expected = <<-eos
      <html>
        <body>
          <p>€254</p>
        </body>
      </html>
    eos

    stub_request(:get, "http://rack-varnish-esi.test/some/location").to_return(:status => 200, :body => "<p>€254</p>".force_encoding("ASCII-8BIT"), :headers => {})

    processed = processor.process(body.strip.split("\n"))
    assert_equal expected.strip, processed.join("\n").strip
  end
end
