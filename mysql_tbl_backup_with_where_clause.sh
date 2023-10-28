#!/bin/bash

# we required data from multiple tables with a selected period of time
#
# Replace MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD with your credentials
# To run file via unix command
# sh tbl_backup_with_where.sh tablenames.txt DB_NAME Columnname ColumnValue
#
# For example : 
# tablenames.txt contains table1, table2, table3 
# sh tbl_backup_with_where.sh tablenames.txt mydatabase date 2023-10-27


DIR=/PATH/TO/BACKUP/
host=MYSQL_HOST
user=MYSQL_USER
passwd=MYSQL_PASSWORD

tblfilelist=$1
dbname=$2
whereField=$3
whereValue=$4

mkdir -p $DIR/$dbname
if [ $? -eq 1 ];then
  echo "Directory $DB already exists.."
  echo "Make sure it is empty or does not contain backup so as to avoid overwrite of table"
fi
chmod 777 $DIR/$dbname

tbllist=`cat $tblfilelist`

for i in $tbllist
do
    echo "backup started for $dbname $i"
    `mysqldump -h$host -u$user -p$passwd --quick  --single-transaction  $dbname $i --where=" $whereField<='$whereValue' " | gzip  > $DIR/$dbname/$i.sql.gz`
    echo "backup done for $dbname $i"
done