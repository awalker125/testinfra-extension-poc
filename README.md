# testinfra-extension-poc
POC of extending testinfra

## Vagrant

There is an example `Vagrantfile` in this repo to create a centos7 development environment.

The provisioner will install docker and python pip from epel to enable somewhere to dev/test.


## Use Case

We want to create a docker image with various tools and test the resulting image with testinfra.

While the are built in tests for most of the things we want to test it would be nice to extend testinfra to test our tool versions. While this is trivial use case it may be useful for more complex scenarios.

## Make

The is a `Makefile` in the repo to both run and document the various commands used.

### Setup

Run vagrant up

```bash
vagrant up
```

Then ssh into the vm

Create a venv for python

```bash
cd /vagrant
make venv
```

Install the dev deps i.e testinfra
```bash
. ~/venv/bin/activate
make dev
```

### Build the image

Edit the dockerfile as needed then run
```bash
make build
```

If you change the dockerfile re run `make build`

**NOTE: This docker image installs kubectl, ansible and helm. It can be used as a building block to manage a k8s cluster with that stack. Its just and example but the same principle could be used elsewhere**

### Create tests

Under /vagrant/test create test cases for the docker image.

Then run 

```bash
make test
```

### Clean up containers

After test runs the containers will stay alive to allow interactive debug with ```docker exec```.

To clean this up run 

```bash
make clean
```

## Tests

### conftest.py

This file loads our custom fixtures when running ```py.test```.

This is based on this [gist](https://gist.github.com/peterhurford/09f7dcda0ab04b95c026c60fa49c2a68#gistcomment-2371025)

Add more fixtures to that file as needed.

Modules need to have `__init__.py` or they will not [load](https://gist.github.com/peterhurford/09f7dcda0ab04b95c026c60fa49c2a68#gistcomment-2729443).

### tests/test_some_app.py

These are our tests we want to run. There is examples copied straight from the testinfra [examples](https://testinfra.readthedocs.io/en/latest/examples.html#parametrize-your-tests) page plus a call to a few of our custom fixtures/extensions.

### tests/fixtures/echo.py

This is loosely based on [testinfra-echo](https://github.com/philpep/testinfra-echo) although I could not get this to work as is and I did not want to package my fixture as a separate pip module to install. That approach is probably better if the fixture is reusable on multiple projects.

I think it might be out of date because the `Command` fixture does not seem to exist anymore. It functionality is part of `host` now. The example in `echo.py` uses the host fixture. This get injected when needed.


### tests/fixtures/kubectl_binary.py

This creates a new fixture for testing the version of the kubectl binary on a host.

We inject the host fixture from testinfra so that must be installed.

