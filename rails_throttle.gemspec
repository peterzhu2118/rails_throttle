lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rails_throttle/version"

Gem::Specification.new do |spec|
  spec.name          = "rails_throttle"
  spec.version       = RailsThrottle::VERSION
  spec.authors       = ["Peter Zhu"]
  spec.email         = ["peter@peterzhu.ca"]

  spec.summary       = "Throttle code in your Rails application."
  spec.homepage      = "https://github.com/peterzhu2118/rails_throttle"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "declarative_minitest", "~> 0.1.1"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rake", "~> 10.0"
end
