//
//  DateStamp.swift
//  DailyMission
//
//  Created by 이민서 on 2/5/25.
//

import Foundation
import SwiftData

@Model
final class DateStamp {
    var date: Date
    var isCompleted: Bool
    
    init(date: Date, isCompleted: Bool = false) {
        self.date = date
        self.isCompleted = isCompleted
    }
}

