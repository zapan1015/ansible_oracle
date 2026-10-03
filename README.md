# Ansible Oracle DBA Automation Lab

오라클 DBA를 위한 앤서블(Ansible) 자동화 실습 및 Oracle RAC 19c 운영 환경 프로젝트입니다.

---

## 📁 리포지토리 구성

- [docs/](file:///c:/Users/zapan/Documents/ansible_oracle/docs) : 오라클 DBA를 위한 앤서블 자동화 실습 원고 및 교재
  - [`ansible_oracle_dba_manuscript.md`](file:///c:/Users/zapan/Documents/ansible_oracle/docs/ansible_oracle_dba_manuscript.md) : Chapter 1 앤서블 기초와 오라클 DBA 환경 구축 원고
- [chapter_1/](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_1) : Chapter 1 실습용 Docker 멀티 컨테이너 환경 및 Ansible 플레이북
  - `docker-compose.yml` : Ansible Control Node + Oracle 19c RAC/Grid Managed Nodes (db01, db02, grid01)
  - `ansible-oracle-dba/` : `ansible.cfg`, `inventory`, `group_vars`, `host_vars`, `playbooks`
  - `rac_19c_architecture/` : Oracle 공식 RAC 19c on Container 아키텍처 및 배포 가이드
  - [`chapter_1/README.md`](file:///c:/Users/zapan/Documents/ansible_oracle/chapter_1/README.md) : 실습 실행 가이드

---

## 🚀 빠른 시작 (Quickstart)

```bash
# 1. Chapter 1 실습 환경 기동
cd chapter_1
docker compose up -d --build

# 2. 제어 노드(Ansible Control Node) 접속
docker exec -it ansible-control bash

# 3. 연결 확인 및 플레이북 실행
ansible all -m ping
ansible-playbook playbooks/02_setup_oracle_env.yml
```
