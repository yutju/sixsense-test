 1. Core Workflow (배포 및 동기화)
 deploy-all.sh : 원클릭 전 배포
인프라 구축의 시작과 끝을 담당합니다. Terraform으로 자원을 할당한 뒤, Ansible이 서비스 설정까지 이어받아 '무상태'에서 '서비스 가용' 상태까지 단번에 도달합니다.

워크플로우: 인프라 빌드(TF) → 인스턴스 안정화 대기(30초) → 서비스 구성(Ansible).

실행: ./deploy-all.sh

🔄 refresh-ip.sh : 유동 IP 동기화
AWS 인스턴스 재시작 등으로 Bastion의 퍼블릭 IP가 변경되었을 때, 로컬의 설정 정보를 즉시 갱신합니다.

핵심기능: AWS API 실시간 조회를 통해 변경된 엔드포인트 정보를 Terraform 상태에 반영합니다.

실행: ./refresh-ip.sh

🔒 2. Connectivity & Security (보안 접속)
🛡 bastion-connect.sh : 내부망 보안 접속
외부 노출이 차단된 Private Subnet 내 서버들에 안전하게 접근합니다.

보안방식: SSH Jump Host(-J) 옵션을 활용해 PEM 키를 내부 서버로 복사하지 않고도 안전하게 경유 접속합니다.

실행: ./bastion-connect.sh [대상_사설_IP]

🚇 monitor-connect.sh : 모니터링 터널링
사설망에 격리된 모니터링 서버의 대시보드(Grafana/Prometheus)를 로컬 브라우저에서 바로 확인할 수 있도록 포트를 연결합니다.

포트 맵핑: * Grafana: localhost:8000 접속 시 원격 3000 포트 연결

Prometheus: localhost:9000 접속 시 원격 9090 포트 연결

실행: ./monitor-connect.sh

🔍 3. Observability (상태 점검)
 check-status.sh : 통합 헬스체크
현재 운영 중인 핵심 서비스들의 가용성을 한 번에 스캔합니다.

점검대상:

K3s: 클러스터 노드 정상 작동 여부

Kafka: 메시지 브로커(9092) 응답 확인

Grafana: 시각화 엔진(3000) 포트 활성 체크

실행: ./check-status.sh

⚙️ 설정 및 요구사항
🔐 키 관리 (PEM)
모든 스크립트는 루트 디렉토리의 PEM 키를 자동으로 인식합니다.

기본값: sixsense-test.pem

지정실행: KEY_NAME=my-key.pem ./script.sh

📦 필수 도구
AWS CLI (인증 및 조회)

Terraform (상태 관리)

Ansible (서버 구성)

SSH Agent (키 포워딩)
