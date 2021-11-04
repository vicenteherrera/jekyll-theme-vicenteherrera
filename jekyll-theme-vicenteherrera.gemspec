# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "jekyll-theme-vicenteherrera"
  spec.version       = "0.2.0"
  spec.authors       = ["Vicente Herrera"]
  spec.email         = ["vicenteherrera@vicenteherrera.com"]

  spec.summary       = "Theme used for vicenteherrera documentation."
  spec.homepage      = "https://github.com/vicenteherrera/jekyll-theme-vicenteherrera"
  spec.license       = "MIT"

  spec.metadata["plugin_type"] = "theme"

  spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r!^(assets|_layouts|_includes|_sass|LICENSE|README)!i) }

  spec.add_runtime_dependency "jekyll", "~> 3.9"
  spec.add_runtime_dependency "jekyll-seo-tag", "~> 2.6.1"
  spec.add_runtime_dependency "jekyll-sitemap", "~> 1.4.0"

  spec.add_development_dependency "bundler", "~> 2.1.4"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "autoprefixer-rails"
end
