from googleapiclient.discovery import build
from google.oauth2 import service_account

def create_backup(project_id, instance_name):
    # 서비스 계정 인증
    credentials = service_account.Credentials.from_service_account_file('path') #API 기입되어있는 JSON 경로 지정
    service = build('sqladmin', 'v1', credentials=credentials)

    try:
        # 백업 생성 요청
        request = service.backupRuns().insert(
            project=project_id,
            instance=instance_name,
            body={}
        )
        response = request.execute()
        print(f"성공적으로 인스턴스 {instance_name}의 백업을 생성했습니다: {response}")
    except Exception as e:
        print(f"인스턴스 {instance_name} 백업 생성 실패: {e}")

if __name__ == "__main__":

    #프로젝트 ID 기입
    PROJECT_ID = ""

    #인스턴스 프리픽스 기입 | 예시 ) gamedb
    INSTANCE_PREFIX = ""

    #범위지정 | 예시 ) START_INDEX = 1 , END_INDEX = 10 | 1번부터 10번까지 백업 진행함
    START_INDEX = 1
    END_INDEX = 1

    # 백업을 생성할 인스턴스 이름 리스트 생성
    instance_names = [f"{INSTANCE_PREFIX}-{i:03}" for i in range(START_INDEX, END_INDEX + 1)]

    # 변경될 인스턴스 리스트 출력 및 확인
    print("다음 인스턴스들의 백업이 생성됩니다:")
    for instance in instance_names:
        print(instance)
    confirmation = input("정말로 이 인스턴스들의 백업을 생성하시겠습니까? (yes/no): ")

    if confirmation.lower() == 'yes':
        for instance_name in instance_names:
            create_backup(PROJECT_ID, instance_name)
    else:
        print("작업이 취소되었습니다.")