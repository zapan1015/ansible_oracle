#!/bin/bash
set -e

# 1. 공유 SSH 공개키 등록
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
setup_ssh_key root

# 2. Host key 확인 및 생성
ssh-keygen -A 2>/dev/null || true

# 3. 소유권 보장
chown -R oracle:oinstall /u01 /reports 2>/dev/null || true
chmod -R 775 /u01 /reports 2>/dev/null || true

echo "=================================================="
echo "Oracle Node '$(hostname)' is ready for Chapter 10."
echo "IP: $(hostname -I | awk '{print $1}')"
echo "SSHD service starting on port 22..."
echo "=================================================="

# 4. SSHD 데몬 실행
exec /usr/sbin/sshd -D -e
