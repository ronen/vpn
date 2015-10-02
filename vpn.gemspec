# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "vpn"
  spec.version       = "0.1.0"
  spec.authors       = ["ronen barzel"]
  spec.email         = ["ronen@barzel.org"]

  spec.summary       = %q{A shell command for making vpn connections.  It's a wrapper around openconnect.}
  spec.description   = %q{Lets you set up one or more vpn configurations, then connect via `vpn up` and `vpn down`.}
  spec.homepage      = "http://github.com/ronen/vpn"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.3"
  spec.add_development_dependency "simplecov", "~> 0.10"
end
