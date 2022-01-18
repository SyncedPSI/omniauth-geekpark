# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth-geekpark/version'

Gem::Specification.new do |spec|
  spec.name          = 'omniauth-geekpark'
  spec.version       = OmniAuth::GeekPark::VERSION
  spec.authors       = %w(HaoYunfei Gavin)
  spec.email         = ["haoyunfei@geekpark.net"]

  spec.summary       = %q{ OmniAuth strategies for GeekPark. Includes geekpark, weibo and wechat. }
  spec.description   = %q{ Official OmniAuth strategies for GeekPark. }
  spec.homepage      = "https://github.com/GeekPark/omniauth-geekpark"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'omniauth', '~> 1.0'
  spec.add_dependency 'omniauth-oauth2', '~> 1.4'
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'webmock', '~> 1.24', '>= 1.24.2'
end
