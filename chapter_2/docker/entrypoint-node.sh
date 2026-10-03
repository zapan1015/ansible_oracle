#!/bin/bash
set -e

SHARED_PUB_KEY="/shared-keys/id_rsa.pub"

setup_ssh_key() {
    local TARGET_USER=$1
    local USER_HOME=$(eval echo "~${TARGET_USER}")

    mkdir -p "${USER_HOME}/.ssh"
    chmod 700 "${USER_HOME}/.ssh"

    if [ -f "${SHARED_PUB_KEY}" ]; then
        cat "${SHARED_PUB_KEY}" > "${USER_HOME}/.ssh/authorized_keys"
        chmod 600 "${USER_HOME}/.ssh/authorized_keys"
        chown -R "${TARGET_USER}:oinstall" "${USER_HOME}/.ssh"
    fi
}

setup_ssh_key oracle
setup_ssh_key grid
setup_ssh_key root

ssh-keygen -A 2>/dev/null || true

echo "=================================================="
echo "Oracle Managed Node '$(hostname)' (Chapter 2) is ready."
echo "IP: $(hostname -I | awk '{print $1}')"
echo "SSHD service starting on port 22..."
echo "=================================================="

exec /usr/sbin/sshd -D -e
