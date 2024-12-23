# syntax = docker/dockerfile:1
# check=error=true

ARG RUBY_VERSION=3.2.2
FROM ruby:$RUBY_VERSION-alpine AS base

# Rails app lives here
WORKDIR /rails

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_WITHOUT="development:test" \
    BUNDLE_DEPLOYMENT="1" \
    LITESTACK_DATA_PATH="/data"

# Throw-away build stage to reduce size of final image
FROM base AS build

# Install Alpine packages needed to build gems
RUN apk add --no-cache gcompat build-base git openssh-client curl libc6-compat sqlite-dev nodejs yarn tzdata

# Install application gems
COPY --link Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ $BUNDLE_PATH/ruby/*/cache $BUNDLE_PATH/ruby/*/bundler/gems/*/.git

# Copy application code
COPY --link . .

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE=DUMMY ./bin/rails assets:precompile

# Final stage for app image
FROM base

# Install runtime packages
RUN apk add --no-cache curl sqlite-libs

# Copy built artifacts: gems, application
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
RUN adduser -D -h /home/rails rails && \
    mkdir /data && \
    chown -R rails:rails db log tmp /data
USER rails:rails

# Deployment options
ENV DATABASE_URL="sqlite3:///data/production/data.sqlite3" \
    RAILS_LOG_TO_STDOUT="1" \
    RAILS_SERVE_STATIC_FILES="true"

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
VOLUME /data
CMD ["./bin/rails", "server"]
