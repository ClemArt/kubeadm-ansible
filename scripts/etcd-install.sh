#!/bin/bash
# From https://github.com/etcd-io/etcd/releases/tag/v3.4.2
set -e

ETCD_VER=v3.4.2

mkdir -p /opt/etcd

# choose either URL
GOOGLE_URL=https://storage.googleapis.com/etcd
GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
DOWNLOAD_URL=${GITHUB_URL}

curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /opt/etcd-${ETCD_VER}-linux-amd64.tar.gz

tar xzvf /opt/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /opt/etcd --strip-components=1

/opt/etcd/etcd --version
/opt/etcd/etcdctl version

cp /tmp/scripts/etcd.service /etc/systemd/system/

systemctl daemon-reload
systemctl enable etcd
systemctl restart --no-block etcd
