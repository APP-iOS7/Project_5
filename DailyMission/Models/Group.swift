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
    var category: String // 카테고리 (운동, 공부 등)
    
    var color: String?
    var dueDate: Date?
    var createdAt: Date  = Date()
    @Relationship(deleteRule: .cascade, inverse: \UserGroup.group)
        var groupUsers: [UserGroup] = []
    
    var members: [User]? {
            return groupUsers.map { $0.user }
        }
    
    init(name: String, missionTitle: [Mission]?, category: String,  color: String?, dueDate: Date?, createdAt: Date) {
        self.name = name
        self.missionTitle = missionTitle
        self.category = category
        
        self.color = color
        self.dueDate = dueDate
        self.createdAt = createdAt
    }
}
