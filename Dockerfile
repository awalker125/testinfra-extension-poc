FROM centos:7

ARG DOCKER_GID=2000
ARG CENTOS_GID=1000
ARG CENTOS_UID=1000

RUN groupadd -g ${DOCKER_GID:-2000} docker
RUN groupadd -g ${CENTOS_GID:-1000} centos
RUN useradd -m -u ${CENTOS_UID:-1000} -g centos -G docker centos && \
	mkdir -p /home/centos/.ssh && \
	chown centos:centos /home/centos/.ssh && \
	chmod 700 /home/centos/.ssh
	
# Change to root user
USER root

#enable epel for pip
RUN yum -y install git epel-release && \
	yum clean all && \
	rm -rf /var/cache/yum

RUN yum -y install \
	python-pip \
	gcc \
	openssl-devel \
	python-devel \
	libffi-devel \
	krb5-devel \
	krb5-libs \
	krb5-workstation \
	telnet \
	bind-utils \
	net-tools \
	conntrack-tools \
	jq \
	docker \
	python-docker-py \
	curl \
	wget \
	which \
	openssl \
	bash-completion \
	telnet \
	sudo && \
	yum clean all && \
	rm -rf /var/cache/yum	 

ADD requirements.txt .

RUN pip install setuptools --upgrade    

RUN pip install -r requirements.txt

ARG KUBECTL_VERSION=1.13.8
ENV KUBECTL_VERSION=${KUBECTL_VERSION} 

RUN curl -L -o /usr/local/bin/kubectl-v${KUBECTL_VERSION}  https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl  && \
	chmod +x /usr/local/bin/kubectl-v${KUBECTL_VERSION} && \
	ln -s /usr/local/bin/kubectl-v${KUBECTL_VERSION} /usr/local/bin/kubectl && \
	ln -s /usr/local/bin/kubectl /usr/bin/kubectl

ARG HELM_VERSION=2.13.1
ENV HELM_VERSION=${HELM_VERSION} 

RUN curl -L -o helm-v${HELM_VERSION}-linux-amd64.tar.gz https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
	tar -xzvf helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
	cp linux-amd64/helm /usr/local/bin/helm && \
	chmod +x /usr/local/bin/helm && \
	ln -s /usr/local/bin/helm /usr/bin/helm && \
	rm -rf helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
	rm -rf linux-amd64

USER centos

ARG application

LABEL com.github.awalker125.application $application