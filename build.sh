# defines
TARGETIP=192.168.1.122
OLDPROGRAMPATH=/tmp/efr32_ctl
EXECUTABLE=efr32_ctl
# make the target
sshpass -p 'Kunai1984' ssh phuong.nguyendinh@192.168.1.150 "sh -c \
	'cd /VERIK5TB2/phuong.nguyendinh/wnc_nodes_dev_db/;make -C chiron efr32_ctl.clean;make -C chiron efr32_ctl.all;\
	cp chiron/output/debug/efr32_ctl/install/usr/bin/efr32_ctl lego_overlay/proprietary/efr32_ctl/efr32_ctl/'"

# remove old executable on target
sshpass -p 'admin' ssh -oKexAlgorithms=+diffie-hellman-group1-sha1 -n -f root@$TARGETIP \
	"sh -c 'killall efr32_ctl'"
sshpass -p 'admin' ssh -oKexAlgorithms=+diffie-hellman-group1-sha1 root@$TARGETIP rm $OLDPROGRAMPATH

# copy over new executable
echo 'copy over new executable:' $EXECUTABLE $TARGETIP
sshpass -p 'admin' scp -oKexAlgorithms=+diffie-hellman-group1-sha1 $PWD/$EXECUTABLE root@$TARGETIP:/tmp
echo "done"
