#! /usr/env/bin bash
set -o nounset

declare -r SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"

cd "${SCRIPT_DIR}"/infrastructure || exit 1
source .env &&
terraform init &&
terraform validate &&
terraform plan &&
terraform apply -auto-approve  &&

cd .. || exit 1
source "${SCRIPT_DIR}/script_vars.sh"

# Hang out while the instance comes up
aws ec2 wait instance-status-ok --instance-ids "${a02_web_id}" &&
aws ec2 wait instance-status-ok --instance-ids "${a02_backend_id}" &&
aws rds wait db-instance-available --db-instance-identifier "${a02_db_id}" &&

sleep 10
cd "${SCRIPT_DIR}"/service || exit 1
ansible-playbook main.yml