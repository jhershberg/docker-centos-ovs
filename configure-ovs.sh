#!/bin/sh
ovs_version=$(ovs-vsctl -V | grep ovs-vsctl | awk '{print $4}')
ovs_db_version=$(ovsdb-tool schema-version /usr/share/openvswitch/vswitch.ovsschema)

# give ovsdb-server and vswitchd some space...
sleep 3
# begin configuring
ovs-vsctl --no-wait -- init
ovs-vsctl --no-wait -- set Open_vSwitch . db-version="${ovs_db_version}"
ovs-vsctl --no-wait -- set Open_vSwitch . ovs-version="${ovs_version}"
ovs-vsctl --no-wait -- set Open_vSwitch . system-type="docker-ovs"
ovs-vsctl --no-wait -- set Open_vSwitch . system-version="0.1"
ovs-vsctl --no-wait -- set Open_vSwitch . external-ids:system-id=`cat /proc/sys/kernel/random/uuid`

LOCAL_IP=$(ip a show eth0 | awk '/inet / {print $2}' | grep -o ^[^/]*)
CONTROLLER_IP=$(ip route | grep default | cut -d\  -f3)
ovs-vsctl set Open_vSwitch . other_config:local_ip=$LOCAL_IP
ovs-vsctl --no-wait -- add-br br-int
ovs-vsctl --no-wait -- set-controller br-int tcp:${CONTROLLER_IP}:6653
ovs-vsctl --no-wait -- set-manager tcp:${CONTROLLER_IP}:6640
ovs-appctl -t ovsdb-server ovsdb-server/add-remote db:Open_vSwitch,Open_vSwitch,manager_options

