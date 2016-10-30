# Openvswitch on CentOS Docker Image
This directory contains a Dockerfile and supporting files 
for creating a docker image that runs OpenVSwitch on CentOS.
This image must be connected to two networks, one designated for management traffic and one
designated for access to the external network. The IPs alotted to the container MUST be:
* On the management network: 172.28.5.1<0-9>
* On the external network: 172.29.5.1<0-9>

## Usage
1. Obtain or compile an RPM of OpenVSwitch. The directions in ovs/INSTALL.Fedora work just fine
2. Place the resulting RPM in in this directory
3. Edit the OVSRPM environment variable in the Dockerfile to be the name of your RPM
4. Run docker build on this directory

## Credits
This work is largely based on that of Dave Tucker: https://github.com/dave-tucker/docker-ovs 
Thanks, Dave.
