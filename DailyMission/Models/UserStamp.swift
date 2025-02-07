//
//  UserStamp.swift
//  DailyMission
//
//  Created by 최하진 on 2/6/25.
//

import Foundation
import SwiftData

@Model
final class UserStamp {
    var userId : String
    @Relationship(deleteRule: .cascade) var dateStamp: [DateStamp] = []
    
    init(userId : String, dateStamp : [DateStamp] = []) {
        self.userId = userId
        self.dateStamp = dateStamp
    }
}

