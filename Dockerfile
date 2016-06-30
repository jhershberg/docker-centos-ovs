FROM centos:latest
ENV OVS_VERSION 2.5.0
ENV OVS_RPM openvswitch-${OVS_VERSION}-1.fc23.x86_64.rpm
ENV OVS_TARBALL openvswitch-${OVS_VERSION}.tar.gz
# Configure supervisord
RUN mkdir -p /var/log/supervisor/
ADD supervisord.conf /etc/

# Install supervisor_stdout
WORKDIR /opt
RUN mkdir -p /var/log/supervisor/
RUN mkdir -p /etc/openvswitch
RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    pip install setuptools && \
    pip install supervisor && \
    pip install supervisor-stdout

# Get Open vSwitch
ADD $OVS_RPM /root
ADD $OVS_TARBALL /root
WORKDIR /root
RUN yum install -y openssl iproute net-tools && \
    rpm -i $OVS_RPM && \
    rm -v $OVS_RPM && \
    yum -v clean all && \
    mkdir -p /var/run/openvswitch/ && \
    mkdir /dev/net && \
    mknod /dev/net/tun c 10 200 && \
    cd openvswitch-${OVS_VERSION}/python/ &&\
    python setup.py install && \
    cd /root && \
    rm -fvr $OVS_TARBALL openvswitch-${OVS_VERSION}/
ADD configure-ovs.sh /usr/share/openvswitch/
ADD mk-net-dev.sh /usr/share/openvswitch/
# Create the databases
RUN ovsdb-tool create /etc/openvswitch/conf.db /usr/share/openvswitch/vswitch.ovsschema
RUN ovsdb-tool create /etc/openvswitch/vtep.db /usr/share/openvswitch/vtep.ovsschema



CMD ["/usr/bin/supervisord"]
