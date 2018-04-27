# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'huginn_moves_agent/version'

Gem::Specification.new do |spec|
  spec.name          = 'huginn_moves_agent'
  spec.version       = HuginnMovesAgent::VERSION
  spec.authors       = ['Tyler Guillen']
  spec.email         = ['tyguillen@gmail.com']

  spec.summary       = 'The Huginn Moves agent pulls location data from Moves and outputs the raw JSON response.'
  spec.description   = 'The Huginn Moves agent pulls location data from Moves and outputs the raw JSON response.'
  spec.homepage      = 'http://github.com/aastronautss/huginn_moves_agent'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.add_runtime_dependency 'huginn_agent'
  spec.add_runtime_dependency 'moves'
end
