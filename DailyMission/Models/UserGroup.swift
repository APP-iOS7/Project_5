//
//  UserGroup.swift
//  DailyMission
//
//  Created by 이민서 on 2/6/25.
//

import Foundation
import SwiftData

@Model
final class UserGroup {
    @Relationship(deleteRule: .cascade)
    var user: User
    
    @Relationship(deleteRule: .cascade)
    var group: Group

    init(user: User, group: Group) {
        self.user = user
        self.group = group
    }
}

