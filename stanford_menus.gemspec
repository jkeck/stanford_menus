
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "stanford_menus/version"

Gem::Specification.new do |spec|
  spec.name          = "stanford_menus"
  spec.version       = StanfordMenus::VERSION
  spec.authors       = ["Jessie Keck"]
  spec.email         = ["jessie.keck@gmail.com"]

  spec.summary       = %q{A CLI for accessing Stanford Food Menu options}
  spec.homepage      = "https://github.com/jkeck/stanford_menus"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = "exe"
  spec.executables   = %w[stanford_menus]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_runtime_dependency "faraday"
  spec.add_runtime_dependency "json"
  spec.add_runtime_dependency "thor"
end
