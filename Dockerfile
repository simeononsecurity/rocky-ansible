FROM rockylinux:8

LABEL org.opencontainers.image.source="https://github.com/simeononsecurity/rocky-ansible"
LABEL org.opencontainers.image.description="Ansible Controller running on Rockylinux 8"
LABEL org.opencontainers.image.authors="simeononsecurity"

# Install packages
RUN yum -yq update &&\
    yum -yq install python39 epel-release &&\
    yum -yq update &&\
    yum -yq install 'dnf-command(config-manager)'&&\
    yum config-manager --set-enabled extras &&\
    yum config-manager --set-enabled powertools 
    
# Install Python PIP and Ansible
RUN alternatives --set python /usr/bin/python3
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py &&\
    python3 get-pip.py &&\
    python3 -m pip install ansible --prefix /usr/local/ &&\
    python3 -m pip install ansible-lint &&\
    yum -y --nobest install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm &&\
    yum -y --nobest --skip-broken install ansible

# Preinstall some highly used ansible modules from the galaxy repo
RUN ansible-galaxy collection install ansible.netcommon &&\
    ansible-galaxy collection install ansible.utils &&\
    ansible-galaxy collection install ansible.windows &&\
    ansible-galaxy collection install community.general &&\
    ansible-galaxy collection install community.vmware &&\
    ansible-galaxy collection install community.windows

ENTRYPOINT [ "/bin/bash" ]
