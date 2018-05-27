FROM alpine:3.7

ENV BUILD_PACKAGES bash curl-dev ruby-dev build-base
ENV RUBY_PACKAGES ruby ruby-io-console ruby-bundler
ENV MANIFESTER_AWS_ACCESS_KEY_ID \
    MANIFESTER_AWS_SECRET_ACCESS_KEY \
    MANIFESTER_AWS_REGION \
    MANIFESTER_ENV=production \
    MANIFESTER_GRP

RUN apk update && \
    apk upgrade && \
    apk add $BUILD_PACKAGES && \
    apk add $RUBY_PACKAGES && \
    rm -rf /var/cache/apk/*

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install

COPY . /usr/src/app
