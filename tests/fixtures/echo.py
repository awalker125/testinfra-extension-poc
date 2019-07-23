import pytest

@pytest.fixture()
def Echo(host):

    def f(arg):
        return host.check_output("echo %s", arg)

    return f