FROM uzyexe/serverspec:2.37.2

RUN apk update && \
    apk -Uuv add curl make bash gcc build-base abuild binutils git openssh less groff python python-dev py-pip jq && \
    pip install awscli && \
    rm -rf /var/cache/apk/*

ENV BUNDLE_GEMFILE /vendor/Gemfile
ENTRYPOINT ["bundle", "exec"]
WORKDIR /module

COPY vendor /vendor
RUN bundle install

ENV TERRAFORM_DOCS_VERSION=0.3.0

RUN curl -Ls "https://github.com/segmentio/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs_linux_amd64" -o /usr/local/bin/terraform-docs && \
    chmod 755 /usr/local/bin/terraform-docs

ENV TFLINT_VERSION=v0.5.1

RUN curl -Ls "https://github.com/wata727/tflint/releases/download/${TFLINT_VERSION}/tflint_linux_amd64.zip" -o tflint.zip && \
    unzip tflint.zip -d /usr/local/bin && \
    rm -f tflint.zip


ENV TERRAFORM_VERSION=0.11.7

RUN curl -Ls "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -o terraform.zip && \
    unzip terraform.zip -d /usr/local/bin && \
    rm -f terraform.zip && \
    git config --global url."https://github.com/".insteadOf "ssh://git@github.com/"
