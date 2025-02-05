
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
                                                    isStoredInMemoryOnly: true,
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
                memberCount: [users[1], users[2]].count,
                category: "공부",
                members: [users[1], users[2]],
                color: "blue",
                dueDate: calendar.date(byAdding: .day, value: 7, to: today)
            ),
            Group(
                name: "운동 그룹",
                memberCount: [users[0], users[1]].count,
                category: "운동",
                members: [users[0], users[1]],
                color: "red",
                dueDate: calendar.date(byAdding: .day, value: 10, to: today)
            ),
            Group(
                name: "여행 계획",
                memberCount: [users[0], users[2]].count,
                category: "여행",
                members: [users[0], users[2]],
                color: "green",
                dueDate: calendar.date(byAdding: .day, value: 14, to: today)
            ),
            Group(
                name: "독서 모임",
                memberCount: 0,
                category: "취미",
                members: [],
                color: "purple",
                dueDate: calendar.date(byAdding: .day, value: 20, to: today)
            ),
            Group(
                name: "요리 연구회",
                memberCount: 0,
                category: "요리",
                members: [],
                color: "orange",
                dueDate: calendar.date(byAdding: .day, value: 15, to: today)
            ),
            Group(
                name: "프로그래밍 동아리",
                memberCount: 0,
                category: "코딩",
                members: [],
                color: "yellow",
                dueDate: calendar.date(byAdding: .day, value: 30, to: today)
            ),
            Group(
                name: "영화 감상회",
                memberCount: 0,
                category: "문화",
                members: [],
                color: "brown",
                dueDate: calendar.date(byAdding: .day, value: 25, to: today)
            ),
            Group(
                name: "사진 촬영 모임",
                memberCount: 0,
                category: "사진",
                members: [],
                color: "gray",
                dueDate: calendar.date(byAdding: .day, value: 18, to: today)
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
        
        let missions: [(String, Group?, [DateStamp])] = [
            ("Swift 공부하기", groups[0], [DateStamp(date: today, isCompleted: true)]),
            ("알고리즘 문제 풀기", groups[0], [DateStamp(date: today, isCompleted: false)]),
            ("헬스장 가기", groups[1], [DateStamp(date: today, isCompleted: false)]),
            ("달리기 5km", groups[1], [DateStamp(date: today, isCompleted: true)]),
            ("여행 일정 정하기", groups[2], [DateStamp(date: today, isCompleted: false)]),
            ("비행기표 예매", groups[2], [DateStamp(date: today, isCompleted: false)])
        ]
        
        for (title, group, dateStamp) in missions {
            let mission = Mission(title: title, dateStamp: dateStamp, group: group)
            container.mainContext.insert(mission)
        }
        
        try? container.mainContext.save()
    }
}
