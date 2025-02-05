
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
                        memberCount: [users[1], users[2]].count,
                        category: "여행",
                        members: [users[1], users[2]],
                        color: "green",
                        dueDate: calendar.date(byAdding: .day, value: 14, to: today)
                    )
                ]
        
        for group in groups {
            container.mainContext.insert(group)
        }
        
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
