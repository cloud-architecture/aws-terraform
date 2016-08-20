#!/bin/bash -e
#
# Init variables and sanity checks
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
ROOT_DIR=$(dirname $DIR)
BUILD=${BUILD:-$ROOT_DIR/build}

file=$1
if [ -z "$file" ]; then
  echo "Output file cannot be empty."
  exit 1
fi

# Database password: has to be ASCII alphanumeric
postgres_db_password=$(openssl rand -base64 14 | tr -dc 'a-zA-Z0-9')
mysql_db_password=$(openssl rand -base64 14 |  tr -dc 'a-zA-Z0-9')
cat > $file  <<EOF
# Generated by scripts/gen-provider.sh
variable "postgres_db_user" {
  default = "root"
}
variable "postgres_db_password" {
  default = "$postgres_db_password"
}
variable "mysql_db_user" {
  default = "root"
}
variable "mysql_db_password" {
  default = "$mysql_db_password"
}
EOF