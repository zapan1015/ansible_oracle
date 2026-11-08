# 참고 문헌 및 기술 레퍼런스 (References)

> **조판 및 편집 규격 안내 (Editorial & Typesetting Specification)**
> - **본문 / 표(Table) / 캡션(Caption) / 영문 기술 용어**: `Noto Sans KR`
> - **장·절 제목 (Heading 1 ~ Heading 4)**: `Noto Sans KR Bold`
> - **코드 블록 및 명령어 / 경로 / URL**: `DejaVu Sans Mono`

본 문서는 **《오라클 19c 관리와 자동화를 위한 앤서블 실전 가이드》** 집필 및 실습 환경(`chapter_1` ~ `chapter_10`) 구축에 참조된 공식 기술 문서, 아키텍처 표준, 오픈소스 리포지토리 및 장별 실습 소스 매핑 정보를 누적 수록합니다.

---

## Chapter 1. 앤서블 인벤토리 설계: 오라클 19c DBA 환경을 위한 서버 조직화

### 1. 공식 기술 문서 (Official Documentation)

#### 1.1 Red Hat Ansible 공식 문서
1. **Ansible Documentation — How to build your inventory**
   - 설명: 정적 인벤토리(INI 및 YAML 형식)의 문법 규격, 그룹 계층(`children`), 다중 그룹 소속, 기본 그룹(`all`, `ungrouped`), 그리고 `group_vars` 및 `host_vars` 디렉터리 구조와 변수 우선순위(Variable Precedence)를 정의한 공식 가이드입니다.
   - URL: https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html
2. **Ansible Documentation — `ansible-inventory` CLI Reference**
   - 설명: 인벤토리 구문 파싱, JSON 덤프(`--list`), 계층 트리 출력(`--graph`), 특정 호스트의 병합 변수 조회(`--host`) 등 인벤토리 검증 명령줄 도구 명세서입니다.
   - URL: https://docs.ansible.com/ansible/latest/cli/ansible-inventory.html
3. **Ansible Configuration Settings (`ansible.cfg`)**
   - 설명: `forks`, `host_key_checking`, `stdout_callback = yaml`, SSH `ControlPersist` 및 `pipelining` 등 앤서블 제어 노드 성능 및 출력 최적화 설정 레퍼런스입니다.
   - URL: https://docs.ansible.com/ansible/latest/reference_appendices/config.html

#### 1.2 Oracle Database 19c & Oracle Linux 8 공식 문서
1. **Oracle Database 19c Installation Guide for Linux — Optimal Flexible Architecture (OFA)**
   - 설명: 오라클 베이스(`ORACLE_BASE`, `/u01/app/oracle`), 오라클 인벤토리(`ORA_INVENTORY`, `/u01/app/oraInventory`), 오라클 홈(`ORACLE_HOME`, `/u01/app/oracle/product/19.3.0/dbhome_1`)의 표준 디렉터리 명명 규칙과 권한(`0755`, `0770`) 기준서입니다.
   - URL: https://docs.oracle.com/en/database/oracle/oracle-database/19/ladbi/optimal-flexible-architecture.html
2. **Oracle Grid Infrastructure 19c Installation and Upgrade Guide for Linux**
   - 설명: Grid Infrastructure 설치를 위한 OS 역할 분리 계정(`grid`, `oracle`) 및 OS 그룹(`oinstall`, `dba`, `asmadmin`, `asmdba`, `asmoper`, `racdba`), Out-of-place Grid 홈(`/u01/app/19c/grid`), SCAN 및 VIP 네트워크 요구사항을 다룬 공식 매뉴얼입니다.
   - URL: https://docs.oracle.com/en/database/oracle/oracle-database/19/cwlin/index.html
3. **Oracle Linux 8 — Simplified Oracle Database Installation (`oracle-database-preinstall-19c`)**
   - 설명: 오라클 리눅스 8 환경에서 오라클 19c 구동에 필요한 커널 파라미터(`/etc/sysctl.conf`), 리소스 제한(`/etc/security/limits.conf`), 필수 RPM 패키지를 자동 구성하는 프리인스톨 패키지 기술 문서입니다.
   - URL: https://docs.oracle.com/en/ operating-systems/oracle-linux/8/

#### 1.3 컨테이너 및 오케스트레이션 레퍼런스
1. **Oracle Official Docker Images — Oracle Real Application Clusters (RAC) on Container**
   - 설명: 도커 및 포드맨(Podman) 컨테이너 위에서 오라클 19c RAC(`oracle/database-rac:19.3.0`)를 빌드하고 다중 브리지 네트워크(Public/Private)와 공유 ASM 블록 디바이스로 기동하는 오라클 공식 GitHub 리포지토리입니다.
   - URL: https://github.com/oracle/docker-images/tree/main/OracleDatabase/RAC

---

### 2. 프로젝트 내 원고 및 실습 코드 매핑 (Workspace Source Mapping)

Chapter 1 본문 집필에 반영된 프로젝트 내부 원본 문서 및 실습 파일 목록은 아래 표와 같습니다.

| 구분 | 파일 경로 | 역할 및 수록 내용 |
| :--- | :--- | :--- |
| **기초 원고 1** | [`docs/72_ansible_inventory_design_for_oracle_dba.md`](file:///c:/Users/zapan/Documents/ansible_oracle/docs/72_ansible_inventory_design_for_oracle_dba.md) | 인벤토리 개념, INI/YAML 비교, 부모·자식 그룹, `group_vars`/`host_vars`, 검증 및 트러블슈팅 이론 원본 |
| **기초 원고 2** | [`docs/ansible_oracle_dba_manuscript.md`](file:///c:/Users/zapan/Documents/ansible_oracle/docs/ansible_oracle_dba_manuscript.md) | 앤서블 에이전트리스 아키텍처, 제어·관리 노드 구조, `ansible.cfg` 설정 기초 |
| **오케스트레이션** | [`chapter_1/docker-compose.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_1/docker-compose.yml) | `ansible-control`(`192.168.1.10`), `db01`(`.101`), `db02`(`.102`), `grid01`(`.103`) 4노드 컨테이너 정의 |
| **도커 이미지** | [`chapter_1/docker/Dockerfile.control`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_1/docker/Dockerfile.control)<br/>[`chapter_1/docker/Dockerfile.oracle_node`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_1/docker/Dockerfile.oracle_node) | 제어 노드(Python 3.9, Ansible) 및 관리 노드(`oracle-database-preinstall-19c`, `oracle`/`grid` 계정) 빌드 명세 |
| **앤서블 설정** | [`chapter_1/ansible-oracle-dba/ansible.cfg`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_1/ansible-oracle-dba/ansible.cfg) | 기본 인벤토리 경로, YAML 콜백, SSH 파이프라이닝 및 `ControlPersist` 최적화 설정 |
| **정적 인벤토리** | [`chapter_1/ansible-oracle-dba/inventory/hosts`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_1/ansible-oracle-dba/inventory/hosts)<br/>[`chapter_1/ansible-oracle-dba/inventory/hosts.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_1/ansible-oracle-dba/inventory/hosts.yml) | `db_servers`, `grid_servers`, `rac_nodes`, `database_servers` 그룹 및 전역 변수 정의 (INI/YAML) |
| **그룹 변수** | [`group_vars/all.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_1/ansible-oracle-dba/group_vars/all.yml), [`db_servers.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_1/ansible-oracle-dba/group_vars/db_servers.yml), [`grid_servers.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_1/ansible-oracle-dba/group_vars/grid_servers.yml), [`rac_nodes.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_1/ansible-oracle-dba/group_vars/rac_nodes.yml) | 오라클 19c 버전(`19.3.0`), 홈 경로, 리스너, ASM 디스크 그룹, RAC SCAN/VIP/Private IP 정의 |
| **호스트 변수** | [`host_vars/db01.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_1/ansible-oracle-dba/host_vars/db01.yml), [`db02.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_1/ansible-oracle-dba/host_vars/db02.yml), [`grid01.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_1/ansible-oracle-dba/host_vars/grid01.yml) | 노드별 고유 `oracle_sid`(`ORCL1`, `ORCL2`, `+ASM1`), `node_number`, `is_rac_member` 정의 |
| **실습 플레이북** | [`01_ping_check.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_1/ansible-oracle-dba/playbooks/01_ping_check.yml), [`02_setup_oracle_env.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_1/ansible-oracle-dba/playbooks/02_setup_oracle_env.yml), [`03_oracle_19c_precheck.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_1/ansible-oracle-dba/playbooks/03_oracle_19c_precheck.yml), [`04_verify_all.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_1/ansible-oracle-dba/playbooks/04_verify_all.yml) | 4단계 연결 확인, OFA 디렉터리 생성, 19c 사전 점검, 최종 트리 검증 자동화 플레이북 |
| **실행 로그** | [`chapter_1/ansible-oracle-dba/logs/ansible.log`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_1/ansible-oracle-dba/logs/ansible.log) | 실제 컨테이너 환경에서 실행된 플레이북 출력 및 트러블슈팅 검증 로그 |
| **RAC 아키텍처** | [`chapter_1/rac_19c_architecture/README.md`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_1/rac_19c_architecture/README.md)<br/>[`chapter_1/rac_19c_architecture/rac19c.env`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_1/rac_19c_architecture/rac19c.env) | 컨테이너 기반 오라클 19c 2-노드 RAC 네트워크·스토리지 설계 및 클러스터 검증 명령(`crsctl`, `srvctl`, `asmcmd`) |


---

## Chapter 2. 앤서블 애드혹 명령과 다중 환경(DEV/TEST/PROD) 서버 운영 자동화

### 1. 공식 기술 문서 (Official Documentation)

#### 1.1 Red Hat Ansible 애드혹 및 호스트 패턴 공식 문서
1. **Ansible Documentation — Introduction to ad hoc commands**
   - 설명: 플레이북 없이 단일 작업을 즉시 실행하는 `ansible` CLI 명령 구조, 주요 유스케이스(파일 전송, 패키지 관리, 사용자·그룹 생성, 서비스 관리, 상태 점검)를 다룬 공식 가이드입니다.
   - URL: https://docs.ansible.com/ansible/latest/command_guide/intro_adhoc.html
2. **Ansible Documentation — Patterns: targeting hosts and groups**
   - 설명: `all`, 그룹 지정, 합집합(`:`), 교집합(`:&`), 차집합(`:!`), 와일드카드(`*`) 및 정규식을 활용하여 다중 그룹 인벤토리에서 작업 대상 서버를 정밀 필터링하는 호스트 패턴 공식 명세서입니다.
   - URL: https://docs.ansible.com/ansible/latest/inventory_guide/intro_patterns.html
3. **Ansible Playbook Keywords & Special Variables (`environment`, `group_names`)**
   - 설명: 앤서블 예약 키워드인 `environment` 지시어의 동작 원리와, 호스트가 속한 모든 그룹 목록을 담고 있는 매직 변수 `group_names`에 대한 공식 레퍼런스입니다.
   - URL: https://docs.ansible.com/ansible/latest/reference_appendices/special_variables.html

#### 1.2 Ansible Builtin 코어 모듈 레퍼런스 (`ansible.builtin`)
1. **`ansible.builtin.ping`**: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/ping_module.html
2. **`ansible.builtin.command`**: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/command_module.html
3. **`ansible.builtin.shell`**: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/shell_module.html
4. **`ansible.builtin.file`**: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/file_module.html
5. **`ansible.builtin.copy`**: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/copy_module.html
6. **`ansible.builtin.package`**: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/package_module.html
7. **`ansible.builtin.service`**: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/service_module.html
8. **`ansible.builtin.user` & `group`**: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/user_module.html

---

### 2. 프로젝트 내 원고 및 실습 코드 매핑 (Workspace Source Mapping)

Chapter 2 본문 집필에 반영된 프로젝트 내부 원본 문서 및 실습 파일 목록은 아래 표와 같습니다.

| 구분 | 파일 경로 | 역할 및 수록 내용 |
| :--- | :--- | :--- |
| **기초 원고 1** | [`docs/73_ansible_adhoc_commands_for_oracle_dba.md`](file:///c:/Users/zapan/Documents/ansible_oracle/docs/73_ansible_adhoc_commands_for_oracle_dba.md) | 애드혹 명령 문법, 호스트 패턴, 9대 핵심 모듈(`ping`, `command`, `shell`, `file`, `copy`, `package`, `service`, `user`, `group`) 및 오라클 DBA 활용 사례 원본 |
| **기초 원고 2** | [`docs/72_ansible_inventory_design_for_oracle_dba.md`](file:///c:/Users/zapan/Documents/ansible_oracle/docs/72_ansible_inventory_design_for_oracle_dba.md) | 12절 마스터 프로젝트(DEV/TEST/PROD × DB/Grid/RAC/Data Guard 다중 환경 인벤토리 설계) 원본 |
| **오케스트레이션** | [`chapter_2/docker-compose.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_2/docker-compose.yml) | 제어 노드(`ansible-control-ch2`) + 관리 노드 8대(`devdb01`, `testdb01`, `proddb01`, `devgrid01`, `prodgrid01`, `rac1`, `rac2`, `devstd01`) 총 9대 컨테이너 구성 |
| **이중 계층 인벤토리** | [`chapter_2/ansible-oracle-inventory/inventory/inventory.ini`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_2/ansible-oracle-inventory/inventory/inventory.ini)<br/>[`chapter_2/ansible-oracle-inventory/inventory/inventory.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_2/ansible-oracle-inventory/inventory/inventory.yml) | 환경 부모 그룹(`dev`, `test`, `prod`)과 역할 부모 그룹(`db_servers`, `grid_servers`, `rac_nodes`, `dataguard_servers`)의 이중 계층 매트릭스 인벤토리 |
| **환경·역할 그룹 변수** | [`group_vars/dev.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_2/ansible-oracle-inventory/group_vars/dev.yml), [`test.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_2/ansible-oracle-inventory/group_vars/test.yml), [`prod.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_2/ansible-oracle-inventory/group_vars/prod.yml), [`db_servers.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_2/ansible-oracle-inventory/group_vars/db_servers.yml), [`grid_servers.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_2/ansible-oracle-inventory/group_vars/grid_servers.yml), [`rac_nodes.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_2/ansible-oracle-inventory/group_vars/rac_nodes.yml), [`dataguard_servers.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_2/ansible-oracle-inventory/group_vars/dataguard_servers.yml) | 환경별 백업 보관 주기(`3일`/`7일`/`30일`), RMAN 병렬도 및 역할별 오라클 홈/ASM/RAC/Data Guard 파라미터 정의 |
| **호스트 오버라이드 변수** | [`host_vars/proddb01.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_2/ansible-oracle-inventory/host_vars/proddb01.yml), [`devdb01.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_2/ansible-oracle-inventory/host_vars/devdb01.yml), [`testdb01.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_2/ansible-oracle-inventory/host_vars/testdb01.yml), [`devgrid01.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_2/ansible-oracle-inventory/host_vars/devgrid01.yml), [`prodgrid01.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_2/ansible-oracle-inventory/host_vars/prodgrid01.yml), [`rac1.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_2/ansible-oracle-inventory/host_vars/rac1.yml), [`rac2.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_2/ansible-oracle-inventory/host_vars/rac2.yml), [`devstd01.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_2/ansible-oracle-inventory/host_vars/devstd01.yml) | 노드별 메모리 타깃(`1G`/`2G`/`4G`), `proddb01` 보관 주기 오버라이드(`60일`), ASM 디스크 그룹(`DATA_DEV`/`DATA_PROD`), RAC VIP 정의 |
| **실습 플레이북 & 스크립트** | [`01_inventory_overview.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_2/ansible-oracle-inventory/playbooks/01_inventory_overview.yml), [`02_env_ping_check.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_2/ansible-oracle-inventory/playbooks/02_env_ping_check.yml), [`03_oracle_vars_check.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_2/ansible-oracle-inventory/playbooks/03_oracle_vars_check.yml), [`04_master_inventory_verification.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_2/ansible-oracle-inventory/playbooks/04_master_inventory_verification.yml), [`scripts/test_inventory.sh`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_2/ansible-oracle-inventory/scripts/test_inventory.sh) | 9노드 그룹 소속 확인, 환경별 핑 및 보관 주기 오버라이드 확인, 역할별 변수 검증, 종합 감사 리포트 생성 |
| **실행 로그 & 보조 랩** | [`chapter_2/ansible-oracle-inventory/logs/ansible.log`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_2/ansible-oracle-inventory/logs/ansible.log)<br/>[`chapter_3/README.md`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_3/README.md) | 실제 컨테이너 실행 로그 검증 및 애드혹 명령 실습 시나리오 참조 |


---

## Chapter 3. 앤서블 플레이북: 구조화된 자동화로 오라클 19c 운영 다루기

### 1. 공식 기술 문서 (Official Documentation)

#### 1.1 Red Hat Ansible 플레이북 및 실행 제어 공식 문서
1. **Ansible Documentation — Using Ansible playbooks**
   - 설명: YAML 기반 플레이북의 기본 구조(Plays, Tasks, Modules), FQCN(Fully Qualified Collection Name) 사용법, `ansible-playbook` 실행 옵션 및 문법 검증(`--syntax-check`) 공식 가이드입니다.
   - URL: https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_intro.html
2. **Ansible Documentation — Handlers: running operations on change**
   - 설명: `notify` 키워드와 `handlers:` 섹션을 통해 설정 파일 변경(`changed: true`) 발생 시에만 플레이 마지막에 서비스를 한 번 재시작·리로드하는 이벤트 기반 실행 명세서입니다.
   - URL: https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_handlers.html
3. **Ansible Documentation — Controlling how tasks run: `register`, `changed_when`, `failed_when`**
   - 설명: 태스크 실행 결과를 변수에 캡처(`register`)하고, 반환 코드(`rc`)나 표준 출력(`stdout`) 문자열을 검사하여 성공·실패(`failed_when`) 및 변경 여부(`changed_when`)를 정밀하게 제어하는 공식 매뉴얼입니다.
   - URL: https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_error_handling.html
4. **Ansible Documentation — Validating tasks: check mode and diff mode (`--check --diff`)**
   - 설명: 실제 운영 서버를 변경하지 않고 변경 예상 내역을 시뮬레이션하는 드라이 런(Dry Run) 모드와 파일 변경점 비교(`--diff`) 기능의 동작 원리 및 제약 사항을 다룬 문서입니다.
   - URL: https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_checkmode.html

#### 1.2 추가 활용 코어 모듈 레퍼런스 (`ansible.builtin`)
1. **`ansible.builtin.stat`**: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/stat_module.html
2. **`ansible.builtin.debug`**: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/debug_module.html
3. **`ansible.builtin.lineinfile`**: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/lineinfile_module.html

---

### 2. 프로젝트 내 원고 및 실습 코드 매핑 (Workspace Source Mapping)

Chapter 3 본문 집필에 반영된 프로젝트 내부 원본 문서 및 실습 파일 목록은 아래 표와 같습니다.

| 구분 | 파일 경로 | 역할 및 수록 내용 |
| :--- | :--- | :--- |
| **기초 원고** | [`docs/74_ansible_playbooks_for_oracle_dba.md`](file:///c:/Users/zapan/Documents/ansible_oracle/docs/74_ansible_playbooks_for_oracle_dba.md) | 플레이북 구조, YAML 문법, 모듈 활용, 변수(`vars`, `vars_files`, `-e`), `register`, `when`, `loop`, `handlers`, 실행/검증(`--syntax-check`, `--check --diff`) 및 12절 마스터 프로젝트 원본 |
| **오케스트레이션** | [`chapter_3/docker-compose.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_3/docker-compose.yml) | 제어 노드(`ansible-control-ch3` : `192.168.3.10`) 및 오라클 19c 관리 노드 3대(`devdb` : `.101`, `testdb` : `.102`, `proddb` : `.103`) 컨테이너 구성 |
| **앤서블 설정 & 인벤토리** | [`chapter_3/ansible.cfg`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_3/ansible.cfg)<br/>[`chapter_3/inventory.ini`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_3/inventory.ini) | `dev`, `test`, `prod` 환경 그룹 및 상위 `db_servers` 부모 그룹 정의, `ANSIBLE_CFG_IN_WORLD_WRITABLE_DIR=1` 연동 설정 |
| **컨테이너 빌드 & 엔트리포인트** | [`chapter_3/docker/Dockerfile.control`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_3/docker/Dockerfile.control)<br/>[`chapter_3/docker/Dockerfile.oracle_node`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_3/docker/Dockerfile.oracle_node)<br/>[`chapter_3/docker/entrypoint-node.sh`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_3/docker/entrypoint-node.sh) | Oracle Linux 8 + `oracle-database-preinstall-19c` 기반 노드 구성, SSH 공개키 자동 등록 및 `/u01` 디렉터리 소유권(`oracle:oinstall`) 자동 설정 |
| **실습 가이드** | [`chapter_3/README.md`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_3/README.md) | `chapter_3` 컨테이너 기동, 제어 노드 접속 및 기본 테스트 명령 안내 |


---

## Chapter 4. 오라클 DBA를 위한 앤서블 변수(Variables) 아키텍처와 동적 환경 제어

### 1. 공식 문서 및 기술 레퍼런스 (Official Documentation)

| 분류 | 문서 제목 | 참조 URL / 출처 | 활용 목적 |
| :--- | :--- | :--- | :--- |
| **Ansible 공식 문서** | *Using Variables* | https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html | 변수 명명 규칙, 리스트·딕셔너리 데이터 구조, `vars_files`, `group_vars`, `host_vars` 및 `--extra-vars` 문법 표준 참조 |
| **Ansible 공식 문서** | *Understanding Variable Precedence* | https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#understanding-variable-precedence | 롤 기본값(`defaults`)부터 인벤토리 변수, 플레이북 변수, 명령줄 추가 변수(`-e`)에 이르는 22단계 변수 우선순위 규칙 검증 |
| **Ansible Builtin 모듈** | *ansible.builtin.assert module – Asserts given expressions are true* | https://docs.ansible.com/ansible/latest/collections/ansible/builtin/assert_module.html | 플레이북 실행 초기 필수 변수(`db_name`, `oracle_home`)의 정의 여부(`is defined`) 및 길이 검증(Fail-Fast) 구현 |
| **Ansible Builtin 모듈** | *ansible.builtin.debug module – Print statements during execution* | https://docs.ansible.com/ansible/latest/collections/ansible/builtin/debug_module.html | 환경별 동적 로드 변수 및 공통 변수의 병합 결과 디버깅 출력 |
| **Jinja2 공식 문서** | *Jinja2 Template Designer Documentation* | https://jinja.palletsprojects.com/en/3.1.x/templates/ | `{{ variable }}` 표현식, 파이프 필터(`| length`, `| default`) 및 조건식 평가 규칙 참조 |

### 2. 프로젝트 실습 파일 및 소스 매핑 (`chapter_4/`)

| 구분 | 워크스페이스 파일 경로 | 설명 및 역할 |
| :--- | :--- | :--- |
| **원본 초안 문서** | [`docs/75_ansible_variables_for_oracle_dba.md`](file:///c:/Users/zapan/Documents/ansible_oracle/docs/75_ansible_variables_for_oracle_dba.md) | Chapter 4 원본 강의 교안 및 기술 검토 노트 |
| **컨테이너 오케스트레이션** | [`chapter_4/docker-compose.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_4/docker-compose.yml) | 제어 노드(`ansible-control-ch4`, `192.168.4.10`) 및 환경별 오라클 노드 3대(`devdb`, `testdb`, `proddb`) 네트워크(`192.168.4.0/24`) 정의 |
| **앤서블 환경 설정** | [`chapter_4/ansible-oracle-project/ansible.cfg`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_4/ansible-oracle-project/ansible.cfg) | 기본 인벤토리(`inventory/hosts.ini`), 원격 계정(`oracle`), 파이썬 인터프리터(`auto_silent`) 설정 |
| **INI 인벤토리** | [`chapter_4/ansible-oracle-project/inventory/hosts.ini`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_4/ansible-oracle-project/inventory/hosts.ini) | `[dev]`, `[test]`, `[prod]` 환경 그룹 및 호스트 인라인 변수(`oracle_home`, `listener_port`) 정의 |
| **전사 공통 변수** | [`chapter_4/ansible-oracle-project/vars/common.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_4/ansible-oracle-project/vars/common.yml) | 모든 환경에서 공유하는 DBA 계정(`dba_user`, `dba_group`), 기본 백업/로그 경로, 점검 임계치 정의 |
| **개발 환경 변수** | [`chapter_4/ansible-oracle-project/group_vars/dev.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_4/ansible-oracle-project/group_vars/dev.yml) | 개발 환경(`DEV`, `/u01/app/oracle/dev`, `/backup/dev`, `is_rac: false`) 전용 변수 정의 |
| **테스트 환경 변수** | [`chapter_4/ansible-oracle-project/group_vars/test.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_4/ansible-oracle-project/group_vars/test.yml) | 테스트 환경(`TEST`, `/u01/app/oracle/test`, `/backup/test`, `is_rac: false`) 전용 변수 정의 |
| **운영 환경 변수** | [`chapter_4/ansible-oracle-project/group_vars/prod.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_4/ansible-oracle-project/group_vars/prod.yml) | 운영 환경(`PROD`, `/u01/app/oracle/prod`, `asm_diskgroup: DATA`, `is_rac: true`, `data_guard: true`) 전용 변수 정의 |
| **환경 인식형 플레이북** | [`chapter_4/ansible-oracle-project/playbooks/oracle_dba_tasks.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_4/ansible-oracle-project/playbooks/oracle_dba_tasks.yml) | `vars/common.yml` 및 `group_vars/{{ env }}.yml` 동적 로드를 통한 다중 환경 실행 실습 플레이북 |
| **변수 검증 플레이북** | [`chapter_4/ansible-oracle-project/playbooks/validate_vars.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_4/ansible-oracle-project/playbooks/validate_vars.yml) | `assert` 모듈을 활용해 `db_name`과 `oracle_home`의 정의 여부 및 길이를 사전 검증하는 플레이북 |
| **변수 디버깅 플레이북** | [`chapter_4/ansible-oracle-project/playbooks/debug_vars.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_4/ansible-oracle-project/playbooks/debug_vars.yml) | 공통 변수와 환경별 변수의 통합 결과를 일괄 출력하여 점검하는 디버깅 플레이북 |
| **실습 가이드** | [`chapter_4/README.md`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_4/README.md) | `chapter_4` 컨테이너 환경 기동 및 7단계 변수 실습 시나리오 가이드 |


---

## Chapter 5. 오라클 DBA를 위한 앤서블 반복문(Loops): 다중 인스턴스·다중 객체 일괄 자동화

### 1. 공식 문서 및 기술 레퍼런스 (Official Documentation)

| 분류 | 문서 제목 | 참조 URL / 출처 | 활용 목적 |
| :--- | :--- | :--- | :--- |
| **Ansible 공식 문서** | *Loops — Ansible Playbook Guide* | https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_loops.html | `loop` 표준 문법, 리스트·딕셔너리(`dict2items`) 순회, `register`와 `.results` 배열 구조, `loop_control`(`label`, `index_var`, `pause`) 표준 참조 |
| **Ansible 공식 문서** | *Migrating from with_X to loop* | https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_loops.html#migrating-from-with-x-to-loop | 레거시 `with_items`, `with_nested`, `with_subelements`를 현대적 `loop` 및 `product`, `subelements` 필터로 전환하는 표준 가이드 |
| **Ansible 공식 문서** | *Using filters to manipulate data* | https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_filters.html | `dict2items`, `product`, `subelements`, `default` 등 진자2 데이터 변환 및 방어적 필터 활용 |
| **Oracle 19c 공식 문서** | *Oracle Database Reference 19c — DBA_TABLESPACE_USAGE_METRICS* | https://docs.oracle.com/en/database/oracle/oracle-database/19/refrn/DBA_TABLESPACE_USAGE_METRICS.html | 테이블스페이스 사용량 모니터링 SQL 작성 시 블록(`Blocks`) 단위 컬럼 특성과 바이트 환산 기준 확인 |

### 2. 프로젝트 실습 파일 및 소스 매핑 (`chapter_5/`)

| 구분 | 워크스페이스 파일 경로 | 설명 및 역할 |
| :--- | :--- | :--- |
| **원본 초안 문서** | [`docs/76_ansible_loops_for_oracle_dba.md`](file:///c:/Users/zapan/Documents/ansible_oracle/docs/76_ansible_loops_for_oracle_dba.md) | Chapter 5 원본 강의 교안 및 실습 시나리오 노트 |
| **컨테이너 오케스트레이션** | [`chapter_5/docker-compose.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_5/docker-compose.yml) | 제어 노드(`ansible-control-ch5`, `192.168.5.10`) 및 오라클 서버 3대(`db1`, `db2`, `db3`) 네트워크(`192.168.5.0/24`) 정의 |
| **앤서블 환경 설정** | [`chapter_5/ansible-oracle-project/ansible.cfg`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_5/ansible-oracle-project/ansible.cfg) | 기본 인벤토리(`inventory/hosts.ini`), 원격 계정(`oracle`), 파이썬 인터프리터(`auto_silent`) 설정 |
| **INI 인벤토리** | [`chapter_5/ansible-oracle-project/inventory/hosts.ini`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_5/ansible-oracle-project/inventory/hosts.ini) | `[oracle_servers]` 그룹(`db1`, `db2`, `db3`) 및 호스트별 `oracle_sid`(`ORCL`, `TEST`, `DEV`), `oracle_home` 정의 |
| **실습 2 플레이북** | [`chapter_5/ansible-oracle-project/playbooks/01_basic_loops.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_5/ansible-oracle-project/playbooks/01_basic_loops.yml) | 문자열(노드명), 숫자(리스너 포트), 리스트 변수(`oracle_environments`) 기본 반복 실습 |
| **실습 3 플레이북** | [`chapter_5/ansible-oracle-project/playbooks/02_list_and_dict.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_5/ansible-oracle-project/playbooks/02_list_and_dict.yml) | 단순 리스트, 1차원 딕셔너리(`dict2items`), 중첩 딕셔너리(`item.value.sid`, `sga_mb`) 반복 실습 |
| **실습 4 플레이북** | [`chapter_5/ansible-oracle-project/playbooks/03_loop_when.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_5/ansible-oracle-project/playbooks/03_loop_when.yml) | 반복문과 `when` 조건(`in`, `item.status == 'active'`) 결합 및 항목별 `skipping` 동작 검증 |
| **실습 5 플레이북** | [`chapter_5/ansible-oracle-project/playbooks/04_master_create_dirs.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_5/ansible-oracle-project/playbooks/04_master_create_dirs.yml) | 마스터 프로젝트 Step 1: 다중 오라클 홈(`19c`, `12.1.0`) 하위 `admin/scripts` 디렉터리 일괄 생성 |
| **실습 6 플레이북** | [`chapter_5/ansible-oracle-project/playbooks/05_check_listeners.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_5/ansible-oracle-project/playbooks/05_check_listeners.yml) | 마스터 프로젝트 Step 2: 다중 리스너(`LISTENER`, `LISTENER_SCAN1`) 상태 점검, `register.results` 파싱 및 `loop_control.label` 제어 |
| **실습 7 플레이북** | [`chapter_5/ansible-oracle-project/playbooks/06_collect_reports.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_5/ansible-oracle-project/playbooks/06_collect_reports.yml) | 마스터 프로젝트 Step 3: 다중 DB(`ORCL`, `TEST`, `DEV`) 헬스 리포트 생성 및 `stat` 모듈 기반 파일 크기 검증 |
| **실습 8 플레이북** | [`chapter_5/ansible-oracle-project/playbooks/07_troubleshooting.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_5/ansible-oracle-project/playbooks/07_troubleshooting.yml) | 누락된 딕셔너리 키에 대한 `default('UNKNOWN')` 필터 및 `when: item.role is defined` 방어적 패턴 실습 |
| **오라클 시뮬레이터** | [`chapter_5/docker/mocks/sqlplus`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_5/docker/mocks/sqlplus), [`lsnrctl`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_5/docker/mocks/lsnrctl) | 대상 컨테이너에서 `sqlplus` 헬스 리포트 및 `lsnrctl status` 응답을 재현하는 시뮬레이션 스크립트 |
| **실습 가이드** | [`chapter_5/README.md`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_5/README.md) | `chapter_5` 컨테이너 환경 기동 및 8단계 반복문 실습 가이드 |


---

## Chapter 6. 오라클 DBA를 위한 앤서블 조건문(Conditions): 상태 인식형 지능화 운영

### 1. 공식 문서 및 기술 레퍼런스 (Official Documentation)

| 분류 | 문서 제목 | 참조 URL / 출처 | 활용 목적 |
| :--- | :--- | :--- | :--- |
| **Ansible 공식 문서** | *Conditionals — Ansible Playbook Guide* | https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html | `when` 조건식 기본 문법, 시스템 팩트(`ansible_facts`) 기반 조건, 논리 연산자(`and`, `or`, `not`), `register` 및 `loop` 결합 표준 참조 |
| **Ansible 공식 문서** | *Discovering variables: facts and magic variables* | https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_vars_facts.html | `ansible_os_family`와 `ansible_distribution`의 차이점, `ansible_memtotal_mb`, `inventory_hostname` 등 매직 변수 및 팩트 사양 검증 |
| **Ansible 공식 문서** | *Re-using files and roles (import_tasks vs include_tasks)* | https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse.html | 마스터 프로젝트의 모듈식 태스크 분리(`ansible.builtin.import_tasks`) 구조 설계 참조 |
| **Ansible Builtin 모듈** | *ansible.builtin.unarchive module – Unpacks an archive* | https://docs.ansible.com/ansible/latest/collections/ansible/builtin/unarchive_module.html | 원격 오라클 서버 내 패치 아카이브(`remote_src: yes`) 조건부 압축 해제 구현 |

### 2. 프로젝트 실습 파일 및 소스 매핑 (`chapter_6/`)

| 구분 | 워크스페이스 파일 경로 | 설명 및 역할 |
| :--- | :--- | :--- |
| **원본 초안 문서** | [`docs/77_ansible_conditions_for_oracle_dba.md`](file:///c:/Users/zapan/Documents/ansible_oracle/docs/77_ansible_conditions_for_oracle_dba.md) | Chapter 6 원본 강의 교안 및 기술 검토 노트 |
| **컨테이너 오케스트레이션** | [`chapter_6/docker-compose.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_6/docker-compose.yml) | 제어 노드(`ansible-control-ch6`, `192.168.6.10`) 및 오라클 서버 2대(`db01`, `db02`) 네트워크(`192.168.6.0/24`) 정의 |
| **앤서블 환경 설정** | [`chapter_6/ansible-oracle-project/ansible.cfg`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_6/ansible-oracle-project/ansible.cfg) | 기본 인벤토리(`inventory.ini`), 원격 계정(`oracle`), 파이썬 인터프리터(`auto_silent`) 설정 |
| **INI 인벤토리** | [`chapter_6/ansible-oracle-project/inventory.ini`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_6/ansible-oracle-project/inventory.ini) | `[dbservers]` 그룹(`db01`, `db02`) 및 그룹 공통 SSH 연결 변수 정의 |
| **마스터 프로젝트 메인** | [`chapter_6/ansible-oracle-project/playbook.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_6/ansible-oracle-project/playbook.yml) | 5개 하위 태스크 파일을 `import_tasks`로 조립한 조건 기반 오라클 운영 마스터 플레이북 |
| **마스터 프로젝트 변수** | [`chapter_6/ansible-oracle-project/vars/variables.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_6/ansible-oracle-project/vars/variables.yml) | `oracle_home`, `db_name`(`ORCL`), `tablespace_threshold`(`85`), `patch_file`, `apply_patch` 정의 |
| **하위 태스크 1~5** | [`tasks/check_db_status.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_6/ansible-oracle-project/tasks/check_db_status.yml), [`start_db.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_6/ansible-oracle-project/tasks/start_db.yml), [`check_tablespace.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_6/ansible-oracle-project/tasks/check_tablespace.yml), [`alert_tablespace.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_6/ansible-oracle-project/tasks/alert_tablespace.yml), [`apply_patch.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_6/ansible-oracle-project/tasks/apply_patch.yml) | DB 오픈 모드 확인, 조건부 기동(`\| trim != 'READ WRITE'`), 테이블스페이스 조회, 85% 초과 조건부 알림(`regex_search`), 조건부 패치 압축 해제 |
| **실습 2~8 플레이북** | [`01_basic_conditions.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_6/ansible-oracle-project/playbooks/01_basic_conditions.yml), [`02_facts_and_vars.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_6/ansible-oracle-project/playbooks/02_facts_and_vars.yml), [`03_listener_conditional.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_6/ansible-oracle-project/playbooks/03_listener_conditional.yml), [`04_loop_with_conditions.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_6/ansible-oracle-project/playbooks/04_loop_with_conditions.yml), [`05_troubleshooting.yml`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_6/ansible-oracle-project/playbooks/05_troubleshooting.yml) | 기본 `when` 문법, 팩트 기반 조건, 2단계 리스너 조건부 기동, `stat` 반복 조건, 방어적 조건문(`is defined`, `default`) 실습 |
| **실습 가이드** | [`chapter_6/README.md`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_6/README.md) | `chapter_6` 컨테이너 환경 기동 및 단계별 조건문 실습 가이드 |
