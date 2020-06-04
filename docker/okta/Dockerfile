FROM centos:7

ARG OKTA_SUBDOMAIN
ARG OKTA_AGENT_VERSION=05.05.07

WORKDIR /tmp/repo
RUN curl -Os https://${OKTA_SUBDOMAIN}-admin.oktapreview.com/static/ldap-agent/OktaLDAPAgent-${OKTA_AGENT_VERSION}.x86_64.rpm  

RUN yum install -y createrepo && \
    createrepo /tmp/repo

COPY local.repo /etc/yum.repos.d

RUN yum update -y && \
    yum install -y OktaLDAPAgent.x86_64 && \
    yum clean all
