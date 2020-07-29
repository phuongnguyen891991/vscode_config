# defines
IPSERVER=172.16.1.150
SERVER_PASS=phuong.nguyen
TARGETIP=192.168.1.1
OLDPROGRAMPATH=/tmp/var/config/efr32_ctl
EXECUTABLE=efr32_ctl
WORK_FILE=/VERIK5TB1/phuong.nguyen/wnc_nodes_dev_db/chiron/output/release/efr32_ctl/install/usr/bin/efr32_ctl
# make the target
# sshpass -p 'phuong.nguyen' ssh phuong.nguyen@192.168.1.150 "sh -c \
# 	'cd /VERIK5TB1/phuong.nguyendinh/wnc_nodes_dev_db/;make -C chiron efr32_ctl.clean;make -C chiron efr32_ctl.all;\
# 	cp chiron/output/debug/efr32_ctl/install/usr/bin/efr32_ctl lego_overlay/proprietary/efr32_ctl/efr32_ctl/'"
sshpass -p $SERVER_PASS scp phuong.nguyen@$IPSERVER:$WORK_FILE ./

# kill gdbserver on target
sshpass -p 'admin' ssh -oKexAlgorithms=+diffie-hellman-group1-sha1 root@$TARGETIP killall gdbserver
# remove old executable on target
sshpass -p 'admin' ssh -oKexAlgorithms=+diffie-hellman-group1-sha1 root@$TARGETIP rm $OLDPROGRAMPATH
# copy over new executable
echo 'copy over new executable:' $EXECUTABLE $TARGETIP
sshpass -p 'admin' scp -oKexAlgorithms=+diffie-hellman-group1-sha1 $PWD/$EXECUTABLE root@$TARGETIP:/tmp/var/config
# start gdb on target (IS ONE LONG COMMAND)
sshpass -p 'admin' ssh -oKexAlgorithms=+diffie-hellman-group1-sha1 -n -f root@$TARGETIP \
	"sh -c 'cd /tmp/var/config;export LD_LIBRARY_PATH=/tmp/var/config:$LD_LIBRARY_PATH;\
	/tmp/var/config/gdbserver 192.168.1.1:4444 /tmp/var/config/efr32_ctl > /dev/null 2>&1 &'"
echo "done"
