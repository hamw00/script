
---

### 📌 **README.md 샘플**

```md
# Google Cloud SQL 인스턴스 백업 스크립트

## 📖 개요
이 스크립트는 Google Cloud SQL 인스턴스의 백업을 자동으로 생성하는 Python 프로그램입니다.  
지정된 프로젝트 내에서 여러 인스턴스의 백업을 한 번에 생성할 수 있습니다.

## 🛠️ 필요 사항
이 스크립트를 실행하려면 다음 항목이 필요합니다:
- Python 3.x
- Google Cloud Platform (GCP) 프로젝트
- Cloud SQL Admin API 활성화
- 서비스 계정(JSON 키 파일)
- `google-auth`, `google-api-python-client` 라이브러리 설치

## 🔧 설치 방법

1. Python 라이브러리 설치:
   ```sh
   pip install google-auth google-auth-oauthlib google-auth-httplib2 google-api-python-client
   ```

2. GCP 서비스 계정 생성 및 JSON 키 다운로드:
   - [Google Cloud Console](https://console.cloud.google.com/)에 접속
   - IAM & Admin → 서비스 계정 생성
   - "Cloud SQL Admin" 역할 부여
   - JSON 키 파일 다운로드 후 `path`에 저장

3. **프로젝트 ID 및 인스턴스 프리픽스 설정**  
   `main.py`의 아래 부분을 수정합니다.

   ```python
   PROJECT_ID = "your-gcp-project-id"
   INSTANCE_PREFIX = "your-instance-prefix"
   START_INDEX = 1
   END_INDEX = 10
   ```

   예를 들어, `INSTANCE_PREFIX = "gamedb"`이고 `START_INDEX = 1`, `END_INDEX = 3`라면  
   백업이 생성되는 인스턴스 리스트는 다음과 같습니다:
   ```
   gamedb-001
   gamedb-002
   gamedb-003
   ```

## 🚀 실행 방법
터미널에서 아래 명령어를 실행합니다.

```sh
python main.py
```

스크립트 실행 시 다음과 같은 메시지가 표시됩니다:
```
다음 인스턴스들의 백업이 생성됩니다:
gamedb-001
gamedb-002
gamedb-003
정말로 이 인스턴스들의 백업을 생성하시겠습니까? (yes/no): 
```
**`yes` 입력 시 백업이 실행됩니다.**

## 📌 참고 사항
- Google Cloud IAM에서 해당 서비스 계정이 **Cloud SQL Admin 권한**을 가지고 있어야 합니다.
- JSON 키 파일 경로를 올바르게 설정해야 합니다.
- `START_INDEX`, `END_INDEX` 범위 설정 시 실제 존재하는 인스턴스인지 확인하세요.

---