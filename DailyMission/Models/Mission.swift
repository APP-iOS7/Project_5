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
    
    init(title: String,_ isCompleted: Bool = false,_ createdAt: Date = Date()) {
        self.title = title
        self.isCompleted = isCompleted
        self.createdAt = createdAt
    }
}

