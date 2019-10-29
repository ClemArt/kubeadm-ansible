FROM centos:7

RUN yum install -y openssh-server python2 sudo iproute iptables

RUN systemctl enable sshd

COPY id_rsa.pub /tmp/pubkey
COPY centos-pwdless /etc/sudoers.d/centos-pwdless

RUN useradd --create-home centos && \
    umask 077 && mkdir /home/centos/.ssh && \
    mv /tmp/pubkey /home/centos/.ssh/authorized_keys && \
    chown -R centos:centos /home/centos && \
    chmod 755 /home/centos/.ssh && \
    chmod 600 /home/centos/.ssh/* && \
    chmod 600 /etc/sudoers.d/*


VOLUME ["/sys/fs/cgroup"]
CMD ["/sbin/init"]