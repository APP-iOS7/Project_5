# Project_5 팀
---
![cover image](https://github.com/APP-iOS7/Project_5/blob/dev/cover.png)

## ⏲️ 개발 기간 
- 2025.02.04(화) ~ 2025.02.06(목)
- 2025.02.07(금) 발표
---  
## 🧑‍🤝‍🧑 개발자 소개 
- **이민서** : 
- **최하진** : 
- **양준호** : 
---
## 💻 개발환경
- **Language** : Swift
- **IDE** : Xcode 16.2
- **Framework** : SwiftUI

---
## 📌 앱 화면 및 주요 기능
![scene1](https://github.com/APP-iOS7/Project_5/blob/dev/scene1.png)
- 메인화면에서 [내가 등록된 그룹] 과 [기타 그룹] 을 GridView 로 보여줌
- 그룹을 직접 생성하여, 참여자들과 함께 성취도를 모니터링해 나갈 수 있음
 
![scene2](https://github.com/APP-iOS7/Project_5/blob/dev/scene2.png)
- 날짜별로 미션을 정하여 관리할 수 있음
- 성취하고싶은 미션을 등록하여 동기부여
 
![scene3](https://github.com/APP-iOS7/Project_5/blob/dev/scene3.png)
- 나와 그룹원들의 성취도를 개인별로 차트로 보여주어, 경생심 고취 및 동기 부여
      
---
## Entity 관계도
![entity diagram](https://github.com/APP-iOS7/Project_5/blob/dev/diagram.png)
### property 포함하여 관계 분석
![entity diagram](https://github.com/APP-iOS7/Project_5/blob/dev/diagram2.png)
---
## Entity 관계 설명
* User ↔ UserGroup ↔ Group (Many-to-Many 관계, 중간 테이블 UserGroup 사용)
* Group ↔ Mission (One-to-Many, 하나의 그룹에 여러 미션이 속함)
* Mission ↔ UserStamp (One-to-Many, 하나의 미션에 여러 유저 진행 기록 존재)
* UserStamp ↔ DateStamp (One-to-Many, 한 유저가 특정 미션에서 여러 날짜의 진행 상태를 기록)

---

## 👀 회고
### 📚 배운 점
    - github에서 협업을 자세히 이해
    - 다대다 구조 모델의 이해

### 👍 잘한 점
    - 각자 맡은 바를 끝까지 완성함
    - 혼자 해결하지 못하는 부분은 서로의 도움을 받아 서로의 단점을 보완함
    - 늦은 시간까지 개발을 하였는데도 싸우지 않고 프로젝트를 잘 마무리
    - 다대다 모델링 성공시킨 점
    - 초반에 기획했던 앱에 비해 더 나은 앱 기능과 UI 기능을 위해 끊임없이 추가 작업을 진행하였다는 점

### 😅 아쉬운 점
    - 그룹이나 미션의 삭제의 기능을 구현하지 못함
    - 처음부터 데이터를 완성시켜놓고 시작하지 않아서 수정에 많은 시간을 들인 점
    - 회원가입 완료 시 뜨는 Alert에서 확인을 누르지 못하고 넘어감
    - User 데이터를 SwiftData로 관리하기 때문에 핸드폰이 바뀌면 데이터가 싹 날아가는 점
    - 팀원이 작성한 코드를 제대로 읽어보고 이해하기에 시간이 부족했던 점

### 😅 깨달은 점
    - SwiftData의 다대다 관계 mapping은 사용하기 전에 확실한 공부가 필요하다는 점
