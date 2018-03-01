# Openvswitch on CentOS Docker Image
This directory contains a Dockerfile and supporting files 
for creating a docker image that runs OpenVSwitch on CentOS.

## Build
1. Obtain or compile an RPM of OpenVSwitch. The directions in ovs/INSTALL.Fedora work just fine
2. Place the resulting RPM in in this directory
3. Edit the OVSRPM environment variable in the Dockerfile to be the name of your RPM
4. Run docker build on this directory
## Run
The manager and controller connections are managed via an environment variable, MODE,
which must be passed in when the container is spun up. This MODE may have one of
the following four forms:
 * MODE=none - will result in no manager or controller being set
 * MODE=ptcp - except passive manager tcp conntections 
 * MODE=tcp - set the manager and controller IPs to the value of the default route
 * MODE=tcp:<IP> - set the manager and controller IPs to the IP specified. Generally speaking, you will not need this option

To run the docker image say, "sudo docker run -itd -e MODE=none --cap-add NET_ADMIN name_of_your_image"

## Credits
This work is largely based on that of Dave Tucker: https://github.com/dave-tucker/docker-ovs 
Thanks, Dave.
