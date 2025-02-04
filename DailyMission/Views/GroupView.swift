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
    @Query private var missions: [Mission]
    
    @State private var isNavigated: Bool = false
    
    @State private var newMissionTitle: String = ""
    @State private var showAddMissionAlert: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                Text("GroupView")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 20)
            }
            .padding()
        }
    }

    
}

//#Preview {
//    ContentView()
//        .modelContainer(for: Mission.self, inMemory: true)
//}
