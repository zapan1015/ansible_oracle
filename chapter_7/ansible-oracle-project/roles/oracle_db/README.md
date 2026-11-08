# Role: `oracle_db`

Oracle Database 디렉터리 구성, 정적 파일(`init.ora`, `setup_db.sql`) 배포, 동적 템플릿(`listener.ora.j2`) 생성 및 핸들러 기반 Listener 제어를 수행하는 기본 역할입니다.

## 주요 변수 (`defaults/main.yml`)
- `oracle_user`: Oracle OS 계정 (기본값: `oracle`)
- `oracle_group`: Oracle 기본 그룹 (기본값: `oinstall`)
- `oracle_base`: `ORACLE_BASE` 경로 (기본값: `/u01/app/oracle`)
- `oracle_home`: `ORACLE_HOME` 경로 (기본값: `/u01/app/oracle/product/19c`)
- `listener_port`: Listener 포트 번호 (기본값: `1521`)
- `db_name`: 전역 데이터베이스 이름 (기본값: `ORCL`)
- `sid`: 인스턴스 SID (기본값: `ORCL`)

## 의존성 (`meta/main.yml`)
- `oracle_prereq`: OS 필수 디렉터리 및 커널 파라미터 점검
- `oracle_user`: Oracle OS 계정 및 리소스 제한 설정
- `oracle_env`: Oracle 환경 변수 프로파일 배포

