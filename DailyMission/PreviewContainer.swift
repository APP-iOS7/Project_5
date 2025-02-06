
//
//  PreviewContainer.swift
//  DailyMission
//
//  Created by 이민서 on 2/5/25.
//

import Foundation
import SwiftData

@MainActor
class PreviewContainer {
    static let shared: PreviewContainer = PreviewContainer()
    
    let container: ModelContainer
    
    init() {
        let schema = Schema([
            User.self, Group.self, Mission.self, DateStamp.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema,
                                                    isStoredInMemoryOnly: false,
                                                    cloudKitDatabase: .none)
        
        do {
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            insertPreviewData()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    func insertPreviewData() {
        let today = Date()
        let existingUsers = try? container.mainContext.fetch(FetchDescriptor<User>())
        if let existingUsers = existingUsers, !existingUsers.isEmpty {
            print("📌 기존 데이터가 존재합니다. 새로운 데이터 삽입을 건너뜁니다.")
            return
        }
        let users: [User] = [
            User(id: "minseo", password: "1234"),
            User(id: "hajin", password: "1234"),
            User(id: "junho", password: "1234")
        ]
        
        for user in users {
            container.mainContext.insert(user)
        }
        let calendar = Calendar.current
        
        let groups: [Group] = [
            Group(
                name: "스터디 그룹",
                members: [users[1], users[2]],
                category: "공부",
                
                color: "blue",
                dueDate: calendar.date(byAdding: .day, value: 7, to: today)
            ),
            Group(
                name: "운동 그룹",
                members: [users[0], users[1]],
                category: "운동",
                
                color: "red",
                dueDate: calendar.date(byAdding: .day, value: 10, to: today)
            ),
            Group(
                name: "여행 계획",
                members: [users[0], users[2]],
                category: "여행",
                
                color: "green",
                dueDate: calendar.date(byAdding: .day, value: 14, to: today)
            ),
            Group(
                name: "독서 모임",
                members: [],
                category: "취미",
                color: "purple",
                dueDate: calendar.date(byAdding: .day, value: 20, to: today)
            ),
            Group(
                name: "요리 연구회",
                members: [],
                category: "요리",
                color: "orange",
                dueDate: calendar.date(byAdding: .day, value: 15, to: today)
            ),
            Group(
                name: "프로그래밍 동아리",
                members: [],
                category: "코딩",
                color: "yellow",
                dueDate: calendar.date(byAdding: .day, value: 30, to: today)
            ),
            Group(
                name: "영화 감상회",
                members: [],
                category: "문화",
                
                color: "brown",
                dueDate: nil
            ),
            Group(
                name: "사진 촬영 모임",
                members: [],
                category: "사진",
                
                color: "gray",
                dueDate: nil
            )
        ]
        
        for group in groups {
            container.mainContext.insert(group)
        }
        try? container.mainContext.save()
        
        users[0].groups = [groups[1], groups[2]]
        users[1].groups = [groups[0], groups[1]]
        users[2].groups = [groups[0], groups[2]]
        try? container.mainContext.save()
        
        let missions: [(String, Group, [DateStamp])] = [
            // 스터디 그룹
            ("Swift 공부하기", groups[0], [DateStamp(date: today, isCompleted: true)]),
            ("알고리즘 문제 풀기", groups[0], [DateStamp(date: today, isCompleted: false)]),
            ("코딩 테스트 연습", groups[0], [DateStamp(date: today, isCompleted: false)]),
            
            // 운동 그룹
            ("헬스장 가기", groups[1], [DateStamp(date: today, isCompleted: false)]),
            ("달리기 5km", groups[1], [DateStamp(date: today, isCompleted: true)]),
            ("팔굽혀펴기 100개", groups[1], [DateStamp(date: today, isCompleted: false)]),
            
            // 여행 계획
            ("여행 일정 정하기", groups[2], [DateStamp(date: today, isCompleted: false)]),
            ("비행기표 예매", groups[2], [DateStamp(date: today, isCompleted: false)]),
            ("숙소 예약", groups[2], [DateStamp(date: today, isCompleted: true)]),
            
            // 독서 모임
            ("이달의 책 선정", groups[3], [DateStamp(date: today, isCompleted: false)]),
            ("책 읽기 목표 설정", groups[3], [DateStamp(date: today, isCompleted: true)]),
            ("독후감 공유", groups[3], [DateStamp(date: today, isCompleted: false)]),
            
            // 요리 연구회
            ("이번 주 요리 주제 정하기", groups[4], [DateStamp(date: today, isCompleted: false)]),
            ("레시피 연구하기", groups[4], [DateStamp(date: today, isCompleted: true)]),
            ("팀별 요리 대회 개최", groups[4], [DateStamp(date: today, isCompleted: false)]),
            
            // 프로그래밍 동아리
            ("오픈소스 프로젝트 기여", groups[5], [DateStamp(date: today, isCompleted: false)]),
            ("새로운 언어 배우기", groups[5], [DateStamp(date: today, isCompleted: false)]),
            ("해커톤 준비", groups[5], [DateStamp(date: today, isCompleted: true)]),
            
            // 영화 감상회
            ("이번 달 영화 선정", groups[6], [DateStamp(date: today, isCompleted: false)]),
            ("감상문 작성", groups[6], [DateStamp(date: today, isCompleted: true)]),
            ("영화 토론회 개최", groups[6], [DateStamp(date: today, isCompleted: false)]),
            
            // 사진 촬영 모임
            ("촬영 테마 정하기", groups[7], [DateStamp(date: today, isCompleted: true)]),
            ("야외 촬영 일정 조율", groups[7], [DateStamp(date: today, isCompleted: false)]),
            ("사진 편집 워크숍 개최", groups[7], [DateStamp(date: today, isCompleted: false)])
        ]
        
        for (title, group, dateStamp) in missions {
            let mission = Mission(title: title, dateStamp: dateStamp, group: group)
            container.mainContext.insert(mission)
        }
        
        try? container.mainContext.save()
    }
}
