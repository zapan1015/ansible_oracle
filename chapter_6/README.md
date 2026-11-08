# Chapter 6: Ansible 조건문(Conditions) 실습 (Oracle DBA)

이 디렉토리는 오라클 DBA를 위한 **Ansible 조건문(Conditions)**을 실습하기 위한 Docker 기반 가상 실습 환경입니다.  
교재(`docs/77_ansible_conditions_for_oracle_dba.md`)의 **Chapter 12 마스터 프로젝트 및 실습 시나리오(Hands-on Scenario)**를 그대로 재현하여, 데이터베이스 상태(`OPEN`, `MOUNTED`)에 따른 조건부 기동, 리스너 2단계 점검, 테이블스페이스 임계값 초과 시 조건부 알림, 그리고 조건부 패치 적용을 실습합니다.

---

## 1. 아키텍처 및 노드 구성

| 컨테이너명 | 호스트명 | 역할 | IP 주소 | 설명 |
|---|---|---|---|---|
| `ansible-control-ch6` | `ansible-control` | 제어 노드 (Control Node) | `192.168.6.10` | 앤서블 명령 및 플레이북 실행 머신 |
| `db01` | `db01` | 관리 노드 1 (Oracle Node 1) | `192.168.6.101` | 정상 OPEN 인스턴스, 고사용량 테이블스페이스(알림 대상) |
| `db02` | `db02` | 관리 노드 2 (Oracle Node 2) | `192.168.6.102` | MOUNTED 인스턴스(기동 대상), 중지된 리스너(시작 대상) |

---

## 2. 프로젝트 디렉터리 구조

```text
chapter_6/
├── docker-compose.yml
├── docker/
│   ├── Dockerfile.control
│   ├── Dockerfile.oracle_node
│   ├── entrypoint-node.sh
│   └── mocks/
│       ├── sqlplus
│       ├── lsnrctl
│       └── oraenv
├── ansible-oracle-project/
│   ├── ansible.cfg
│   ├── inventory.ini
│   ├── vars/
│   │   └── variables.yml
│   ├── tasks/
│   │   ├── check_db_status.yml
│   │   ├── start_db.yml
│   │   ├── check_tablespace.yml
│   │   ├── alert_tablespace.yml
│   │   └── apply_patch.yml
│   ├── playbook.yml                   # 마스터 프로젝트 메인 플레이북
│   └── playbooks/
│       ├── 01_basic_conditions.yml    # 실습 2: 기본 조건문 문법 및 skipping 검증
│       ├── 02_facts_and_vars.yml      # 실습 3: 변수 및 팩트(Facts) 기반 조건문
│       ├── 03_listener_conditional.yml# 실습 4: 2단계 리스너 상태 확인 및 시작
│       ├── 04_loop_with_conditions.yml# 실습 5: 반복문과 조건문 결합 (stat 활용)
│       └── 05_troubleshooting.yml     # 실습 8: 방어적 조건문 및 오류 처리
└── README.md
```

---

## 3. 실습 환경 시작 방법

### 1) 컨테이너 기동
터미널에서 `chapter_6` 디렉터리로 이동한 후 다음 명령어를 실행하여 컨테이너를 빌드하고 백그라운드로 실행합니다.

```bash
docker compose up -d --build
```

### 2) 제어 노드 접속
Ansible 명령어를 실행할 제어 노드 컨테이너에 접속합니다.

```bash
docker exec -it ansible-control-ch6 bash
```

---

## 4. 단계별 실습 가이드

제어 노드에 접속한 상태(`/home/oracle/ansible-oracle-project`)에서 아래 순서대로 실습을 진행합니다.

### 0단계. 노드 통신 확인 (실습 1)
```bash
ansible dbservers -m ping
```

### 1단계. 조건문의 기본 동작 확인 (실습 2)
```bash
ansible-playbook playbooks/01_basic_conditions.yml
```

### 2단계. 변수와 팩트로 조건 만들기 (실습 3)
```bash
ansible-playbook playbooks/02_facts_and_vars.yml
```

### 3단계. 두 단계 패턴으로 리스너 점검 (실습 4)
```bash
# 첫 번째 실행: db02의 중지된 리스너가 감지되어 기동됨
ansible-playbook playbooks/03_listener_conditional.yml

# 두 번째 실행: 이미 기동되었으므로 두 노드 모두 건너뜀(Skipped) 확인
ansible-playbook playbooks/03_listener_conditional.yml
```

### 4단계. 반복문과 조건 결합 (실습 5)
```bash
# 첫 번째 실행: 없는 디렉터리만 생성
ansible-playbook playbooks/04_loop_with_conditions.yml

# 두 번째 실행: 모두 존재하므로 태스크 전체 skipping 확인 (멱등성)
ansible-playbook playbooks/04_loop_with_conditions.yml
```

### 5단계. 마스터 프로젝트 실행 (실습 6 & 7)
```bash
# 1) 문법 검사
ansible-playbook --syntax-check playbook.yml

# 2) 점검 모드 (Dry-run)
ansible-playbook --check playbook.yml

# 3) 실제 실행
ansible-playbook playbook.yml
```

### 6단계. 문제 해결 및 방어적 조건문 패턴 (실습 8)
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
