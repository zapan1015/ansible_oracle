# Chapter 2: Ansible 인벤토리 설계 - 오라클 DBA 환경을 위한 서버 조직화

이 디렉토리는 `docs/72_ansible_inventory_design_for_oracle_dba.md` (Chapter 2)의 **오라클 DBA 인벤토리 설계, 부모-자식 그룹 계층화, DEV/TEST/PROD 환경 분리 및 변수 상속**을 직접 실습할 수 있도록 제작된 Docker 기반 랩 환경입니다.

---

## 1. 노드 및 IP 주소 구성표

| 컨테이너명 | 환경 (Group) | 역할 (Group) | IP 주소 | 설명 |
|---|---|---|---|---|
| `ansible-control` | - | **Control Node** | `192.168.1.10` | 앤서블 제어 노드 |
| `devdb01` | `dev` | `db_servers` | `192.168.1.101` | DEV Oracle DB (`DEVDB1`) |
| `testdb01` | `test` | `db_servers` | `192.168.1.102` | TEST Oracle DB (`TSTDB1`) |
| `proddb01` | `prod` | `db_servers` | `192.168.1.103` | PROD Oracle DB (`PRDDB1`) |
| `devgrid01` | `dev` | `grid_servers` | `192.168.1.111` | DEV Grid Infrastructure (`+ASMDEV`) |
| `prodgrid01` | `prod` | `grid_servers` | `192.168.1.113` | PROD Grid Infrastructure (`+ASMPRD`) |
| `rac1` | `prod` | `rac_nodes` | `192.168.1.121` | PROD RAC 19c Node 1 (`RAC1`) |
| `rac2` | `prod` | `rac_nodes` | `192.168.1.122` | PROD RAC 19c Node 2 (`RAC2`) |
| `devstd01` | `dev` | `dataguard_servers` | `192.168.1.131` | DEV Data Guard Standby DB (`DEVSTD`) |

---

## 2. 실습 환경 시작 및 구동 방법

### Step 1. 컨테이너 9대 기동 및 빌드
`chapter_2` 디렉터리에서 실행합니다:

```bash
cd chapter_2
docker compose up -d --build
```

### Step 2. 제어 노드 접속
```bash
docker exec -it ansible-control-ch2 bash
```

---

## 3. 원고(Chapter 2) 실습 단계별 진행 (Hands-on)

### 실습 1. 인벤토리 구조 검증 (`--graph` 및 `--list`)
```bash
# 1. 트리 구조(부모/자식 그룹) 검증
ansible-inventory -i inventory/inventory.ini --graph

# 2. 파싱된 JSON 데이터 전체 확인
ansible-inventory -i inventory/inventory.ini --list
```

### 실습 2. 변수 로드 및 상속 확인 (`--host`)
```bash
# 1. proddb01 전용 호스트 변수 및 상속된 그룹 변수 확인
ansible-inventory -i inventory/inventory.ini --host proddb01

# 2. rac1 호스트 변수 확인
ansible-inventory -i inventory/inventory.ini --host rac1
```

### 실습 3. 환경별 그룹 대상 명령 실행 (Ad-hoc)
```bash
# DEV 환경 전체 핑
ansible dev -i inventory/inventory.ini -m ping

# PROD 환경 전체 핑
ansible prod -i inventory/inventory.ini -m ping

# RAC 노드 전용 핑
ansible rac_nodes -i inventory/inventory.ini -m ping
```

### Step 4. 실습 플레이북 전체 실행
```bash
# 1. 인벤토리 그룹 개요 및 인식 노드 출력
ansible-playbook playbooks/01_inventory_overview.yml

# 2. DEV / TEST / PROD 환경별 핑 및 보관주기 검증
ansible-playbook playbooks/02_env_ping_check.yml

# 3. DB / Grid / RAC / Data Guard 역할별 변수 검증
ansible-playbook playbooks/03_oracle_vars_check.yml

# 4. 마스터 인벤토리 종합 점검 플레이북
ansible-playbook playbooks/04_master_inventory_verification.yml
```

### Step 5. YAML 인벤토리 검증 및 비교
```bash
# YAML 기반 인벤토리 검증
ansible-inventory -i inventory/inventory.yml --graph
ansible all -i inventory/inventory.yml -m ping
```

---

## 4. 환경 정리
```bash
docker compose down -v
```
