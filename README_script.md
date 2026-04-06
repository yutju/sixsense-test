SixSense Ops-Toolkit Guide
본 디렉토리는 SixSense 아키텍처의 배포 자동화, 보안 접속, 관측성 확보를 위한 운영 스크립트 모음입니다. 모든 스크립트는 인프라 상태의 일관성 유지와 보안 가이드라인 준수를 원칙으로 설계되었습니다.

1. 배포 및 상태 동기화 (Core Workflow)
deploy-all.sh
인프라 프로비저닝과 서비스 구성을 통합 실행합니다. Terraform으로 AWS 자원을 할당한 후, Ansible이 소프트웨어 스택을 구성하여 서비스 가동 상태까지 자동 도달합니다.

프로세스: Terraform Build → Instance Ready Wait(30s) → Ansible Configuration

사용법: ./deploy-all.sh

refresh-ip.sh
인스턴스 재시작 등으로 Bastion의 Public IP가 변경된 경우, 로컬의 Terraform 상태를 최신화하여 연결성을 복구합니다.

주요기능: AWS API 실시간 조회를 통한 엔드포인트 정보 갱신

사용법: ./refresh-ip.sh

2. 보안 접속 (Connectivity & Security)
bastion-connect.sh
VPC 내부망(Private Subnet)에 위치한 서버들에 안전하게 접근하기 위한 통로를 제공합니다.

접속방식: SSH Jump Host(-J) 옵션을 사용하여 PEM 키를 원격지로 복사하지 않고 안전하게 경유 접속합니다.

사용법: ./bastion-connect.sh [Target_Private_IP]

monitor-connect.sh
사설망에 격리된 모니터링 서버(Grafana, Prometheus)를 로컬 환경에서 접근할 수 있도록 SSH 터널링을 생성합니다.

포트맵핑:

Grafana: localhost:8000 ↔ Remote:3000

Prometheus: localhost:9000 ↔ Remote:9090

사용법: ./monitor-connect.sh

3. 상태 점검 (Observability)
check-status.sh
주요 서비스의 포트 활성화 및 응답 여부를 일괄 점검하여 운영 가시성을 확보합니다.

점검항목:

K3s Cluster: 노드 가용 상태 확인

Kafka: 메시지 브로커(9092) 활성 체크

Grafana: 시각화 엔진(3000) 활성 체크

사용법: ./check-status.sh

4. 환경 설정 및 요구사항 (Prerequisites)
PEM 키 관리
스크립트는 프로젝트 루트 디렉토리의 키 파일을 자동으로 탐색합니다.

기본값: sixsense-test.pem

사용자 지정: KEY_NAME=custom.pem ./script.sh 형식으로 실행 시 지정 가능합니다.

필수 의존성
본 툴킷 실행을 위해 아래 도구의 사전 설치 및 설정이 필요합니다.

AWS CLI: 리소스 쿼리 및 인증용

Terraform: 인프라 상태 관리용

Ansible: 구성 관리용

SSH Agent: 키 포워딩 및 세션 관리용
