# Standard Makefile for library gems.
GEM_NAME := orbital_ui
VERSION = $(shell ruby -e 'puts Gem::Specification.load("$(GEM_NAME).gemspec").version')

# Supported Rubies: the latest release of each supported major version.
RUBIES ?= 3.4.12 4.0.9

# Prerequisites must run in order: a release must not build before tests pass.
.NOTPARALLEL:

.PHONY: all test lint spec trivy audit brakeman test-rubies build clean release-check release \
	help setup dev docs demo assets assets-dummy icons lint-js typecheck bun-audit

all: test

test: lint spec trivy audit brakeman

lint:
	@echo "Running lint tests with Rubocop ..."
	bundle exec rubocop

spec:
	@echo "Running testsuite with Minitest ..."
	bundle exec rake test

trivy:
	@echo "Running vulnerability tests with Trivy ..."
	trivy fs --config trivy.yaml --severity UNKNOWN,LOW --exit-code 0 .
	trivy fs --config trivy.yaml .

audit:
	@echo "Checking Ruby dependencies with bundle-audit ..."
	bundle exec bundle-audit check --update

# Brakeman does not parse ORB templates, so it does not check .orb views for XSS.
# It also does not flag raw() in component classes. A clean result does not cover
# either. The dummy app is scanned separately because a root scan does not reach it.
brakeman:
	@echo "Running static analysis with Brakeman ..."
	bundle exec brakeman --no-pager -q --force
	bundle exec brakeman --no-pager -q --force -p test/dummy

# Requires rbenv. Fails if RBENV_VERSION does not select the expected Ruby.
test-rubies:
	@for v in $(RUBIES); do \
		echo "==> Ruby $$v"; \
		actual=$$(RBENV_VERSION=$$v ruby -e 'print RUBY_VERSION'); \
		if [ "$$actual" != "$$v" ]; then \
			echo "Expected Ruby $$v but got '$$actual'. Is rbenv active?" >&2; \
			exit 1; \
		fi; \
		RBENV_VERSION=$$v bundle install --quiet && RBENV_VERSION=$$v $(MAKE) --no-print-directory spec || exit 1; \
	done

build: clean
	gem build $(GEM_NAME).gemspec

clean:
	rm -f $(GEM_NAME)-*.gem

# The gem packages whatever is in the working directory, so only release a
# clean tree from a pushed commit, and never a version that is already tagged.
release-check:
	@test -z "$$(git status --porcelain)" || \
		{ echo "Working tree must be clean to release" >&2; exit 1; }
	@git merge-base --is-ancestor HEAD origin/main || \
		{ echo "HEAD must be pushed to origin/main to release" >&2; exit 1; }
	@test -z "$$(git tag --list v$(VERSION); git ls-remote --tags origin v$(VERSION))" || \
		{ echo "v$(VERSION) is already tagged" >&2; exit 1; }

# Tags only after a successful publish, so a failed push leaves no tag behind.
release: release-check test build
	gem push $(GEM_NAME)-$(VERSION).gem
	git tag -a v$(VERSION) -m "v$(VERSION)"
	git push origin v$(VERSION)

# ─── Extras: these do not change the targets above ──────────────────────────

help: ## Show the extra targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2}'

setup: ## Install dependencies and build the dummy app's assets
	bundle install
	bun install
	$(MAKE) --no-print-directory assets-dummy

dev: ## Start the dummy app and asset watchers
	bin/dev

docs: setup ## Install and run the docs site from test/dummy
	bin/dev

demo: ## Install and run the Fernhill demo app in demos/fernhill
	cd demos/fernhill && env -u BUNDLE_GEMFILE bin/setup

assets: ## Build the gem's committed JS and CSS. Run before committing frontend changes.
	bun run build

assets-dummy: ## Build the dummy app's JS and CSS
	bun run build:dummy

icons: ## Regenerate lib/orbital_ui/icons.rb
	bun run generate:icons

lint-js: ## Lint JS, TS and CSS with Biome
	bun x biome check frontend test/dummy/app/assets test/dummy/app/javascript

typecheck: ## Type-check TypeScript
	bun x tsc --noEmit

# Trivy does not report packages nested in bun.lock, such as "anymatch/picomatch",
# or npm dev dependencies with the standard trivy.yaml. bun audit covers both.
bun-audit: ## Check npm packages, failing on high or critical findings
	bun audit --audit-level=high
