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
    var createdAt: Date // mission 생성 날짜
    var DateStamp: [Date : Bool] // 날짜 : 날짜별 완료 여부를 표시
    var group: Group?
    
    init(title: String,_ isCompleted: Bool = false, _ DateStamp: [Date : Bool] = [Date() : false],_ createdAt: Date = Date(), group: Group?) {
        self.title = title
        self.createdAt = createdAt
        self.DateStamp = DateStamp
        self.group = group
    }
}
