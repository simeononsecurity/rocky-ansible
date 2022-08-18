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
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py &&\
    python3 get-pip.py &&\
    python3 -m pip install ansible --prefix /usr/local/

ENTRYPOINT [ "/bin/bash" ]
