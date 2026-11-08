# Chapter 5: Ansible 반복문(Loops) 실습 (Oracle DBA)

이 디렉토리는 오라클 DBA를 위한 **Ansible 반복문(Loops)**을 실습하기 위한 Docker 기반 가상 실습 환경입니다.  
교재(`docs/76_ansible_loops_for_oracle_dba.md`)의 **Chapter 12 마스터 프로젝트 및 실습 시나리오(Hands-on Scenario)**를 온전히 재현하여, 여러 오라클 서버와 인스턴스에 걸친 디렉터리 생성, 리스너 상태 점검, 헬스 리포트 일괄 수집 자동화를 실습합니다.

---

## 1. 아키텍처 및 노드 구성

| 컨테이너명 | 호스트명 | 역할 | IP 주소 | 설명 |
|---|---|---|---|---|
| `ansible-control-ch5` | `ansible-control` | 제어 노드 (Control Node) | `192.168.5.10` | 앤서블 명령 및 플레이북 실행 머신 |
| `db1` | `db1` | 관리 노드 1 (Oracle Node 1) | `192.168.5.101` | 오라클 서버 1 (`ORCL` 인스턴스) |
| `db2` | `db2` | 관리 노드 2 (Oracle Node 2) | `192.168.5.102` | 오라클 서버 2 (`TEST` 인스턴스) |
| `db3` | `db3` | 관리 노드 3 (Oracle Node 3) | `192.168.5.103` | 오라클 서버 3 (`DEV` 인스턴스) |

---

## 2. 프로젝트 디렉터리 구조

```text
chapter_5/
├── docker-compose.yml
├── docker/
│   ├── Dockerfile.control
│   ├── Dockerfile.oracle_node
│   ├── entrypoint-node.sh
│   └── mocks/
│       ├── sqlplus
│       ├── lsnrctl
│       ├── health_report.sql
│       └── health_check.sql
├── ansible-oracle-project/
│   ├── ansible.cfg
│   ├── inventory/
│   │   └── hosts.ini
│   └── playbooks/
│       ├── 01_basic_loops.yml         # 실습 2: 문자열/숫자/변수 기본 반복문
│       ├── 02_list_and_dict.yml       # 실습 3: 리스트 및 dict2items 반복
│       ├── 03_loop_when.yml           # 실습 4: when 조건 결합 및 skipping 검증
│       ├── 04_master_create_dirs.yml  # 실습 5: 마스터 프로젝트 - 멀티 홈 디렉터리 일괄 생성
│       ├── 05_check_listeners.yml     # 실습 6: 리스너 상태 확인 및 register, label
│       ├── 06_collect_reports.yml     # 실습 7: 다중 DB 헬스 리포트 수집
│       └── 07_troubleshooting.yml     # 실습 8: 반복문 디버깅 및 안전한 패턴
└── README.md
```

---

## 3. 실습 환경 시작 방법

### 1) 컨테이너 기동
터미널에서 `chapter_5` 디렉터리로 이동한 후 다음 명령어를 실행하여 컨테이너를 빌드하고 백그라운드로 실행합니다.

```bash
docker compose up -d --build
```

### 2) 제어 노드 접속
Ansible 명령어를 실행할 제어 노드 컨테이너에 접속합니다.

```bash
docker exec -it ansible-control-ch5 bash
```

---

## 4. 단계별 실습 가이드

제어 노드에 접속한 상태(`/home/oracle/ansible-oracle-project`)에서 아래 순서대로 실습을 진행합니다.

### 0단계. 노드 통신 확인 (실습 1)
```bash
ansible all -m ping
```

### 1단계. 기본 반복문 익히기 (실습 2)
```bash
ansible-playbook playbooks/01_basic_loops.yml
```

### 2단계. 리스트와 딕셔너리 반복 (실습 3)
```bash
ansible-playbook playbooks/02_list_and_dict.yml
```

### 3단계. 조건문과 결합 (실습 4)
```bash
ansible-playbook playbooks/03_loop_when.yml
```

### 4단계. 마스터 프로젝트 - 디렉터리 일괄 생성 (실습 5)
```bash
# 문법 검사
ansible-playbook --syntax-check playbooks/04_master_create_dirs.yml

# 점검 모드(Dry-run) 실행
ansible-playbook --check playbooks/04_master_create_dirs.yml

# 실제 실행
ansible-playbook playbooks/04_master_create_dirs.yml
```

### 5단계. 리스너 상태 확인 및 레이블 검증 (실습 6)
```bash
ansible-playbook playbooks/05_check_listeners.yml
```

### 6단계. 다중 DB 헬스 리포트 수집 (실습 7)
```bash
# 플레이북 실행 (각 DB별 헬스 리포트 생성)
ansible-playbook playbooks/06_collect_reports.yml

# 대상 노드들에 생성된 리포트 로그 파일 확인
ansible oracle_servers -m shell -a "ls -l /tmp/health_*.log"
ansible oracle_servers -m shell -a "head -n 5 /tmp/health_ORCL.log"
```

### 7단계. 문제 해결 및 안전한 반복문 패턴 (실습 8)
```bash
ansible-playbook playbooks/07_troubleshooting.yml
```

---

## 5. 실습 종료 및 환경 정리

실습을 마치고 리소스를 정리하려면 다음 명령어를 실행합니다.

```bash
# 제어 노드에서 빠져나오기
exit

# 컨테이너 및 공유 볼륨 정리
docker compose down -v
```
