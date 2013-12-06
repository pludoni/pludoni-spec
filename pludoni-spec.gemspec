# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "pludoni-spec"
  spec.version       = "0.0.1"
  spec.authors       = ["Stefan Wienert"]
  spec.email         = ["stefan.wienert@pludoni.de"]
  spec.description   = %q{Alles was man so braucht zum testen}
  spec.summary       = %q{Alles was man so braucht zum testen}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "poltergeist"
  spec.add_runtime_dependency "simplecov"
  # spec.add_runtime_dependency "simplecov-rcov-text"
  spec.add_runtime_dependency 'timecop'
  spec.add_runtime_dependency "guard-rspec"
  spec.add_runtime_dependency "capybara"
  spec.add_runtime_dependency "poltergeist"
  spec.add_runtime_dependency "rb-inotify"
  spec.add_runtime_dependency "pry-rails"
  spec.add_runtime_dependency "rspec-retry"
  spec.add_runtime_dependency "i18n-missing_translations"
  spec.add_runtime_dependency 'action_mailer_cache_delivery'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
