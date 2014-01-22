
if [ -e /etc/redhat-release ] ; then
    yum install -y openssh-server git screen which python-virtualenv gcc libxml2-devel libxslt-devel tcpdump vim-enhanced
elif [ -e /etc/debian_version ] ; then
    apt-get install -y openssh-server git screen gcc libxml2-dev libxslt1-dev tcpdump vim gcc make zlib1g-dev curl libssl-dev

    # sshd in ubuntu containers wont work on fedora, some selinux problem
    cd /tmp
    curl http://ftp.heanet.ie/pub/OpenBSD/OpenSSH/portable/openssh-6.4p1.tar.gz > openssh-6.4p1.tar.gz
    gunzip openssh-6.4p1.tar.gz
    tar -xf openssh-6.4p1.tar
    cd openssh-6.4p1
    ./configure --sysconfdir=/etc/ssh/
    make
    mkdir /var/empty
    rm -rf /usr/sbin/sshd
    ln -s /tmp/openssh-6.4p1/sshd /usr/sbin/sshd
fi

ssh-keygen -N '' -f /root/.ssh/id_rsa
cd /root/
echo %SSHKEY% > .ssh/authorized_keys
echo alias vi=vim >> ~/.bashrc

if [ -e /etc/redhat-release ] ; then
    /usr/sbin/sshd-keygen
    yum clean -y all
elif [ -e /etc/debian_version ] ; then
    mkdir -p -m0755 /var/run/sshd
    apt-get clean
fi
