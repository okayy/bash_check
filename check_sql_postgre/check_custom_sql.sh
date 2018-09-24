#!/bin/bash

host="111.111.111.111"
port="5432"
database="dbname"
user="user"
PGPASSWORD="pass"
under="<="

usage()
{
cat << EOF
Usage: $0 [-q <query>] [-c <critical>] [-u <under>]

"-u" if you need to check less than the value
EOF
}

if [ -z "$*" ] || [ $# -lt 4 ]
then
    usage
    exit 1
fi

while getopts ":q:c:u" OPTION; do
     case $OPTION in
         q)
             query="$OPTARG"
             ;;
         c)
             critical="$OPTARG"
             ;;
         u)
             under=">="
             ;;
         h)
            usage
            exit
            ;;
         ?)
            echo "Error: Invalid option -$OPTARG" >&2
            usage
            exit
            ;;
         *)
            usage
            exit
            ;;
     esac
done

QUERY=$(PGPASSWORD=${PGPASSWORD} psql -t -h ${host} -p ${port} -U ${user} -d ${database} -c "$query" )


if (( $(echo "$QUERY $under $critical" |bc -l) )); then
    echo "OK - $QUERY"
    exit 0
fi
    echo "Critical - $QUERY"
exit 2

