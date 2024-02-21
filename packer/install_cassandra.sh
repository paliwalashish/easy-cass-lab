#!/bin/bash

# creating cassandra user
sudo useradd -m cassandra

mkdir cassandra
sudo mkdir -p /usr/local/cassandra
sudo mkdir -p /mnt/cassandra
sudo chown -R cassandra:cassandra /mnt/cassandra

lsblk

# shellcheck disable=SC2164
(
cd cassandra

yq '.[].url' /etc/cassandra_versions.yaml | xargs -I{} wget {}

for f in *.tar.gz;
do
    tar zxvf "$f";
    rm -f "$f";
done

#regex="apache-cassandra-([0-9].[0-9*])"

# extracts the version number from the directory name
regex="apache-cassandra-([0-9].[0-9*]+(-beta[0-9])?)"

for f in apache-cassandra-*/;
do
  if [[ $f =~ $regex ]]; then
    version="${BASH_REMATCH[1]}"
    echo "Moving $f to $version"
    rm -rf $f/data
    cp conf/cassandra.yaml conf/cassandra.yaml.orig
    sudo mv "$f" /usr/local/cassandra/$version;
  fi
done

sudo chown -R cassandra:cassandra /usr/local/cassandra
)
