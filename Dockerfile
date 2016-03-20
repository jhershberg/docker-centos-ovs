FROM centos:latest
ENV OVSRPM openvswitch-2.5.1-1.fc22.x86_64.rpm
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
ADD $OVSRPM /root
WORKDIR /root
RUN yum install -y openssl iproute && \
    rpm -i $OVSRPM && \
    rm -v $OVSRPM && \
    mkdir -p /var/run/openvswitch/ && \
    mkdir /dev/net && \
    mknod /dev/net/tun c 10 200
ADD configure-ovs.sh /usr/share/openvswitch/
ADD mk-net-dev.sh /usr/share/openvswitch/
# Create the database
RUN ovsdb-tool create /etc/openvswitch/conf.db /usr/share/openvswitch/vswitch.ovsschema
CMD ["/usr/bin/supervisord"]
