#!/bin/bash
# ========================================================
# Helper script to run playbooks from inside Ansible Control Node
# ========================================================

set -e

PLAYBOOK=${1:-"playbooks/01_ping_check.yml"}
EXTRA_ARGS=${@:2}

echo "=================================================="
echo "Running Ansible Playbook: $PLAYBOOK"
echo "=================================================="

ansible-playbook -i inventory/hosts "$PLAYBOOK" $EXTRA_ARGS
