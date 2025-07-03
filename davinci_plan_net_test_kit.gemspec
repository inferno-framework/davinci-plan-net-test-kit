require_relative 'lib/davinci_plan_net_test_kit/version'

Gem::Specification.new do |spec|
  spec.name          = 'davinci_plan_net_test_kit'
  spec.version       = DaVinciPlanNetTestKit::VERSION
  spec.authors       = ['Karl Naden']
  spec.email         = ['inferno@groups.mitre.org']
  spec.summary       = 'DaVinci Plan Net Test Kit'
  spec.description   = 'DaVinci Plan Net Test Kit'
  spec.homepage      = 'https://github.com/inferno-framework/davinci-plan-net-test-kit'
  spec.license       = 'Apache-2.0'
  spec.add_runtime_dependency 'inferno_core', '>= 0.6.16'
  spec.add_runtime_dependency 'tls_test_kit', '>= 0.3.0'
  spec.add_development_dependency 'database_cleaner-sequel', '~> 1.8'
  spec.add_development_dependency 'factory_bot', '~> 6.1'
  spec.add_development_dependency 'rspec', '~> 3.10'
  spec.add_development_dependency 'webmock', '~> 3.11'
  spec.required_ruby_version = Gem::Requirement.new('>= 3.3.6')
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.files         = `[ -d .git ] && git ls-files -z lib config/presets LICENSE`.split("\x0")
  spec.require_paths = ['lib']
  spec.metadata['inferno_test_kit'] = 'true'
end
