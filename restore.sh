#!/bin/sh

if [ $# -lt 2 ]; then
	echo $0 "<mariadb data container name> <backupfile>"
	exit 1
fi

tar xvf $2

docker run --rm --volumes-from $1 -v $(pwd):/backup ubuntu bash -c "cd /var/lib && tar zxvf /backup/backup_mariadb.tar.gz"
tar zxvf backup_files.tar.gz -C redmine
tar zxvf backup_plugins.tar.gz -C redmine
tar zxvf backup_themes.tar.gz -C redmine

rm -f backup_mariadb.tar.gz
rm -f backup_files.tar.gz
rm -f backup_plugins.tar.gz
rm -f backup_themes.tar.gz
