FROM alpine:3.14
ENV BUILD_PACKAGES bash curl-dev ruby-dev build-base
ENV RUBY_PACKAGES ruby ruby-io-console ruby-bundler
# Update and install all of the required packages.
# At the end, remove the apk cache
RUN apk update && \
    apk upgrade && \
    apk add $BUILD_PACKAGES && \
    apk add $RUBY_PACKAGES && \
    apk add sqlite sqlite-dev sqlite-libs
RUN gem install sqlite3 --no-document
RUN rm -rf /var/cache/apk/*
RUN mkdir /usr/app
WORKDIR /usr/app
COPY . /usr/app
CMD ["./make-it-so"]
