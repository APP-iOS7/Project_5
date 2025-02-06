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
## 앱 화면
![scene1](https://github.com/APP-iOS7/Project_5/blob/dev/scene1.png)

![scene2](https://github.com/APP-iOS7/Project_5/blob/dev/scene2.png) 
![scene3](https://github.com/APP-iOS7/Project_5/blob/dev/scene3.png)

---
## 📌 주요 기능
- aaa
  - aaa
  - aaa

- bbb
   - bbb
   - bbb
- ccc
    - ccc
    - ccc
    - ccc
      
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
