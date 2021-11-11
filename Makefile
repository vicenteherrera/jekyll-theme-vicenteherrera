VERSION=0.2.0

.PHONY: prerequisites serve-watch build install test

all: prerequisites serve-watch

prerequisites:
	gem install bundler
	bundle install

serve-watch:
	bundle exec jekyll serve --watch

build:
	gem build jekyll-theme-vicenteherrera.gemspec

install: build
	gem install --local jekyll-theme-vicenteherrera-${VERSION}.gem

test:
	exit 0

update:
	bundle update