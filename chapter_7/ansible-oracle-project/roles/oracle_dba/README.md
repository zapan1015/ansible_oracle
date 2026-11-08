# Role: `oracle_dba` (Master Project)

DEV, TEST, PROD 다중 환경에서 공통으로 재사용할 수 있는 마스터 Oracle DBA 자동화 역할입니다.

## 수행 작업
1. 의존 역할(`oracle_prereq`, `oracle_user`, `oracle_env`) 자동 실행
2. 환경별 Jinja2 템플릿 기반 `listener.ora`, `tnsnames.ora`, `sqlnet.ora` 배포 및 변경 시 핸들러(`Restart Oracle listener`) 호출
3. 정적 SQL 스크립트(`files/setup_db.sql`) 배포 및 멱등적 실행
4. 애플리케이션 테이블스페이스(`db_tablespace`) 및 사용자(`db_user`) 프로비저닝

