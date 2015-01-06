require 'rack/varnish_esi_version'
require 'rack/varnish_esi_processor'

module Rack
  class VarnishEsi
    VALID_CONTENT_TYPES = /^(application\/javascript|application\/json|application\/xml|text\/css|text\/html|text\/plain)/

    def initialize(app, options={})
      @app = app
      @processor = Rack::VarnishEsiProcessor.new(options[:locations] || {})
    end

    def call(env)
      status, headers, body = @app.call(env)

      if headers['Content-Type'] =~ VALID_CONTENT_TYPES
        body.close if body.respond_to?(:close)
        body = @processor.process(body)
        headers['Content-Length'] = (body.reduce(0) {|sum, part| sum + part.bytesize}).to_s
      end

      [status, headers, body]
    end
  end
end
