#!/bin/bash
# 원본 디렉토리 및 COS 대상 버킷 설정
SOURCE_DIR="/backup"
TARGET_COS_BUCKET="cos://backup"

# 현재 호스트명과 1일 전 날짜 (YYYYMMDD)
HOST_NAME=$(hostname)
DATE=$(date -d '-1 day' '+%Y%m%d')

# 원본 백업 디렉토리 (예: /backup)
LOCAL_BACKUP_DIR="$SOURCE_DIR/$DATE"

# 압축 파일 경로 (예: /dblog/backup/20250222.tar.gz)
COMPRESSED_FILE="$SOURCE_DIR/${DATE}.tar.gz"

# COS 업로드 대상 경로 (예: cos://backup/호스트명/20250222.tar.gz)
REMOTE_TARGET_FILE="$TARGET_COS_BUCKET/$HOST_NAME/${DATE}.tar.gz"

# 원본 백업 디렉토리 존재 여부 확인
if [ ! -d "$LOCAL_BACKUP_DIR" ]; then
    echo "Error: Local backup directory '$LOCAL_BACKUP_DIR' does not exist."
    exit 1
fi

# 원본 디렉토리 압축 (SOURCE_DIR내에 있는 DATE 디렉토리를 압축)
tar -czf "$COMPRESSED_FILE" -C "$SOURCE_DIR" "$DATE"
if [ $? -ne 0 ]; then
    echo "Error: Failed to compress $LOCAL_BACKUP_DIR."
    exit 1
fi

# 압축 파일 COS에 업로드
coscli cp "$COMPRESSED_FILE" "$REMOTE_TARGET_FILE"
if [ $? -ne 0 ]; then
    echo "Error: coscli cp command failed for $COMPRESSED_FILE."
    exit 1
fi

# 업로드 성공 시 압축 파일과 원본 백업 디렉토리 삭제
rm -f "$COMPRESSED_FILE"
if [ $? -ne 0 ]; then
    echo "Error: Failed to delete compressed file $COMPRESSED_FILE."
    exit 1
fi

rm -rf "$LOCAL_BACKUP_DIR"
if [ $? -ne 0 ]; then
    echo "Error: Failed to delete local backup directory $LOCAL_BACKUP_DIR."
    exit 1
fi

exit 0
