BACKUP_PG_DB() {
    BACKUP_DIR=$HOME/archive/${TARGET}/postgresql
    DUMP_FILE=/var/lib/postgresql/${1}_${TIMESTAMP}.dump.bz2
    ssh root@${TARGET} "cd /var/lib/postgresql && doas -u postgres /usr/bin/pg_dump -Fc ${1} | /usr/bin/bzip2 > ${DUMP_FILE}"
    mkdir -p $HOME/archive/${TARGET}/postgresql/
    rsync -tav ${TARGET}:${DUMP_FILE} $HOME/archive/${TARGET}/postgresql/
    ssh root@${TARGET} rm -v ${DUMP_FILE}

    # Only remove older backups if newer backups exist
    NEWER_BACKUPS=$(find $BACKUP_DIR -mtime -60 -type f -name "${1}_*.dump.bz2")
    if [[ -n $NEWER_BACKUPS ]]; then
        find $BACKUP_DIR -mtime +60 -type f -name "${1}_*.dump.bz2" -delete
    else
        echo "No newer backups found. Old backups not pruned."
    fi
}
BACKUP_MAIL() {
    mkdir -p $HOME/archive/${TARGET}/{dovecot,postfix}
    rsync -tav root@${TARGET}:/etc/dovecot/imap.passwd $HOME/archive/${TARGET}/
    rsync -tav root@${TARGET}:/etc/postfix/virtual $HOME/archive/${TARGET}/postfix
}