//
//  ContentView.swift
//  DailyMission
//
//  Created by 이민서 on 2/4/25.
//
//하진님 작성
import SwiftUI
import SwiftData

struct GroupView: View {
    @Environment(\.modelContext) private var modelContext
    var group : Group
    @Query private var missions: [Mission]
    
    @State private var isNavigated: Bool = false
    
    @State private var newMissionTitle: String = ""
    @State private var showAddMissionAlert: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                Text("\(group.name)")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 20)
                TabView {
                    Tab("calendar", systemImage: "calendar") {
                        CalendarView(group: group, month: Date())
                        }
                    Tab("calendar", systemImage: "chart.xyaxis.line") {
                        //CalendarView(group: group)
                        }
                }
            }
            .padding()
        }
    }

    
}

#Preview {
    GroupView(group: Group(name: "sya", missionTitle: ["1","2"], memberCount: 2, category: "study"))
        .modelContainer(for: Mission.self, inMemory: true)
}
