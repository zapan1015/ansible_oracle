# Chapter 3: Ansible 애드혹(Ad-hoc) 명령 실습 (Oracle DBA)

이 디렉토리는 오라클 DBA를 위한 **Ansible 애드혹(Ad-hoc) 명령**을 실습하기 위한 Docker 환경입니다. 플레이북을 작성하지 않고 한 줄의 명령어로 여러 서버에 즉시 작업을 실행하는 방법을 연습합니다.

## 1. 아키텍처 구성

본 실습 환경은 교재(`73_ansible_adhoc_commands_for_oracle_dba.md`)의 구성에 맞추어 다음과 같이 배포됩니다.

- **ansible-control-ch3** (192.168.3.10) : 앤서블 제어 노드
- **devdb** (192.168.3.101) : Oracle Server (Dev)
- **testdb** (192.168.3.102) : Oracle Server (Test)
- **proddb** (192.168.3.103) : Oracle Server (Prod)

## 2. 실습 시작 방법

### 1) 컨테이너 기동

터미널에서 현재 디렉토리(`chapter_3`)로 이동한 후 다음 명령어를 실행하여 컨테이너를 올립니다.

```bash
docker-compose up -d --build
```

### 2) 제어 노드 접속

Ansible 명령어를 실행할 제어 노드에 접속합니다.

```bash
docker exec -it ansible-control-ch3 bash
```

## 3. 주요 실습 명령어 모음

제어 노드에 접속한 상태에서 아래 명령어들을 직접 실행해 보며 동작을 확인합니다.

```bash
# 1. 서버 통신 확인 (ping 모듈)
ansible all -m ping

# 2. 서버 호스트명 및 OS 정보 확인 (command 모듈)
ansible all -m command -a "hostname"
ansible all -m command -a "cat /etc/os-release"

# 3. 디스크 및 메모리 공간 확인 (shell 모듈)
ansible db_servers -m shell -a "df -h"
ansible db_servers -m shell -a "free -m"

# 4. 파일/디렉토리 관리 (file 모듈)
# 참고: /u01 등 루트 소유 영역에 새 디렉터리를 생성하고 소유권을 지정할 때는 관리자 권한(-b, become)을 사용합니다.
ansible dev -m file -a "path=/u01/testdir state=directory mode=755 owner=oracle group=oinstall" -b

# 또는 이미 oracle 계정 권한이 있는 하위 경로에 생성할 경우 (-b 불필요):
# ansible dev -m file -a "path=/u01/app/oracle/testdir state=directory mode=755 owner=oracle group=oinstall"

# 5. OS 패키지 설치 확인 (package 모듈) - sudo 권한 필요(-b)
ansible all -m package -a "name=httpd state=present" -b
```

## 4. 실습 종료 및 환경 정리

실습이 끝난 후 환경을 삭제하려면 아래 명령어를 사용합니다.

```bash
exit # 제어 노드에서 빠져나오기
docker compose down -v
```
