//
//  Schema.swift
//  DailyMission
//
//  Created by 이민서 on 2/4/25.
//

import Foundation
import SwiftData

enum Schema {
    static var models: [any PersistentModel.Type] {
        [Group.self, Mission.self]
    }
}
