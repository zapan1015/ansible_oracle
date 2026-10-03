# Chapter 1: Ansible 기초와 오라클 19c RAC 자동화 실습 환경

이 디렉토리는 `docs/ansible_oracle_dba_manuscript.md`의 **Chapter 1: 앤서블 기초와 오라클 DBA 자동화 환경 구축** 및 **Oracle RAC 19c 환경**을 직접 실습할 수 있도록 제작된 Docker 기반 완전 자동화 랩 환경입니다.

---

## 1. 디렉터리 구성

```text
chapter_1/
├── docker-compose.yml              # 제어 노드 및 Oracle 19c 관리 노드(db01, db02, grid01) 오케스트레이션
├── docker/
│   ├── Dockerfile.control          # Ansible Control Node (Python3.9, Ansible, OpenSSH Client)
│   ├── Dockerfile.oracle_node      # Oracle 19c Managed Node (Oracle Linux 8, SSHD, oracle/grid 유저)
│   └── entrypoint-node.sh          # 관리 노드 자동 기동 및 SSH 키 설정 스크립트
├── ansible-oracle-dba/             # 원고 12장 마스터 프로젝트 구현체
│   ├── ansible.cfg                 # 프로젝트 수준 앤서블 최적화 설정 파일
│   ├── inventory/
│   │   ├── hosts                   # INI 형식 인벤토리
│   │   └── hosts.yml               # YAML 형식 인벤토리
│   ├── group_vars/                 # 그룹별 변수 (db_servers, grid_servers, rac_nodes 등)
│   ├── host_vars/                  # 호스트별 변수 (db01, db02, grid01)
│   ├── playbooks/
│   │   ├── 01_ping_check.yml       # 연결 점검 플레이북
│   │   ├── 02_setup_oracle_env.yml # 12.6절 마스터 실습 플레이북 (디렉터리 생성 및 권한 검증)
│   │   ├── 03_oracle_19c_precheck.yml # Oracle 19c RAC 사전 요구사항 점검
│   │   └── 04_verify_all.yml       # 최종 환경 종합 검증 플레이북
│   └── scripts/
│       └── run_playbook.sh         # 플레이북 실행 헬퍼 스크립트
├── rac_19c_architecture/           # Oracle 공식 RAC 19c on Container 완벽 가이드
│   ├── README.md                   # 아키텍처/네트워크/ASM/공식 Dockerfile 빌드 가이드
│   └── rac19c.env                  # RAC 19c 환경 변수 템플릿
└── README.md                       # 본 안내 파일
```

---

## 2. 노드 및 IP 주소 할당표

| 호스트명 | 역할 | IP 주소 | 설명 |
|---|---|---|---|
| `ansible-control` | **제어 노드 (Control Node)** | `192.168.1.10` | 앤서블 명령 및 플레이북 실행 머신 |
| `db01` | **관리 노드 1 (RAC Node 1)** | `192.168.1.101` | Oracle Database 19c 인스턴스 1 (`ORCL1`) |
| `db02` | **관리 노드 2 (RAC Node 2)** | `192.168.1.102` | Oracle Database 19c 인스턴스 2 (`ORCL2`) |
| `grid01` | **관리 노드 3 (Grid/ASM)** | `192.168.1.103` | Grid Infrastructure 19c & ASM 관리 노드 |

---

## 3. 실습 환경 시작 및 실행 방법

### Step 1. 컨테이너 빌드 및 실행
`chapter_1` 디렉터리에서 아래 명령을 실행합니다:

```bash
cd chapter_1
docker compose up -d --build
```

컨테이너 기동 상태 확인:
```bash
docker compose ps
```

### Step 2. 제어 노드 접속
```bash
docker exec -it ansible-control bash
```

### Step 3. Ansible 연결 확인 (애드혹 명령)
제어 노드 내부(`/home/oracle/ansible-oracle-dba`)에서 실행합니다:

```bash
# 1. 전 노드 Ping 모듈 테스트
ansible all -m ping

# 2. 인벤토리 목록 확인
ansible-inventory --list

# 3. 오라클 계정 확인 애드혹 명령
ansible database_servers -m command -a "id oracle"
```

### Step 4. 플레이북 실행 실습

```bash
# 1. 기본 연결 및 호스트 팩트 수집
ansible-playbook playbooks/01_ping_check.yml

# 2. 12.6절 마스터 실습: Oracle Base 및 Grid 홈 디렉터리 생성
ansible-playbook playbooks/02_setup_oracle_env.yml

# 3. Oracle 19c RAC 사전 점검 플레이북 실행
ansible-playbook playbooks/03_oracle_19c_precheck.yml

# 4. 최종 종합 검증 플레이북 실행
ansible-playbook playbooks/04_verify_all.yml
```

---

## 4. 환경 정리 및 종료

실습이 끝난 후 컨테이너를 중지하고 볼륨을 정리하려면 다음을 실행합니다:

```bash
docker compose down -v
```
