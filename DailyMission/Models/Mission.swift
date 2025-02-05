//
//  Item.swift
//  DailyMission
//
//  Created by 이민서 on 2/4/25.
//

import Foundation
import SwiftData

@Model
final class Mission {
    var title: String
    var isCompleted: Bool
    var createdAt: Date
    var group: Group?
    
    init(title: String,_ isCompleted: Bool = false,_ createdAt: Date = Date(), group: Group?) {
        self.title = title
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.group = group
    }
}
