#!/usr/bin/env bash

DB1=$1;
mysql -uroot -proot -e "DROP DATABASE IF EXISTS $DB1";
mysql -uroot -proot -e "CREATE DATABASE $DB1";
echo 'db.addUser("root", "root", false);' | mongo $DB1
