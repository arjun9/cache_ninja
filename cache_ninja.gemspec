# frozen_string_literal: true

require_relative "lib/cache_ninja/version"

Gem::Specification.new do |spec|
  spec.name = "cache_ninja"
  spec.version = CacheNinja::VERSION
  spec.authors = ["Arjun Verma"]
  spec.email = ["arjun.verma8412@gmail.com"]

  spec.summary = "In the world of Ruby on Rails, association caching has often been viewed with caution. However, there are use cases where association caching can be a game-changer, and that's where **Cache Ninja** comes into play."
  spec.description = "**Cache Ninja** is the ultimate solution for safely and efficiently caching associations in your Ruby on Rails applications. While association caching is typically discouraged, there are specific scenarios where it's not just beneficial but essential for optimizing performance. **Cache Ninja** has been rigorously tested and is currently employed in our production-grade servers, making it the most reliable gem for association caching in Rails."
  spec.homepage = "https://github.com/arjun9/cache_ninja"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/arjun9/cache_ninja"
  spec.metadata["changelog_uri"] = "https://github.com/arjun9/cache_ninja/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'rails', '>= 4.0'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
