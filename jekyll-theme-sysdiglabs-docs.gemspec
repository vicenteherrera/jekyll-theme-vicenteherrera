# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "jekyll-theme-sysdiglabs-docs"
  spec.version       = "0.1.0"
  spec.authors       = ["Néstor Salceda"]
  spec.email         = ["nestor.salceda@gmail.com"]

  spec.summary       = "Theme used for sysdiglabs documentation."
  spec.homepage      = "https://github.com/sysdiglabs/jekyll-theme-sysdiglabs-docs"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r!^(assets|_layouts|_includes|_sass|LICENSE|README)!i) }

  spec.add_runtime_dependency "jekyll", "~> 3.9"
  spec.add_runtime_dependency "jekyll-seo-tag", "~> 2.1"

  spec.add_development_dependency "bundler", "~> 2.1.4"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "bootstrap", "~> 4.5.2"
end
