#!/bin/sh

if [ $# -lt 1 ]; then
	echo $0 "<mariadb data container name>"
	echo $0 "<mariadb data container name> <backup file>"
	exit 1
fi

TODAY=`date '+%F_%H%M'`
OUTPUT_FILE=backup-$TODAY.tar

if [ $# -ge 2 ]; then
    OUTPUT_FILE=$2
fi

docker run --rm --volumes-from $1 -v $(pwd):/backup ubuntu tar zcvf /backup/backup_mariadb.tar.gz -C /var/lib mysql
tar zcvf backup_files.tar.gz -C redmine files
tar zcvf backup_plugins.tar.gz -C redmine plugins
tar zcvf backup_themes.tar.gz -C redmine themes

tar cvf $OUTPUT_FILE backup_mariadb.tar.gz backup_files.tar.gz backup_plugins.tar.gz backup_themes.tar.gz

rm -f backup_mariadb.tar.gz
rm -f backup_files.tar.gz
rm -f backup_plugins.tar.gz
rm -f backup_themes.tar.gz
