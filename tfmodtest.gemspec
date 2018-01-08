# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tfmodtest/version'

Gem::Specification.new do |spec|
  spec.name          = 'tfmodtest'
  spec.version       = TFModTest::VERSION
  spec.authors       = ['Victor Jimenez', 'Daniel Baker']
  spec.email         = ['vjimenez@vistaprint.com', 'dbaker@vistaprint.com']

  spec.summary       = 'Set of scripts to ease testing of Terraform modules.'
  spec.homepage      = 'https://github.com/vistaprint/tfmodtest'
  spec.license       = 'Apache-2.0'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_runtime_dependency 'TerraformDevKit', '>= 0.2.6', '< 0.3.0'
end
