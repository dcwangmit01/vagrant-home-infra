#!/bin/bash
set -x # echo on

# All of the following variables may be overridden on the command line
#   through ENV variables
COMMAND=${COMMAND:-"sudo"} # debug by overriding to "echo"
BACKUP_DIR=${BACKUP_DIR:-"/vagrant/backups"}
DATE=`date +%Y%m%d`
TARGET=${TARGET:-"${BACKUP_DIR}/${DATE}"}

# Ensure the backup directory exists
${COMMAND} mkdir -p ${BACKUP_DIR}

# Create a new backup
pushd /vagrant
${COMMAND} docker-compose stop
${COMMAND} rsync -a /docker ${TARGET}
${COMMAND} docker-compose up -d
popd

# Delete backups more than the last N
${COMMAND} chown -R vagrant:vagrant $BACKUP_DIR
pushd $BACKUP_DIR && ls -1qt | tail -n +5 | xargs -n 1 ${COMMAND} rm -rf && popd

