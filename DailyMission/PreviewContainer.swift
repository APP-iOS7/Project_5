
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
            User.self, Group.self, Mission.self, DateStamp.self, UserStamp.self ,UserGroup.self
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
                missionTitle: [],
                category: "공부",
                
                color: "blue",
                dueDate: calendar.date(byAdding: .day, value: 7, to: today),
                createdAt: Date()
            ),
            Group(
                name: "운동 그룹",
                missionTitle: [],
                category: "운동",
                
                color: "red",
                dueDate: calendar.date(byAdding: .day, value: 10, to: today),
                createdAt: Date()
            ),
            Group(
                name: "여행 계획",
                missionTitle: [],
                category: "여행",
                
                color: "green",
                dueDate: calendar.date(byAdding: .day, value: 14, to: today),
                createdAt: Date()
            ),
            Group(
                name: "독서 모임",
                missionTitle: [],
                category: "취미",
                color: "purple",
                dueDate: calendar.date(byAdding: .day, value: 20, to: today),
                createdAt: Date()
            ),
            Group(
                name: "요리 연구회",
                missionTitle: [],
                category: "요리",
                color: "orange",
                dueDate: calendar.date(byAdding: .day, value: 15, to: today),
                createdAt: Date()
            ),
            Group(
                name: "프로그래밍 동아리",
                missionTitle: [],
                category: "코딩",
                color: "yellow",
                dueDate: calendar.date(byAdding: .day, value: 30, to: today),
                createdAt: Date()
            ),
            Group(
                name: "영화 감상회",
                missionTitle: [],
                category: "문화",
                
                color: "brown",
                dueDate: nil,
                createdAt: Date()
            ),
            Group(
                name: "사진 촬영 모임",
                missionTitle: [],
                category: "사진",
                
                color: "gray",
                dueDate: nil,
                createdAt: Date()
            )
        ]
        
        for group in groups {
            container.mainContext.insert(group)
        }
        try? container.mainContext.save()
        let userGroups: [UserGroup] = [
            UserGroup(user: users[0], group: groups[1]),
            UserGroup(user: users[0], group: groups[2]),
            UserGroup(user: users[1], group: groups[0]),
            UserGroup(user: users[1], group: groups[1]),
            UserGroup(user: users[2], group: groups[0]),
            UserGroup(user: users[2], group: groups[2])
        ]
        
        for userGroup in userGroups {
            container.mainContext.insert(userGroup)
        }
        try? container.mainContext.save()
        
        
        let missionIcons = [
            "star", "heart", "flame", "bolt", "leaf",
            "pencil", "book", "clock", "figure.walk", "bicycle",
            "gamecontroller", "paintbrush", "camera", "music.note", "flag"
        ]
        
        let missions: [Mission] = [
            // 스터디 그룹
            Mission(title: "Swift 공부하기",
                    userStamp: groups[0].groupUsers.map { userGroup in
                        let userStamp = UserStamp(userId: userGroup.user.id, dateStamp: [DateStamp(date: today, isCompleted: false)])
                            return userStamp
                        },
                    endDate: Calendar.current.date(byAdding: .day, value: 5, to: today) ?? today,
                    icon: missionIcons[0],
                    group: groups[0]),
            
            Mission(title: "알고리즘 문제 풀기",
                    userStamp: groups[0].groupUsers.map {
                        let userStamp = UserStamp(userId: $0.user.id)
                        userStamp.dateStamp.append(DateStamp(date: today, isCompleted: false))
                        container.mainContext.insert(userStamp)
                        return userStamp
                    },
                    endDate: Calendar.current.date(byAdding: .day, value: 7, to: today) ?? today,
                    icon: missionIcons[1],
                    group: groups[0]),
            
            Mission(title: "코딩 테스트 연습",
                    userStamp: groups[0].groupUsers.map {
                        let userStamp = UserStamp(userId: $0.user.id)
                        userStamp.dateStamp.append(DateStamp(date: today, isCompleted: false))
                        container.mainContext.insert(userStamp)
                        return userStamp
                    },
                    endDate: Calendar.current.date(byAdding: .day, value: 10, to: today) ?? today,
                    icon: missionIcons[2],
                    group: groups[0]),
            
            // 운동 그룹
            Mission(title: "헬스장 가기",
                    userStamp: groups[0].groupUsers.map {
                        let userStamp = UserStamp(userId: $0.user.id)
                        userStamp.dateStamp.append(DateStamp(date: today, isCompleted: false))
                        container.mainContext.insert(userStamp)
                        return userStamp
                    },
                    endDate: Calendar.current.date(byAdding: .day, value: 3, to: today) ?? today,
                    icon: missionIcons[3],
                    group: groups[1]),
            
            Mission(title: "달리기 5km",
                    userStamp: groups[0].groupUsers.map {
                        let userStamp = UserStamp(userId: $0.user.id)
                        userStamp.dateStamp.append(DateStamp(date: today, isCompleted: false))
                        container.mainContext.insert(userStamp)
                        return userStamp
                    },
                    endDate: Calendar.current.date(byAdding: .day, value: 5, to: today) ?? today,
                    icon: missionIcons[4],
                    group: groups[1]),
            
            Mission(title: "팔굽혀펴기 100개",
                    userStamp: groups[0].groupUsers.map {
                        let userStamp = UserStamp(userId: $0.user.id)
                        userStamp.dateStamp.append(DateStamp(date: today, isCompleted: false))
                        container.mainContext.insert(userStamp)
                        return userStamp
                    },
                    endDate: Calendar.current.date(byAdding: .day, value: 7, to: today) ?? today,
                    icon: missionIcons[5],
                    group: groups[1]),
            // 여행 계획
            Mission(title: "여행 일정 정하기",
                    userStamp: groups[0].groupUsers.map {
                        let userStamp = UserStamp(userId: $0.user.id)
                        userStamp.dateStamp.append(DateStamp(date: today, isCompleted: false))
                        container.mainContext.insert(userStamp)
                        return userStamp
                    },
                    endDate: Calendar.current.date(byAdding: .day, value: 14, to: today) ?? today,
                    icon: missionIcons[6],
                    group: groups[2]),
            
            Mission(title: "비행기표 예매",
                    userStamp: groups[0].groupUsers.map {
                        let userStamp = UserStamp(userId: $0.user.id)
                        userStamp.dateStamp.append(DateStamp(date: today, isCompleted: false))
                        container.mainContext.insert(userStamp)
                        return userStamp
                    },
                    endDate: Calendar.current.date(byAdding: .day, value: 10, to: today) ?? today,
                    icon: missionIcons[7],
                    group: groups[2]),
            
            Mission(title: "숙소 예약",
                    userStamp: groups[0].groupUsers.map {
                        let userStamp = UserStamp(userId: $0.user.id)
                        userStamp.dateStamp.append(DateStamp(date: today, isCompleted: false))
                        container.mainContext.insert(userStamp)
                        return userStamp
                    },
                    endDate: Calendar.current.date(byAdding: .day, value: 12, to: today) ?? today,
                    icon: missionIcons[8],
                    group: groups[2]),
            
            // 독서 모임
            Mission(title: "이달의 책 선정",
                    userStamp: groups[0].groupUsers.map {
                        let userStamp = UserStamp(userId: $0.user.id)
                        userStamp.dateStamp.append(DateStamp(date: today, isCompleted: false))
                        container.mainContext.insert(userStamp)
                        return userStamp
                    },
                    endDate: Calendar.current.date(byAdding: .day, value: 15, to: today) ?? today,
                    icon: missionIcons[9],
                    group: groups[3]),
            
            Mission(title: "책 읽기 목표 설정",
                    userStamp: groups[0].groupUsers.map {
                        let userStamp = UserStamp(userId: $0.user.id)
                        userStamp.dateStamp.append(DateStamp(date: today, isCompleted: false))
                        container.mainContext.insert(userStamp)
                        return userStamp
                    },
                    endDate: Calendar.current.date(byAdding: .day, value: 20, to: today) ?? today,
                    icon: missionIcons[10],
                    group: groups[3]),
            
            Mission(title: "독후감 공유",
                    userStamp: groups[0].groupUsers.map {
                        let userStamp = UserStamp(userId: $0.user.id)
                        userStamp.dateStamp.append(DateStamp(date: today, isCompleted: false))
                        container.mainContext.insert(userStamp)
                        return userStamp
                    },
                    endDate: Calendar.current.date(byAdding: .day, value: 25, to: today) ?? today,
                    icon: missionIcons[11],
                    group: groups[3]),
            
            // 요리 연구회
            Mission(title: "이번 주 요리 주제 정하기",
                    userStamp: groups[0].groupUsers.map {
                        let userStamp = UserStamp(userId: $0.user.id)
                        userStamp.dateStamp.append(DateStamp(date: today, isCompleted: false))
                        container.mainContext.insert(userStamp)
                        return userStamp
                    },
                    endDate: Calendar.current.date(byAdding: .day, value: 6, to: today) ?? today,
                    icon: missionIcons[12],
                    group: groups[4]),
            
            Mission(title: "레시피 연구하기",
                    userStamp: groups[0].groupUsers.map {
                        let userStamp = UserStamp(userId: $0.user.id)
                        userStamp.dateStamp.append(DateStamp(date: today, isCompleted: false))
                        container.mainContext.insert(userStamp)
                        return userStamp
                    },
                    endDate: Calendar.current.date(byAdding: .day, value: 9, to: today) ?? today,
                    icon: missionIcons[13],
                    group: groups[4]),
            
            Mission(title: "팀별 요리 대회 개최",
                    userStamp: groups[0].groupUsers.map {
                        let userStamp = UserStamp(userId: $0.user.id)
                        userStamp.dateStamp.append(DateStamp(date: today, isCompleted: false))
                        container.mainContext.insert(userStamp)
                        return userStamp
                    },
                    endDate: Calendar.current.date(byAdding: .day, value: 15, to: today) ?? today,
                    icon: missionIcons[13],
                    group: groups[4]),
            
            // 프로그래밍 동아리
            Mission(title: "오픈소스 프로젝트 기여",
                    userStamp: groups[0].groupUsers.map {
                        let userStamp = UserStamp(userId: $0.user.id)
                        userStamp.dateStamp.append(DateStamp(date: today, isCompleted: false))
                        container.mainContext.insert(userStamp)
                        return userStamp
                    },
                    endDate: Calendar.current.date(byAdding: .day, value: 6, to: today) ?? today,
                    icon: missionIcons[12],
                    group: groups[5]),
            
            Mission(title: "새로운 언어 배우기",
                    userStamp: groups[0].groupUsers.map {
                        let userStamp = UserStamp(userId: $0.user.id)
                        userStamp.dateStamp.append(DateStamp(date: today, isCompleted: false))
                        container.mainContext.insert(userStamp)
                        return userStamp
                    },
                    endDate: Calendar.current.date(byAdding: .day, value: 6, to: today) ?? today,
                    icon: missionIcons[12],
                    group: groups[5]),
            
            Mission(title: "해커톤 준비",
                    userStamp: groups[0].groupUsers.map {
                        let userStamp = UserStamp(userId: $0.user.id)
                        userStamp.dateStamp.append(DateStamp(date: today, isCompleted: false))
                        container.mainContext.insert(userStamp)
                        return userStamp
                    },
                    endDate: Calendar.current.date(byAdding: .day, value: 6, to: today) ?? today,
                    icon: missionIcons[12],
                    group: groups[5]),
            
            // 영화 감상회
            Mission(title: "이번 달 영화 선정",
                    userStamp: groups[0].groupUsers.map {
                        let userStamp = UserStamp(userId: $0.user.id)
                        userStamp.dateStamp.append(DateStamp(date: today, isCompleted: false))
                        container.mainContext.insert(userStamp)
                        return userStamp
                    },
                    endDate: Calendar.current.date(byAdding: .day, value: 6, to: today) ?? today,
                    icon: missionIcons[12],
                    group: groups[6]),
            
            Mission(title: "감상문 작성",
                    userStamp: groups[0].groupUsers.map {
                        let userStamp = UserStamp(userId: $0.user.id)
                        userStamp.dateStamp.append(DateStamp(date: today, isCompleted: false))
                        container.mainContext.insert(userStamp)
                        return userStamp
                    },
                    endDate: Calendar.current.date(byAdding: .day, value: 6, to: today) ?? today,
                    icon: missionIcons[12],
                    group: groups[6]),
            
            Mission(title: "영화 토론회 개최",
                    userStamp: groups[0].groupUsers.map {
                        let userStamp = UserStamp(userId: $0.user.id)
                        userStamp.dateStamp.append(DateStamp(date: today, isCompleted: false))
                        container.mainContext.insert(userStamp)
                        return userStamp
                    },
                    endDate: Calendar.current.date(byAdding: .day, value: 6, to: today) ?? today,
                    icon: missionIcons[12],
                    group: groups[6]),
            
            // 사진 촬영 모임
            Mission(title: "촬영 테마 정하기",
                    userStamp: groups[0].groupUsers.map {
                        let userStamp = UserStamp(userId: $0.user.id)
                        userStamp.dateStamp.append(DateStamp(date: today, isCompleted: false))
                        container.mainContext.insert(userStamp)
                        return userStamp
                    },
                    endDate: Calendar.current.date(byAdding: .day, value: 6, to: today) ?? today,
                    icon: missionIcons[12],
                    group: groups[7]),
            
            Mission(title: "야외 촬영 일정 조율",
                    userStamp: groups[0].groupUsers.map {
                        let userStamp = UserStamp(userId: $0.user.id)
                        userStamp.dateStamp.append(DateStamp(date: today, isCompleted: false))
                        container.mainContext.insert(userStamp)
                        return userStamp
                    },
                    endDate: Calendar.current.date(byAdding: .day, value: 6, to: today) ?? today,
                    icon: missionIcons[12],
                    group: groups[7]),
            
            Mission(title: "사진 편집 워크숍 개최",
                    userStamp: groups[0].groupUsers.map {
                        let userStamp = UserStamp(userId: $0.user.id)
                        userStamp.dateStamp.append(DateStamp(date: today, isCompleted: false))
                        container.mainContext.insert(userStamp)
                        return userStamp
                    },
                    endDate: Calendar.current.date(byAdding: .day, value: 6, to: today) ?? today,
                    icon: missionIcons[12],
                    group: groups[7])
            
        ]
        for mission in missions {
            let userStamps = mission.group?.groupUsers.map { userGroup in
                UserStamp(userId: userGroup.user.id, dateStamp: [DateStamp(date: today, isCompleted: false)])
            } ?? []
            
            let newMission = Mission(
                title: mission.title,
                userStamp: userStamps,
                endDate: mission.endDate,
                icon: mission.icon,
                group: mission.group
            )
            
            container.mainContext.insert(newMission)
            
            if newMission.group?.missionTitle == nil {
                newMission.group?.missionTitle = []
            }
            newMission.group?.missionTitle?.append(newMission)
        }
        
        
        groups[0].missionTitle = [missions[0], missions[1], missions[2]]
        groups[1].missionTitle = [missions[3], missions[4], missions[5]]
        groups[2].missionTitle = [missions[6], missions[7], missions[8]]
        groups[3].missionTitle = [missions[9], missions[10], missions[11]]
        groups[4].missionTitle = [missions[12], missions[13], missions[14]]
        groups[5].missionTitle = [missions[15], missions[16], missions[17]]
        groups[6].missionTitle = [missions[18], missions[19], missions[20]]
        groups[7].missionTitle = [missions[21], missions[22], missions[23]]
        
        
        try? container.mainContext.save()
        
    }
}
