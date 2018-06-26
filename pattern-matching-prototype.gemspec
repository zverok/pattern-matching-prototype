Gem::Specification.new do |s|
  s.name     = 'pattern-matching-prototype'
  s.version  = '0.0.0'
  s.authors  = ['Victor Shepelev']
  s.email    = 'zverok.offline@gmail.com'
  s.homepage = 'https://github.com/zverok/pattern-matching-prototype'

  s.summary = 'Ruby pattern matching prototype'
  s.description = <<-EOF
    Showcase of language core proposal.
  EOF
  s.licenses = ['MIT']

  s.files = `git ls-files lib LICENSE.txt *.md`.split($RS)
  s.require_paths = ["lib"]

  s.required_ruby_version = '>= 2.2.0'

  s.add_runtime_dependency 'binding_of_caller'

  s.add_development_dependency 'rspec', '~> 3.7.0'
  s.add_development_dependency 'rspec-its'
  s.add_development_dependency 'saharspec'

  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rubocop-rspec'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rubygems-tasks'
end
