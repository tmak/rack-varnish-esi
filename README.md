# rack-varnish-esi

rack-varnish-esi is a Varnish ESI middleware implementation for Rack which is as close as possible to Varnish's own ESI implementation.

__Note:__ This gem should only be used in development.


## Installation

### With Gemfile

Add this line to your application's Gemfile:

```ruby
gem 'rack-varnish-esi'
```

And then execute:

    $ bundle

### Without Gemfile

    $ gem install rack-varnish-esi


## Usage

### rackup

```ruby
use Rack::VarnishEsi, options
run Application.new
```

### Rails: config/environments/development.rb

```ruby
config.middleware.insert 0, Rack::VarnishEsi, options
```

### Options

```ruby
options = {
  :locations => {
    /\/esi\/*/ => "http://my-esi-host.com", # Resolves /esi/* to http://my-esi-host.com/esi/*
    "/banners/header.html" => "http://localhost:8080", # Resolves /banners/header.html to http://localhost:8080/banners/header.html
  }
}
```


## Test environment

    $ bundle exec rake test

### Update varnish fixtures

Start varnish in one terminal:

    $ test/fixtures/run_varnish.sh

Start static server in another terminal:

    $ bundle exec rackup test/static_server/config.ru

And then update varnish fixtures:

    $ wget http://localhost:6081 -O test/fixtures/varnish_output.html


## Contributing

1. Fork it ( https://github.com/tmak/rack-varnish-esi/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
