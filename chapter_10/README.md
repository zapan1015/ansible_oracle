# Chapter 10: Ansible Oracle 서버 패키지 설치·구성·검증 자동화

이 디렉토리는 오라클 DBA를 위한 **Oracle 서버 패키지 프로비저닝 및 검증 자동화**를 실습하기 위한 Docker 기반 가상 실습 환경입니다.  
교재(`docs/81_final_editorial_manuscript.md` - Day 81)의 **DNF 패키지 관리, 단일/다중 루프 설치, 버전 관리, DEV/TEST/PROD 환경별 차등 프로비저닝, Role 구조화 및 감사 보고서 수집(Fetch)**을 온전히 재현합니다.

---

## 1. 아키텍처 및 노드 구성

| 컨테이너명 | 호스트명 | 역할 | IP 주소 | 설명 |
|---|---|---|---|---|
| `ansible-control-ch10` | `ansible-control` | 제어 노드 (Control Node) | `192.168.10.10` | 앤서블 명령 및 플레이북 실행 머신 |
| `devdb` | `devdb` | 오라클 관리 노드 (Dev) | `192.168.10.101` | 개발 환경 노드 (`env_name=dev`) |
| `testdb` | `testdb` | 오라클 관리 노드 (Test) | `192.168.10.102` | 테스트 환경 노드 (`env_name=test`) |
| `proddb` | `proddb` | 오라클 관리 노드 (Prod) | `192.168.10.103` | 운영 환경 노드 (`env_name=prod`) |

---

## 2. 프로젝트 디렉터리 구조

```text
chapter_10/
├── docker-compose.yml
├── docker/
│   ├── Dockerfile.control
│   ├── Dockerfile.oracle_node
│   └── entrypoint-node.sh
├── ansible-oracle-project/
│   ├── ansible.cfg
│   ├── inventory/
│   │   ├── hosts.ini                  # 전체 통합 인벤토리 (dev, test, prod 그룹)
│   │   ├── dev.ini
│   │   ├── test.ini
│   │   └── prod.ini
│   ├── group_vars/
│   │   ├── all.yml                    # 공통 필수 패키지 정의
│   │   ├── dev.yml                    # DEV 전용 패키지 목록
│   │   ├── test.yml                   # TEST 전용 패키지 목록
│   │   └── prod.yml                   # PROD 전용 패키지 목록
│   ├── roles/
│   │   └── oracle_packages/           # 패키지 관리 전용 표준 Role
│   │       ├── defaults/main.yml
│   │       ├── tasks/main.yml
│   │       ├── handlers/main.yml
│   │       └── meta/main.yml
│   ├── reports/                       # fetch 모듈로 수집되는 감사 보고서 저장소
│   └── playbooks/
│       ├── 01_single_package.yml      # [실습 1&2] 단일 패키지 설치 및 멱등성 검증
│       ├── 02_loop_packages.yml       # [실습 3] 반복문(loop) 기반 다중 패키지 설치
│       ├── 03_package_versions.yml    # [실습 4] 패키지 버전 및 상태 관리(present vs latest)
│       ├── 04_env_packages.yml        # [실습 5] 환경별(DEV/TEST/PROD) 차등 패키지 프로비저닝
│       ├── 05_role_master_provision.yml # [실습 6] Role 기반 통합 마스터 프로비저닝 & fetch 리포트
│       └── 06_validation_and_audit.yml# [실습 7] rpm -qa 무결성 검증, assert 및 재시도 정책
└── README.md
```

---

## 3. 실습 환경 시작 방법

### 1) 컨테이너 기동
터미널에서 `chapter_10` 디렉터리로 이동한 후 다음 명령어를 실행하여 컨테이너를 빌드하고 백그라운드로 실행합니다.

```bash
docker compose up -d --build
```

### 2) 제어 노드 접속
Ansible 명령어를 실행할 제어 노드 컨테이너에 접속합니다.

```bash
docker exec -it ansible-control-ch10 bash
```

---

## 4. 단계별 실습 가이드

제어 노드에 접속한 상태(`/home/oracle/ansible-oracle-project`)에서 아래 순서대로 실습을 진행합니다.

### 0단계. 노드 통신 확인 (실습 1)
```bash
ansible all -m ping
```

### 1단계. 단일 패키지 설치 및 멱등성 검증 (실습 2)
```bash
# 첫 실행 (changed=1)
ansible-playbook playbooks/01_single_package.yml

# 재실행 (changed=0, 멱등성 확인)
ansible-playbook playbooks/01_single_package.yml
```

### 2단계. 반복문 기반 다중 패키지 설치 (실습 3)
```bash
ansible-playbook playbooks/02_loop_packages.yml
```

### 3단계. 패키지 상태 및 최신화 제어 (실습 4)
```bash
ansible-playbook playbooks/03_package_versions.yml
```

### 4단계. 환경별(DEV vs TEST vs PROD) 차등 패키지 프로비저닝 (실습 5)
```bash
ansible-playbook playbooks/04_env_packages.yml
```

### 5단계. Role 기반 종합 마스터 프로비저닝 & 감사 보고서 수집 (실습 6)
```bash
ansible-playbook playbooks/05_role_master_provision.yml
ls -la ../reports/
```

### 6단계. 패키지 설치 검증 및 방어적 단언(assert) (실습 7)
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
