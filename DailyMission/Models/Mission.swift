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
//    var isCompleted: Bool
//    var createdAt: Date
    
    init(title: String/*, isCompleted: Bool, createdAt: Date*/) {
        self.title = title
//        self.isCompleted = isCompleted
//        self.createdAt = createdAt
    }
}
