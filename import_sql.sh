#!/bin/bash

db=$1
file="$2"
user="root"

echo "=> Starting MySQL Server"
/usr/bin/mysqld_safe > /dev/null 2>&1 &
PID=$!

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MySQL service startup"
    sleep 5
    mysql -u"$user" -e "status" > /dev/null 2>&1
RET=$?
done

echo "   Started with PID ${PID}"

echo "=> Importing SQL file"
mysql -u"$user" "$db" < "$file" || exit $?

echo "=> Stopping MySQL Server"
mysqladmin -u"$user" shutdown

echo "=> Done!"
