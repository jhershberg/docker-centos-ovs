#!/bin/sh
ovs_version=$(ovs-vsctl -V | grep ovs-vsctl | awk '{print $4}')
ovs_db_version=$(ovsdb-tool schema-version /usr/share/openvswitch/vswitch.ovsschema)

ext_iface=$(ip a | grep "inet.*eth[01]" | grep -v "172\.99\." | awk '{print $5}')
mgmt_ip=$(ip a | awk '/172\.99\./ {print $2}' | sed -e 's/\/.*//')

# give ovsdb-server and vswitchd some space...
sleep 3
# begin configuring
ovs-vsctl --no-wait -- init
ovs-vsctl --no-wait -- set Open_vSwitch . db-version="${ovs_db_version}"
ovs-vsctl --no-wait -- set Open_vSwitch . ovs-version="${ovs_version}"
ovs-vsctl --no-wait -- set Open_vSwitch . system-type="docker-ovs"
ovs-vsctl --no-wait -- set Open_vSwitch . system-version="0.1"
ovs-vsctl --no-wait -- set Open_vSwitch . external-ids:system-id=`cat /proc/sys/kernel/random/uuid`
ovs-vsctl --no-wait -- set Open_vSwitch . Other_Config:provider_mappings=physnet:$ext_iface
ovs-vsctl --no-wait -- set-manager ptcp:6640:$mgmt_ip
ovs-appctl -t ovsdb-server ovsdb-server/add-remote db:Open_vSwitch,Open_vSwitch,manager_options

