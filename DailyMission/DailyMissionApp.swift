//
//  DailyMissionApp.swift
//  DailyMission
//
//  Created by 이민서 on 2/4/25.
//

import SwiftUI
import SwiftData

@main
struct DailyMissionApp: App {
    var sharedModelContainer: ModelContainer = {
        do {
            return try ModelContainer(
                for: Mission.self, Group.self
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            IntroView()
        }
        .modelContainer(PreviewContainer.shared.container)
    }
}
