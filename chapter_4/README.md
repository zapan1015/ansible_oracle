# Chapter 4: Ansible 변수(Variables) 실습 (Oracle DBA)

이 디렉토리는 오라클 DBA를 위한 **Ansible 변수(Variables)**를 실습하기 위한 Docker 기반 가상 실습 환경입니다.  
교재(`docs/75_ansible_variables_for_oracle_dba.md`)의 **Chapter 12 마스터 프로젝트 및 실습 시나리오(Hands-on Scenario)**를 그대로 재현하여, 하나의 플레이북으로 `dev`, `test`, `prod` 세 환경의 오라클 정보를 확인하고 점검하는 자동화를 실습합니다.

---

## 1. 아키텍처 및 노드 구성

| 컨테이너명 | 호스트명 | 역할 | IP 주소 | 설명 |
|---|---|---|---|---|
| `ansible-control-ch4` | `ansible-control` | 제어 노드 (Control Node) | `192.168.4.10` | 앤서블 명령 및 플레이북 실행 머신 |
| `devdb` | `devdb` | 관리 노드 (Dev) | `192.168.4.101` | 오라클 개발 DB (`DEV`) |
| `testdb` | `testdb` | 관리 노드 (Test) | `192.168.4.102` | 오라클 테스트 DB (`TEST`) |
| `proddb` | `proddb` | 관리 노드 (Prod) | `192.168.4.103` | 오라클 운영 DB (`PROD`) |

---

## 2. 프로젝트 디렉터리 구조

```text
chapter_4/
├── docker-compose.yml
├── docker/
│   ├── Dockerfile.control
│   ├── Dockerfile.oracle_node
│   └── entrypoint-node.sh
├── ansible-oracle-project/
│   ├── ansible.cfg
│   ├── inventory/
│   │   └── hosts.ini
│   ├── group_vars/
│   │   ├── dev.yml
│   │   ├── test.yml
│   │   └── prod.yml
│   ├── vars/
│   │   └── common.yml
│   └── playbooks/
│       ├── oracle_dba_tasks.yml       # 12.6절 기본 플레이북
│       ├── validate_vars.yml          # 실습 5 assert 변수 검증 플레이북
│       └── debug_vars.yml             # 실습 7 상세 변수 디버깅 플레이북
└── README.md
```

---

## 3. 실습 환경 시작 방법

### 1) 컨테이너 기동
터미널에서 `chapter_4` 디렉터리로 이동한 후 다음 명령어를 실행하여 컨테이너를 빌드하고 백그라운드로 실행합니다.

```bash
docker compose up -d --build
```

### 2) 제어 노드 접속
Ansible 명령어를 실행할 제어 노드 컨테이너에 접속합니다.

```bash
docker exec -it ansible-control-ch4 bash
```

---

## 4. 단계별 실습 가이드

제어 노드에 접속한 상태(`/home/oracle/ansible-oracle-project`)에서 아래 순서대로 실습을 진행합니다.

### 0단계. 노드 통신 확인
```bash
ansible all -m ping
```

### 실습 1 & 2. 인벤토리 구조 및 호스트 변수 검증
```bash
# 인벤토리 그래프 확인
ansible-inventory -i inventory/hosts.ini --graph

# devdb 호스트의 변수 로드 확인
ansible-inventory -i inventory/hosts.ini --host devdb
```

### 실습 3 & 4. 플레이북 문법 검사 및 기본 실행
```bash
# 플레이북 문법 검증
ansible-playbook -i inventory/hosts.ini --syntax-check playbooks/oracle_dba_tasks.yml

# 개발(dev) 환경 실행 (hosts: all이므로 --limit dev 지정 권장)
ansible-playbook -i inventory/hosts.ini playbooks/oracle_dba_tasks.yml -e env=dev --limit dev
```

### 실습 5. `assert` 모듈을 통한 변수 검증
```bash
# 정상 실행 (db_name, oracle_home 검증 통과)
ansible-playbook -i inventory/hosts.ini playbooks/validate_vars.yml -e env=dev --limit dev

# 의도적 오류 테스트: db_name을 빈 값으로 오버라이드하여 assert 실패 확인
ansible-playbook -i inventory/hosts.ini playbooks/validate_vars.yml -e env=dev -e "db_name=" --limit dev
```

### 실습 6. 환경별 실행 및 변수 우선순위(Extra vars) 확인
```bash
# 1) Test 환경 실행
ansible-playbook -i inventory/hosts.ini playbooks/oracle_dba_tasks.yml -e env=test --limit test

# 2) Prod 환경 실행
ansible-playbook -i inventory/hosts.ini playbooks/oracle_dba_tasks.yml -e env=prod --limit prod

# 3) 추가 변수(-e) 최상위 우선순위 오버라이드 확인
ansible-playbook -i inventory/hosts.ini playbooks/oracle_dba_tasks.yml -e env=dev -e "oracle_home=/u01/app/oracle/extra" --limit dev
```

### 실습 7. 문제 해결 연습 (Error Handling & Troubleshooting)
```bash
# 존재하지 않는 환경(staging) 전달 시 vars_files 누락 에러 재현
ansible-playbook -i inventory/hosts.ini playbooks/oracle_dba_tasks.yml -e env=staging --limit dev

# 상세 디버그(-vvv) 및 전체 변수 확인
ansible-playbook -i inventory/hosts.ini playbooks/debug_vars.yml -e env=dev --limit dev
```

---

## 5. 실습 종료 및 환경 정리

```bash
exit # 제어 노드에서 빠져나오기
docker compose down
```
