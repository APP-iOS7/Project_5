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
    @Relationship(deleteRule: .nullify)
    var user: User
    
    @Relationship(deleteRule: .nullify)
    var group: Group

    init(user: User, group: Group) {
        self.user = user
        self.group = group
    }
}

