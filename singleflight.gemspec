# frozen_string_literal: true

require_relative "lib/singleflight/version"

Gem::Specification.new do |spec|
  spec.name = "singleflight"
  spec.version = Singleflight::VERSION
  spec.authors = ["yoavgeva"]
  spec.email = ["dryoavgeva@gmail.com"]

  spec.summary = "Singleflight implementation for Ruby"
  spec.description = "Its primary purpose is to ensure that only one call to an expensive or duplicative operation is in flight at any given time.
   When multiple requests request the same resource, singleflight ensures that the function is executed only once, and the result is shared among all callers.
   This pattern is particularly useful in scenarios where caching isn't suitable or when the results are expected to change frequently."
  spec.homepage = "https://github.com/yoavgeva/singleflight"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"
  spec.platform = Gem::Platform::RUBY
  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/yoavgeva/singleflight/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
