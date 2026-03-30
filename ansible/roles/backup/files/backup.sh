#!/bin/bash
# backup.sh

# 백업 파일 이름에 서버 이름과 현재 날짜/시간을 추가
DATE=$(date +%Y%m%d_%H%M%S)
HOSTNAME=$(hostname)
BACKUP_FILE="/tmp/backup_${HOSTNAME}_${DATE}.tar.gz"

# 테라폼으로 만든 S3 버킷 이름을 여기에 넣습니다. (저장할 폴더명 /backups/ 추가)
S3_BUCKET="s3://sixsense-backup-storage-aceur6/backups/"

echo "==> 백업 시작: ${BACKUP_FILE}"

# 시스템 복구에 꼭 필요한 핵심 폴더들만 압축
tar -czf ${BACKUP_FILE} /etc /var/log /home/ubuntu

echo "==> S3 소산 백업(업로드) 진행 중..."
aws s3 cp ${BACKUP_FILE} ${S3_BUCKET}

# 서버 용량 확보를 위해 로컬 압축 파일은 즉시 삭제
rm -f ${BACKUP_FILE}

echo "==> 백업 완료!"