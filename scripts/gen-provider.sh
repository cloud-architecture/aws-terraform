#!/bin/bash
#
# Init variables and sanity checks
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
ROOT_DIR=$(dirname $DIR)
BUILD=${BUILD:-$ROOT_DIR/build}

AWS_PROFILE=${AWS_PROFILE:-coreos-cluster}
AWS_USER=${AWS_USER:-coreos-cluster}
CLUSTER_NAME=${CLUSTER_NAME:-coreos-cluster}

TF_VAR_aws_access_key=$($DIR/read_cfg.sh $HOME/.aws/credentials $AWS_PROFILE aws_access_key_id)
TF_VAR_aws_secret_key=$($DIR/read_cfg.sh $HOME/.aws/credentials $AWS_PROFILE aws_secret_access_key)
TF_VAR_aws_region=$($DIR/read_cfg.sh $HOME/.aws/config "profile $AWS_PROFILE" region)
TF_VAR_aws_account=$(aws --profile $AWS_PROFILE iam get-user --user-name=$AWS_USER | jq ".User.Arn" | grep -Eo '[[:digit:]]{12}')

cat <<EOF
# Generated by scripts/gen-provider.sh
provider "aws" {
  access_key = "$TF_VAR_aws_access_key"
  secret_key = "$TF_VAR_aws_secret_key"
  region = "$TF_VAR_aws_region"
  allowed_account_ids = [ "$TF_VAR_aws_account" ]
}
variable "aws_account" {
    default = {
        id = "$TF_VAR_aws_account"
        user = "$PROFILE"
        defualt_region = "$TF_VAR_aws_region"
    }
}
variable "cluster_name" {
    default = "${CLUSTER_NAME}"
}
variable "build_dir" {
    default = "${BUILD}"
}
EOF
