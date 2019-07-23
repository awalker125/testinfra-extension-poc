import pytest
import jmespath
import json

@pytest.fixture()
def kubectl_binary(host):
    kb = KubectlBinary(host)
    return kb


class KubectlBinary():

    def __init__(self, host):
        self.host = host


    @property
    def version(self):
        
        version_json = self.host.check_output("kubectl version --client -o json")
        version_data = json.loads(version_json)
        return jmespath.search('clientVersion.gitVersion', version_data)