////
////  Item.swift
////  DailyMission
////
////  Created by 이민서 on 2/4/25.
////
//
import Foundation
import SwiftData

@Model
final class Group {
    var name: String
    var missionTitle: [String]
    var memberCount: Int
    var category: String // 카테고리 (운동, 공부 등)
    var members: [String]? //그룹원들의 이름 리스트
    var color: String?
    var dueDate: Date?
    var createdAt: Date
    
    init(name: String, missionTitle: [String], memberCount: Int, category: String, members: [String], color: String?, dueDate: Date?, _ createdAt: Date = Date()) {
        self.name = name
        self.missionTitle = missionTitle
        self.memberCount = memberCount
        self.category = category
        self.members = members
        self.color = color
        self.dueDate = dueDate
        self.createdAt = createdAt
    }
}
