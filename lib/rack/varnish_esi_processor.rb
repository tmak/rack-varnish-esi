require 'net/http'

module Rack
  class VarnishEsiProcessor
    def initialize(locations)
      @locations = locations
    end

    def process(body)
      output = []

      body.each do |part|
        part = process_remove(part)
        part = process_comment(part)
        output << process_include(part)
      end

      output
    end

  protected

    def process_remove(part)
      part.gsub(/<esi:remove>.*<\/esi:remove>/m, '')
    end

    def process_comment(part)
      part.gsub(/<!--esi(.*)-->/m, '\1')
    end

    def process_include(part)
      part.gsub(/<esi:include src="([^"]+)"(?: +alt="([^"]+)")? *\/?>/) do
        fetch($1).force_encoding(part.encoding)
      end
    end

    def fetch(src)
      location = src.gsub(/https?:\/\/[^\/]+/, '')
      location = "/#{location}" unless location.start_with?('/')

      @locations.each do |pattern, host|
        if (pattern.is_a?(String) && location == pattern) || (pattern.is_a?(Regexp) && location =~ pattern)
          return get("#{host}#{location}")
        end
      end
    end

    def get(uri)
      Net::HTTP.get(URI(uri))
    end
  end
end
