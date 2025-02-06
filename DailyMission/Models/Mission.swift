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
    var icon: String?
    var endDate: Date?
    var createdAt: Date // mission 생성 날짜
    var dateStamp: [DateStamp]? // 날짜 : 날짜별 완료 여부를 표시
    var group: Group?
    
    init(
        title: String,
        dateStamp: [DateStamp] = [],
        endDate: Date? = nil,
        icon: String? = nil,
        _ createdAt: Date = Date(),
        group: Group?
    ) {
        self.title = title
        self.createdAt = createdAt
        self.dateStamp = dateStamp
        self.endDate = endDate
                self.icon = icon
        self.group = group
    }
}
