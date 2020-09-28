FROM hashicorp/terraform:0.12.29

ENV PACKAGES abuild binutils bash build-base curl-dev make gcc git openssh less groff jq \
             ruby ruby-dev ruby-io-console ruby-bundler ruby-webrick \
             python3 python3-dev py-pip

# Update and install all required packages; remove package cache to keep it out of the image layer
# At the end, remove the apk cache
RUN apk update && \
    apk upgrade && \
    apk add -Uuv $PACKAGES && \
    rm -rf /var/cache/apk/*

RUN pip install awscli

RUN git config --global url."https://github.com/".insteadOf "ssh://git@github.com/"

ENV BUNDLE_GEMFILE /vendor/Gemfile
ENTRYPOINT ["bundle", "exec"]
WORKDIR /module

COPY vendor /vendor
RUN bundle install

ENV TERRAFORM_DOCS_VERSION=0.10.1
RUN curl -Ls "https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64" -o /usr/local/bin/terraform-docs && \
    chmod 755 /usr/local/bin/terraform-docs
