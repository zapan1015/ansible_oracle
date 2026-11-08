# Chapter 9: Ansible Vault 실습 (Oracle DBA 보안 자동화)

이 디렉토리는 오라클 DBA를 위한 **Ansible Vault 보안 자동화**를 실습하기 위한 Docker 기반 가상 실습 환경입니다.  
교재(`docs/80_vault.md`)의 **민감한 자격 증명(DB 비밀번호, 리스너 비밀번호, RMAN 계정) 암호화, 환경별 Vault ID 분리, 변수 레벨 암호화, `no_log: true` 마스킹 및 Rekey/복호화 실습**을 온전히 재현합니다.

---

## 1. 아키텍처 및 노드 구성

| 컨테이너명 | 호스트명 | 역할 | IP 주소 | 설명 |
|---|---|---|---|---|
| `ansible-control-ch9` | `ansible-control` | 제어 노드 (Control Node) | `192.168.9.10` | 앤서블 명령 및 플레이북 실행 머신 |
| `devdb` | `devdb` | 오라클 관리 노드 (Dev) | `192.168.9.101` | 오라클 개발 DB (`DEVDB` 인스턴스) |
| `proddb` | `proddb` | 오라클 관리 노드 (Prod) | `192.168.9.102` | 오라클 운영 DB (`PRODDB` 인스턴스) |

---

## 2. 프로젝트 디렉터리 구조

```text
chapter_9/
├── docker-compose.yml
├── docker/
│   ├── Dockerfile.control
│   ├── Dockerfile.oracle_node
│   ├── entrypoint-node.sh
│   └── mocks/
│       ├── sqlplus
│       └── lsnrctl
├── ansible-oracle-project/
│   ├── ansible.cfg                    # vault_password_file 설정 포함
│   ├── inventory/
│   │   └── hosts.ini                  # devdb, proddb 호스트 정의
│   ├── vault/
│   │   ├── .vault_pass                # 공통 기본 Vault 비밀번호 파일 (권한: 600)
│   │   ├── .vault_dev_pass            # Dev 전용 Vault 비밀번호 파일
│   │   └── .vault_prod_pass           # Prod 전용 Vault 비밀번호 파일
│   ├── vars/
│   │   ├── vault_common.yml           # 암호화된 공통 Oracle 자격 증명
│   │   ├── dev_vault.yml              # Dev 전용 암호화 변수 (Vault ID: dev)
│   │   └── prod_vault.yml             # Prod 전용 암호화 변수 (Vault ID: prod)
│   └── playbooks/
│       ├── 01_vault_basic.yml         # [실습 2 & 3] Vault 로드 및 no_log 마스킹
│       ├── 02_vault_id_env.yml        # [실습 4] 다중 Vault ID 환경별 분리
│       ├── 03_encrypted_string.yml    # [실습 5] 변수 단위 encrypt_string 활용
│       ├── 04_master_vault_dba.yml    # [실습 6] 마스터 프로젝트 - DB 상태/TBS/리스너 점검
│       └── 05_troubleshooting.yml     # [실습 8] 비밀번호 파일 감사 및 트러블슈팅
└── README.md
```

---

## 3. 실습 환경 시작 방법

### 1) 컨테이너 기동
터미널에서 `chapter_9` 디렉터리로 이동한 후 다음 명령어를 실행하여 컨테이너를 빌드하고 백그라운드로 실행합니다.

```bash
docker compose up -d --build
```

### 2) 제어 노드 접속
Ansible 명령어를 실행할 제어 노드 컨테이너에 접속합니다.

```bash
docker exec -it ansible-control-ch9 bash
```

---

## 4. 단계별 실습 가이드

제어 노드에 접속한 상태(`/home/oracle/ansible-oracle-project`)에서 아래 순서대로 실습을 진행합니다.

### 0단계. 노드 통신 확인 (실습 1)
```bash
ansible all -m ping
```

### 1단계. Vault 파일 암호화 및 조회 (실습 2)
```bash
# 파일 암호화
ansible-vault encrypt vars/vault_common.yml

# 암호화된 내용 확인
ansible-vault view vars/vault_common.yml
```

### 2단계. 기본 Vault 플레이북 실행 (실습 3)
```bash
ansible-playbook playbooks/01_vault_basic.yml
```

### 3단계. 다중 Vault ID 환경별 분리 (실습 4)
```bash
# Dev/Prod 각각 고유 Vault ID로 암호화
ansible-vault encrypt --vault-id dev@vault/.vault_dev_pass vars/dev_vault.yml
ansible-vault encrypt --vault-id prod@vault/.vault_prod_pass vars/prod_vault.yml

# 다중 Vault ID 지정하여 실행
ansible-playbook --vault-id dev@vault/.vault_dev_pass --vault-id prod@vault/.vault_prod_pass playbooks/02_vault_id_env.yml
```

### 4단계. 단일 변수 암호화 (실습 5)
```bash
ansible-playbook playbooks/03_encrypted_string.yml
```

### 5단계. 마스터 프로젝트 - 안전한 Oracle DBA 운영 자동화 (실습 6)
```bash
ansible-playbook playbooks/04_master_vault_dba.yml
```

### 6단계. Vault 암호 변경(Rekey) 및 복호화 검증 (실습 7)
```bash
# 암호 변경
ansible-vault rekey vars/vault_common.yml

# 복호화 및 재암호화
ansible-vault decrypt vars/vault_common.yml
ansible-vault encrypt vars/vault_common.yml
```

### 7단계. 문제 해결 및 보안 감사 (실습 8)
```bash
ansible-playbook playbooks/05_troubleshooting.yml
```

---

## 5. 실습 종료 및 환경 정리

실습을 마치고 리소스를 정리하려면 다음 명령어를 사용합니다.

```bash
exit # 제어 노드에서 나가기
docker compose down -v # 컨테이너 및 볼륨 정리
```
