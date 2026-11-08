# Chapter 7: Ansible 역할(Roles) 기초 및 표준화 실습 (Oracle DBA)

이 디렉터리는 오라클 DBA를 위한 **Ansible 역할(Ansible Roles) 기초: 모듈화·재사용·표준화**를 실습하기 위한 Docker 기반 가상 실습 환경입니다.  
교재(`docs/Day78_Ansible_Roles_KR.md` - Day 78)의 **역할 디렉터리 구조(`tasks`, `handlers`, `vars`, `defaults`, `templates`, `files`, `meta`), `ansible-galaxy init`, 핸들러 알림(`notify`), 환경별 변수 분리(`DEV`/`TEST`/`PROD`), 역할 의존성(`dependencies`) 및 재사용 가능한 마스터 `oracle_dba` 역할 프로젝트**를 온전히 재현합니다.

---

## 1. 아키텍처 및 노드 구성

| 컨테이너명 | 호스트명 | 환경 그룹 | IP 주소 | 설명 |
|---|---|---|---|---|
| `ansible-control-ch7` | `ansible-control` | 제어 노드 (Control Node) | `192.168.7.10` | 앤서블 명령, Role 초기화 및 플레이북 실행 머신 |
| `devdb` | `devdb` | `dev` | `192.168.7.101` | 오라클 개발 DB 노드 (`DB=DEVDB`, `PORT=1521`, `SGA=2G`) |
| `testdb` | `testdb` | `test` | `192.168.7.102` | 오라클 테스트 DB 노드 (`DB=TESTDB`, `PORT=1521`, `SGA=4G`) |
| `proddb` | `proddb` | `prod` | `192.168.7.103` | 오라클 운영 DB 노드 (`DB=PRODDB`, `PORT=1522`, `SGA=8G`) |

---

## 2. 프로젝트 디렉터리 구조

```text
chapter_7/
├── docker-compose.yml
├── docker/
│   ├── Dockerfile.control
│   ├── Dockerfile.oracle_node
│   ├── entrypoint-node.sh
│   └── mocks/
│       ├── lsnrctl
│       ├── sqlplus
│       └── oraenv
├── ansible-oracle-project/
│   ├── ansible.cfg
│   ├── inventory/
│   │   ├── hosts.ini                  # 전체 통합 인벤토리 (dev, test, prod 그룹)
│   │   ├── dev.ini
│   │   ├── test.ini
│   │   ├── prod.ini
│   │   └── group_vars/                # 인벤토리 그룹 변수
│   ├── group_vars/
│   │   ├── all.yml                    # 공통 기본 변수
│   │   ├── dev.yml                    # DEV 환경 변수 (DEVDB, 1521)
│   │   ├── test.yml                   # TEST 환경 변수 (TESTDB, 1521)
│   │   └── prod.yml                   # PROD 환경 변수 (PRODDB, 1522)
│   ├── roles/
│   │   ├── oracle_prereq/             # [의존 역할 1] OS 사전 요구 사항 및 커널 설정
│   │   ├── oracle_user/               # [의존 역할 2] Oracle OS 계정 및 리소스 한도 설정
│   │   ├── oracle_env/                # [의존 역할 3] Oracle 환경 변수 프로파일 템플릿 배포
│   │   ├── oracle_db/                 # [핵심 역할] 디렉터리, 정적 파일, 템플릿, 핸들러, 의존성 실습
│   │   └── oracle_dba/                # [마스터 프로젝트 역할] 다중 환경 재사용 통합 DBA 역할
│   └── playbooks/
│       ├── 01_role_structure_and_tasks.yml # [실습 2] 역할 기본 작업(tasks/files) 실행 및 멱등성
│       ├── 02_handlers_and_templates.yml   # [실습 3] Jinja2 템플릿 배포 및 notify 핸들러 검증
│       ├── 03_variables_precedence.yml     # [실습 4] defaults vs group_vars vs extra-vars 우선순위
│       ├── 04_role_dependencies.yml        # [실습 5] meta/main.yml 역할 의존성 실행 순서 검증
│       ├── 05_master_oracle_dba_role.yml   # [실습 6 & 7] 마스터 프로젝트(oracle_dba) 다중 환경 배포
│       ├── 06_validation_and_audit.yml     # [실습 8] 역할 배포 결과 무결성 단언(assert) 및 감사
│       └── oracle_dba.yml                  # 교재 11.6절 상위 호출 플레이북
└── README.md
```

---

## 3. 실습 환경 시작 방법

### 1) 컨테이너 기동
터미널에서 `chapter_7` 디렉터리로 이동한 후 다음 명령어를 실행하여 컨테이너를 빌드하고 백그라운드로 실행합니다.

```bash
docker compose up -d --build
```

### 2) 제어 노드 접속
Ansible 명령어를 실행할 제어 노드 컨테이너에 접속합니다.

```bash
docker exec -it ansible-control-ch7 bash
```

---

## 4. 단계별 실습 가이드

제어 노드에 접속한 상태(`/home/oracle/ansible-oracle-project`)에서 아래 순서대로 실습을 진행합니다.

### 0단계. 노드 통신 및 `ansible-galaxy init` 확인 (실습 1)
```bash
ansible dbservers -m ping
ansible-galaxy init /tmp/sample_oracle_role
tree /tmp/sample_oracle_role
```

### 1단계. 기본 역할(`oracle_db`) 작업 실행 및 멱등성 확인 (실습 2)
```bash
# 1차 실행: 디렉터리 생성, 정적 파일(init.ora, setup_db.sql) 배포, Listener 기동
ansible-playbook playbooks/01_role_structure_and_tasks.yml

# 2차 실행: 모든 작업 changed=0 (멱등성 확인)
ansible-playbook playbooks/01_role_structure_and_tasks.yml
```

### 2단계. 템플릿 변경과 핸들러(`notify`) 실행 검증 (실습 3)
```bash
# 평상시 실행: 설정 변경이 없으므로 핸들러 미실행
ansible-playbook playbooks/02_handlers_and_templates.yml

# devdb의 포트를 1525로 변경하여 실행: 템플릿 변경 감지 -> 핸들러(Restart Oracle listener) 실행
ansible-playbook playbooks/02_handlers_and_templates.yml -l devdb -e "listener_port=1525"

# 원래 포트(1521)로 복원
ansible-playbook playbooks/02_handlers_and_templates.yml -l devdb
```

### 3단계. 환경별 변수 및 우선순위 검증 (실습 4)
```bash
# group_vars 기반 환경별(DEV/TEST/PROD) 변수 적용 확인
ansible-playbook playbooks/03_variables_precedence.yml

# --extra-vars(-e)로 최우선 재정의 테스트
ansible-playbook playbooks/03_variables_precedence.yml -l devdb -e "sga_target=6G"
```

### 4단계. 역할 의존성(`meta/main.yml`) 체인 검증 (실습 5)
```bash
# oracle_prereq -> oracle_user -> oracle_env -> oracle_db 순서로 자동 실행
ansible-playbook playbooks/04_role_dependencies.yml
```

### 5단계. 마스터 프로젝트(`oracle_dba` 역할) 다중 환경 배포 (실습 6 & 7)
```bash
# 전체 환경(DEV/TEST/PROD) 일괄 배포
ansible-playbook playbooks/05_master_oracle_dba_role.yml

# 2차 재실행으로 멱등성 확인 (changed=0)
ansible-playbook playbooks/05_master_oracle_dba_role.yml

# 환경별 개별 인벤토리 지정 실행 예시
ansible-playbook -i inventory/prod.ini playbooks/oracle_dba.yml
```

### 6단계. 배포 무결성 검증 및 방어적 단언(`assert`) (실습 8)
```bash
ansible-playbook playbooks/06_validation_and_audit.yml
```

---

## 5. 실습 종료 및 환경 정리

실습을 마치고 리소스를 정리하려면 다음 명령어를 사용합니다.

```bash
exit # 제어 노드에서 나가기
docker compose down -v # 컨테이너 및 볼륨 정리
```

