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
    
    init(title: String) {
        self.title = title
    }
}
