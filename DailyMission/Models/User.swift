//
//  Item.swift
//  DailyMission
//
//  Created by 이민서 on 2/4/25.
//

import Foundation
import SwiftData

@Model
final class User {
    var id: String
    var password: String
    @Relationship(deleteRule: .cascade, inverse: \UserGroup.user)
    var userGroups: [UserGroup] = []
    
    var groups: [Group]? {
            return userGroups.map { $0.group }
        }
    
    init(id: String, password: String) {
        self.id = id
        self.password = password
    }
}
