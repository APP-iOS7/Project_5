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
    var missionTitle: [Mission]? = []
    var members: [User]? //그룹원들의 이름 리스트
    var memberCount: Int
    var category: String // 카테고리 (운동, 공부 등)
    
    var color: String?
    var dueDate: Date?
    var createdAt: Date  = Date()
    
    init(name: String, missionTitle: [Mission]?, members: [User], category: String,  color: String?, dueDate: Date?, createdAt: Date) {
        self.name = name
        self.missionTitle = missionTitle
        self.members = members
        self.memberCount = members.count
        self.category = category
        
        self.color = color
        self.dueDate = dueDate
        self.createdAt = createdAt
    }
}
