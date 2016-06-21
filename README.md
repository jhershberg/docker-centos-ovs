# Openvswitch on CentOS Docker Image
This directory contains a Dockerfile and supporting files 
for creating a docker image that runs OpenVSwitch on CentOS.

## Usage
1. Obtain or compile an RPM *and* tar.gz of OpenVSwitch. The directions in ovs/INSTALL.Fedora work just fine and builds the rpm and tar.gz
2. Place the resulting RPM and tar.gz in in this directory
3. Edit the OVS_VERSION environment variable in the Dockerfile to be the correct version
4. Run docker build on this directory
5. To run the docker image say, "sudo docker run -itd --cap-add NET_ADMIN -p 6641:6640 name_of_your_image"

## Credits
This work is largely based on that of Dave Tucker: https://github.com/dave-tucker/docker-ovs 
Thanks, Dave.
