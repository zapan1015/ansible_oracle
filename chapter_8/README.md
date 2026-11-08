# Chapter 8: Ansible Jinja2 템플릿 실습 (Oracle DBA)

이 디렉토리는 오라클 DBA를 위한 **Ansible Jinja2 템플릿 실무**를 실습하기 위한 Docker 기반 가상 실습 환경입니다.  
교재(`docs/79_jinja2_.md`)의 **Jinja2 템플릿 문법, 조건문, 반복문, 필터 및 환경별(Dev/Test/Prod) Oracle Net 설정 자동 배포**를 온전히 재현합니다.

---

## 1. 아키텍처 및 노드 구성

| 컨테이너명 | 호스트명 | 환경 그룹 | IP 주소 | 설명 |
|---|---|---|---|---|
| `ansible-control-ch8` | `ansible-control` | 제어 노드 | `192.168.8.10` | 앤서블 명령 및 플레이북 실행 머신 |
| `devdb` | `devdb` | `dev` | `192.168.8.101` | 오라클 개발 DB (포트: 1523, ADR: 비활성, 로그: DEBUG) |
| `testdb` | `testdb` | `test` | `192.168.8.102` | 오라클 테스트 DB (포트: 1522, ADR: 활성, 로그: INFO) |
| `proddb` | `proddb` | `prod` | `192.168.8.103` | 오라클 운영 DB (포트: 1521, ADR: 활성, 로그: ERROR) |

---

## 2. 프로젝트 디렉터리 구조

```text
chapter_8/
├── docker-compose.yml
├── docker/
│   ├── Dockerfile.control
│   ├── Dockerfile.oracle_node
│   └── entrypoint-node.sh
├── ansible-oracle-project/
│   ├── ansible.cfg
│   ├── inventory/
│   │   └── hosts.ini                  # dev, test, prod 그룹 정의
│   ├── group_vars/
│   │   ├── all.yml                    # 공통 DB 목록 및 경로 설정
│   │   ├── dev.yml                    # 개발 환경 변수
│   │   ├── test.yml                   # 테스트 환경 변수
│   │   └── prod.yml                   # 운영 환경 변수
│   ├── templates/
│   │   ├── listener.ora.j2            # 리스너 설정 템플릿 (조건문 포함)
│   │   ├── tnsnames.ora.j2            # TNSNAMES 템플릿 (반복문 및 loop 변수)
│   │   ├── sqlnet.ora.j2              # SQLNET 템플릿 (환경별 타임아웃)
│   │   └── pfile.ora.j2               # 초기화 파라미터 파일 템플릿 (필터 적용)
│   └── playbooks/
│       ├── 01_basic_template.yml      # [실습 2] 기본 템플릿 렌더링 및 변수 치환
│       ├── 02_conditional_template.yml# [실습 3] if/elif/else 환경별 분기 검증
│       ├── 03_loop_tnsnames.yml       # [실습 4] for 반복문과 loop 변수 활용
│       ├── 04_filters_template.yml    # [실습 5] upper/lower/default 필터 적용
│       ├── 05_master_oracle_net.yml   # [실습 6 & 7] 마스터 프로젝트 일괄 배포 & 멱등성
│       └── 06_troubleshooting.yml     # [실습 8] 템플릿 트러블슈팅 및 assert 방어 검증
└── README.md
```

---

## 3. 실습 환경 시작 방법

### 1) 컨테이너 기동
터미널에서 `chapter_8` 디렉터리로 이동한 후 다음 명령어를 실행하여 컨테이너를 빌드하고 백그라운드로 실행합니다.

```bash
docker compose up -d --build
```

### 2) 제어 노드 접속
Ansible 명령어를 실행할 제어 노드 컨테이너에 접속합니다.

```bash
docker exec -it ansible-control-ch8 bash
```

---

## 4. 단계별 실습 가이드

제어 노드에 접속한 상태(`/home/oracle/ansible-oracle-project`)에서 아래 순서대로 실습을 진행합니다.

### 0단계. 노드 통신 확인 (실습 1)
```bash
ansible dbservers -m ping
```

### 1단계. 기본 템플릿 렌더링 (실습 2)
```bash
ansible-playbook playbooks/01_basic_template.yml
```

### 2단계. 환경별 조건 분기 렌더링 (실습 3)
```bash
ansible-playbook playbooks/02_conditional_template.yml
```

### 3단계. 반복문 기반 tnsnames.ora 생성 (실습 4)
```bash
ansible-playbook playbooks/03_loop_tnsnames.yml
```

### 4단계. 필터 활용 초기화 파라미터 파일 생성 (실습 5)
```bash
ansible-playbook playbooks/04_filters_template.yml
```

### 5단계. 마스터 프로젝트 - 전체 Oracle Net 설정 일괄 배포 (실습 6 & 7)
```bash
# 점검 모드 (Dry-run) 및 Diff 검토
ansible-playbook --check --diff playbooks/05_master_oracle_net.yml

# 실제 실행
ansible-playbook playbooks/05_master_oracle_net.yml

# 멱등성 검증 (2차 실행 시 changed=0 확인)
ansible-playbook playbooks/05_master_oracle_net.yml
```

### 6단계. 문제 해결 및 방어적 템플릿 검증 (실습 8)
```bash
ansible-playbook playbooks/06_troubleshooting.yml
```

---

## 5. 실습 종료 및 환경 정리

실습을 마치고 리소스를 정리하려면 다음 명령어를 사용합니다.

```bash
exit # 제어 노드에서 나가기
docker compose down -v # 컨테이너 및 볼륨 정리
```
