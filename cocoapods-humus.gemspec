Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY

  s.name = 'cocoapods-humus'
  s.version = '1.0.0'

  s.author = 'Florian Hanke'
  s.email = 'florian.hanke+cocoapods.org@gmail.com'

  s.licenses = ['MIT']

  s.homepage = 'https://github.com/CocoaPods/Humus'

  s.description = 'CocoaPods database helper gem.'
  s.summary = 'Manages DB dumps for testing.'

  s.files = Dir["fixtures/README.md", "lib/cocoapods-humus.rb", "lib/snapshots.rb"]

  s.add_runtime_dependency 's3', '~> 0.3'
end