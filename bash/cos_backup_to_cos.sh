#!/bin/bash
# 원본 디렉토리 및 COS 대상 버킷 설정
SOURCE_DIR=""
TARGET_COS_BUCKET=""

# 현재 호스트명과 하루 전 날짜 (YYYYMMDD)
HOST_NAME=$(hostname)
DATE=$(date -d '-1 day' '+%Y%m%d')

# 원본 백업 디렉토리
LOCAL_BACKUP_DIR="$SOURCE_DIR/$DATE"

# COS 업로드 대상 경로
REMOTE_TARGET_DIR="$TARGET_COS_BUCKET/$HOST_NAME/$DATE"

# 원본 백업 디렉토리 존재 여부 확인
if [ ! -d "$LOCAL_BACKUP_DIR" ]; then
    exit 1
fi

# COS에 백업 디렉토리 업로드 (재귀적 옵션 사용)
coscli cp --recursive "$LOCAL_BACKUP_DIR" "$REMOTE_TARGET_DIR"
if [ $? -ne 0 ]; then
    exit 1
fi

# 업로드 성공 시 원본 백업 디렉토리 삭제
rm -rf "$LOCAL_BACKUP_DIR"
if [ $? -ne 0 ]; then
    exit 1
fi

exit 0
