# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/varnish_esi_version'

Gem::Specification.new do |spec|
  spec.name          = "rack-varnish-esi"
  spec.version       = Rack::VarnishEsi::VERSION
  spec.authors       = ["Thomas Marek"]
  spec.email         = ["thomas_marek@gmx.net"]
  spec.summary       = %q{Varnish ESI middleware implementation for Rack.}
  spec.description   = %q{<<-EOF
rack-varnish-esi is a Varnish ESI middleware implementation for Rack which is as close as possible to Varnish's own ESI implementation.
Note: This gem should only be used in development.
EOF}
  spec.homepage      = "https://github.com/tmak/rack-varnish-esi"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rack"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
end
