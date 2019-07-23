import pytest

@pytest.mark.parametrize("name,version", [
    ("sudo","1.8.23"),
    ("docker", "1.13.1"),
    ("jq","1.5"),
    ("python", "2.7"),
])
def test_packages(host, name, version):
    pkg = host.package(name)
    assert pkg.is_installed
    assert pkg.version.startswith(version)

@pytest.mark.parametrize("name,version", [
    ("ansible","2.7.8"),
    ("awscli", "1.14.5"),
    ("openshift", "0.8.7"),
    ("kubernetes", "9.0.0"),    
    ("boto", "2.49.0"),
    ("s3cmd", "2.0.1"),
])
def test_pip_packages(host,name,version):
    pkgs = host.pip_package.get_packages()
    assert name in pkgs
    assert pkgs[name]["version"].startswith(version) 


#Use our custom fixture
def test_echo(Echo):
    assert Echo("foo") == "foo"

def test_kubectl_binary_version(kubectl_binary):

    assert kubectl_binary.version == "v1.13.8"
