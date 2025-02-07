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
    var createdAt: Date  = Date() // mission 생성 날짜
    var userStamp: [UserStamp]? = [] // 날짜 : 날짜별 완료 여부를 표시
    var group: Group?
        
    
    init(
        title: String,
        userStamp: [UserStamp],
        endDate: Date? = nil,
        icon: String? = nil,
        _ createdAt: Date = Date(),
        group: Group? = nil
    ) {
        self.title = title
        self.createdAt = createdAt
        self.userStamp = userStamp
        self.endDate = endDate
                self.icon = icon
        self.group = group
        
    }
}
