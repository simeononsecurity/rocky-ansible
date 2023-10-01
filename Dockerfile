FROM rockylinux:9

LABEL org.opencontainers.image.source="https://github.com/simeononsecurity/rocky-ansible"
LABEL org.opencontainers.image.description="Ansible Controller running on Rockylinux 8"
LABEL org.opencontainers.image.authors="simeononsecurity"

ENV container docker
ENV TERM=xterm

# Install packages
RUN yum -yq update &&\
    yum -yq install 'dnf-command(config-manager)' epel-release &&\
    yum config-manager --add-repo='https://packages.microsoft.com/config/rhel/8/prod.repo' &&\
    yum config-manager --add-repo='https://download.docker.com/linux/centos/docker-ce.repo' &&\
    yum config-manager --set-enabled extras &&\
    yum config-manager --set-enabled crb &&\
    yum -yq update &&\
    yum -yq install bash-completion bind bind-utils cargo cifs-utils dhcp-server dnf-plugins-core dos2unix gcc gcc-c++ genisoimage git libevent-devel libffi-devel libnsl libxml2 libxslt mlocate nano ncurses-compat-libs net-tools nfs-utils openssl openssl-devel postgresql python3-devel python39 python3-pip redhat-rpm-config rsync rsyslog samba samba-client sharutils sshpass tcpdump tmux tree wget wireshark zip

# Install Python PIP and Ansible
#RUN alternatives --set python /usr/bin/python3
#RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python3 get-pip.py
RUN python3 -m pip install --no-cache-dir setuptools setuptools_rust &&\
    python3 -m pip install --no-cache-dir wheel cryptography &&\
    python3 -m pip install --upgrade pip &&\
    python3 -m pip install --no-cache-dir ansible --prefix /usr/local/ &&\
    python3 -m pip install --no-cache-dir Jinja2 MarkupSafe PyYAML ansible-lint ansible-lint-junit ansible-pylibssh cot cryptography docker docker-compose firewall jmespath lxml markovify netaddr pandas paramiko pyOpenSSL pypsrp pyvmomi pywinrm setuptools_rust wheel xlrd yamllint &&\
    yum -y --nobest install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm &&\
    yum -y --nobest --skip-broken install ansible

# Preinstall some highly used ansible modules from the galaxy repo
RUN ansible-galaxy collection install ansible.netcommon &&\
    ansible-galaxy collection install ansible.utils &&\
    ansible-galaxy collection install ansible.windows &&\
    ansible-galaxy collection install community.general &&\
    ansible-galaxy collection install community.vmware &&\
    ansible-galaxy collection install community.windows

# Clean RPM Cache
RUN dnf clean all

ENTRYPOINT [ "/bin/bash" ]
