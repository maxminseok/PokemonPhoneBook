# 📚 프로젝트 소개
네트워크 통신을 이용해서 서버에서 랜덤 포켓몬 이미지를 불러오고, 연락처를 저장하는 앱 만들기

---

# 📌 요구 사항
- Lv 1 : 메인 화면(친구 목록 화면)의 기본적인 UI 구현
- Lv 2 : 연락처 추가/편집 화면 UI 구현
- Lv 3 : 연락처 추가/편집 화면 네비게이션 바 (상단) 영역 구현
- Lv 4 : 랜덤 이미지 생성 버튼 구현, 포켓몬 API 연결
- Lv 5 :
  - 적용 버튼을 누르면 연락처 데이터(이름/전화번호/프로필이미지)를 디스크에 실제 저장하도록 구현.
  - 저장된 연락처 데이터들을 메인화면 테이블 뷰의 DataSource 로 적용
- Lv 6 : 친구 목록 화면으로 돌아올때마다 “이름순”으로 정렬 되어 보이도록 구현
- Lv 7 :
  - UITableViewCell 을 클릭했을때도 연락처 추가/편집 페이지로 이동하도록 구현
  - 이때 네비게이션 바 영역의 타이틀은 그 연락처 이름이 노출되도록 설정
  - 저장되어있던 이미지,이름,전화번호가 노출되도록 설정 
- Lv 8 : 테이블 셀을 통해 들어온 페이지였을 경우 “적용” 버튼 클릭 시 데이터 Create 가 아닌 데이터 Update 가 되도록 구현
- 추가 구현 사항 :
  - 이미지가 틀을 벗어나지 않게 구현
  - 연락처 개별, 전체 삭제 버튼 구현
  - 추가, 수정, 삭제시 Alert 구현

---

# 🎬 앱 미리보기
## 연락처 추가 및 수정
<img src="https://github.com/user-attachments/assets/b4699f95-6253-4f27-a6f7-738d2bc7fa4f" width="40%" height="40%">

## 연락처 개별 삭제 및 전체 삭제
<img src="https://github.com/user-attachments/assets/b08bcf89-1c78-4abf-8a45-947b2caa9f76" width="40%" height="40%">

---

# 🔎 파일 구성
## Model 폴더
각종 데이터를 저장할 구조체와 서버 통신을 위환 메서드가 구현되어 있는 폴더입니다.
- Margin : UI의 간격과 크기를 지정해놓은 구조체가 있습니다.
- NetworkManage : 서버에서 데이터를 받아오기 위한 메서드가 있습니다.
- PhoneBook : 연락처 데이터를 저장하기 위한 구조체가 있습니다.

## View 폴더
전체 연락처를 띄우는 메인 뷰와, 연락처 정보의 추가, 수정 및 삭제를 위한 뷰가 구현되어 있는 폴더입니다.
- MainView : UITableView로 전체 연락처 정보를 띄우고, 새 정보를 추가하기 위한 추가 버튼, 연락처 전체 정보를 리셋할 삭제 버튼이 구현되어 있습니다.
- EditView : 새 연락처를 추가하거나, 기존 연락처를 수정 및 삭제 하기 위한 뷰 UI가 구현되어 있습니다.
- TableViewCell : 메인 뷰에 띄울 UITableView에 대한 UITableViewCell이 구현되어 있습니다.

## Controller 폴더
메인 뷰를 관리하는 뷰 컨트롤러와, 추가 및 수정을 위한 뷰 컨트롤러가 구현되어 있는 폴더입니다.
- ViewController : 메인 뷰인 MainView의 UI 설정과 동작 및 연락처 데이터인 dataSource를 관리하는 뷰 컨트롤러 입니다.
- PhoneBookViewController : 추가 및 삭제를 위한 EditView의 UI 설정과 동작을 관리하는 뷰 컨트롤러 입니다.

## Protocol 폴더
View와 각 Controller의 역할에 따른 데이터 통신을 위한 프로토콜이 정의되어 있는 폴더입니다.
- PhoneBookEditDelegate : 연락처 데이터 처리를 메인 뷰 컨트롤러인 ViewController에 위임하기 위한 프로토콜 입니다.
- EditViewDelegate : EditView에 있는 버튼들의 이벤트 처리를 위한 프로토콜입니다.

---

# 🙏 커밋 컨벤션
- [ADD] : 파일 추가
- [RENAME] : 파일 혹은 폴더명을 수정하거나 옮기는 작업만인 경우
- [REMOVE] : 파일을 삭제하는 작업만 수행한 경우
- [FEAT] : 기능 추가
- [DELETE] : 기능 삭제
- [UPDATE] : 기능 수정
- [FIX] : 버그 수정
- [REFACTOR] : 리팩토링
- [STYLE] : 스타일 (코드 형식, 세미콜론 추가: 비즈니스 로직에 변경 없음)
- [CHORE] : 기타 변경사항 (빌드 스크립트 수정, 에셋 추가 등)
- [DESIGN] : 사용자 UI 디자인 변경
- [HOTFIX] : 급하게 치명적인 버그를 고쳐야하는 경우
- [COMMENT] : 필요한 주석 추가 및 변경

---
# 🛠️ 트러블슈팅
[트러블 슈팅](https://velog.io/@maxminseok/%EC%97%B0%EB%9D%BD%EC%B2%98-%EC%95%B1-%EB%A7%8C%EB%93%A4%EA%B8%B0-1)
