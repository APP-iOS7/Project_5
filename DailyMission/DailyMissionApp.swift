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
        let schema = Schema([
            Mission.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            LoginView()
        }
        .modelContainer(sharedModelContainer)
    }
}
