//
//  DateStamp.swift
//  DailyMission
//
//  Created by 이민서 on 2/5/25.
//

import Foundation
import SwiftData

@Model
final class DateStamp { // ✅ 날짜별 완료 여부를 저장하는 개별 모델
    var date: Date
    var isCompleted: Bool
    
    init(date: Date, isCompleted: Bool = false) {
        self.date = date
        self.isCompleted = isCompleted
    }
}

