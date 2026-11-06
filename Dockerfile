# syntax=docker/dockerfile:1
# check=error=true

# Builds the docs site (test/dummy). It has no database and keeps no state.
#
# docker build -t orbital-docs .
# docker run -d -p 3000:3000 -e SECRET_KEY_BASE=<value from bin/rails secret> --name orbital-docs orbital-docs

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=4.0.9
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libyaml-0-2 && \
    ln -s /usr/lib/$(uname -m)-linux-gnu/libjemalloc.so.2 /usr/local/lib/libjemalloc.so && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test" \
    LD_PRELOAD="/usr/local/lib/libjemalloc.so"

# Throw-away build stage to reduce size of final image
FROM base AS build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libyaml-dev pkg-config unzip && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENV BUN_INSTALL=/usr/local/bun
ENV PATH=/usr/local/bun/bin:$PATH
ARG BUN_VERSION=1.4.4
RUN curl -fsSL https://bun.sh/install | bash -s -- "bun-v${BUN_VERSION}"

# The gemspec lists files from the working directory, so copy the code first.
COPY . .

RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    # -j 1 disable parallel compilation to avoid a QEMU bug: https://github.com/rails/bootsnap/issues/495
    bundle exec bootsnap precompile -j 1 --gemfile

RUN bun install --frozen-lockfile && \
    bun run build:dummy && \
    rm -rf node_modules

# Precompiling assets does not need a real secret. Run it from the dummy app, because
# from the root Rake would load the gem's Rakefile.
WORKDIR /rails/test/dummy
RUN SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile
WORKDIR /rails

# Final stage for app image
FROM base

RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash
USER 1000:1000

COPY --chown=rails:rails --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --chown=rails:rails --from=build /rails /rails

HEALTHCHECK CMD curl --fail http://localhost:3000/up || exit 1

ENV HTTP_PORT="3000" TARGET_PORT="3001"
EXPOSE 3000
CMD ["bundle", "exec", "thrust", "test/dummy/bin/rails", "server"]
