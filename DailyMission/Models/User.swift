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
    var groups: [Group]
    
    init(id: String, password: String, groups: [Group] = []) {
        self.id = id
        self.password = password
        self.groups = groups
    }
}
