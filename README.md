# terraform-infra-dev

terraform-infra-dev provides a docker image for suitable for developing high-quality terraform modules using a collection of utilities.

[![CircleCI](https://circleci.com/gh/qualimente/terraform-infra-dev.svg?style=svg)](https://circleci.com/gh/qualimente/terraform-infra-dev)

## High Quality Terraform Builds

terraform-infra-dev provides several tools for creating a high-quality infrastructure delivery lifecycle (IDLC) based-on terraform.

### Testing ###

The kitchen-terraform test tool support has been removed due to issues resolving/building dependencies. 

It will be replaced by a tool suitable for use with modern Terraform/OpenTofu.

### Documentation ###

Document your Terraform modules with [terraform-docs](https://github.com/terraform-docs/terraform-docs).
`terraform-docs` reads your module's code and generates documentation from variable and output declarations into
the format of your choice.  

## Overriding Git clone URLs

Some modules may be configured to clone nested modules using the `ssh` protocol.

```
module "base" {
  source = "git::ssh://git@github.com/example-org/tf-modules.git//module-1?ref=1.0.0"
}
```

Some modules may use a nested module source that refers to a private GitHub 
repository. To support this, the build processes relies on your GitHub 
credentials being located in your `~/.netrc` file. 
This file should be volume mounted into the `terrraform-infra-dev` container
to make them available for the test process.
The `terraform-infra-dev` container is configured to have Git automatically 
override any `ssh` clone URLs to use HTTPS instead. 

```
git config --global url."https://github.com/".insteadOf "ssh://git@github.com/"
```

The `~/.netrc` file is then automatically referenced for credentials when
cloning over HTTPS.

The contents of the `~/.netrc` file look like so:

```
machine github.com
login <username>
password <password or personal token if MFA is enabled>
```

**NOTE**: if MFA is enabled on your GitHub account, then you **must** create a 
personal access token and use that as the password in the `~/.netrc` file.

## Local development and testing
Build the container image locally with a command like:

```
docker build -t terraform-infra-dev:latest .
```

Then you can run the structure tests with:

```
# note (2023-12-06): container-structure-test is only available for linux/amd64

docker container run --rm -it \
  --platform linux/amd64 \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  -v $PWD/structure-tests.yaml:/tests/structure-tests.yaml \
  gcr.io/gcp-runtimes/container-structure-test:v1.16.0 \
  test --image terraform-infra-dev:latest --config /tests/structure-tests.yaml
```


# Thanks #

terraform-infra-dev is built on top of the great work of:

* John Rengelman's [terraform-spec](https://github.com/johnrengelman/terraform-spec)
* uzyexe's [serverspec](https://github.com/uzyexe/dockerfile-serverspec)
 
