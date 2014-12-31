require 'rack'

module StaticServer
  class App
    def initialize(extra_middleware=nil, extra_middleware_options={})
      @static = Rack::Static.new(self, :urls => [""], :root => File.expand_path('../public', __FILE__), :index => "index.html")

      if extra_middleware
        @middleware = extra_middleware.new(@static, extra_middleware_options)
      else
        @middleware = @static
      end
    end

    def call(env)
      @middleware.call(env)
    end
  end
end