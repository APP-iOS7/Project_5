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
    @State private var selection = 1
    @State private var isShowingNewMission : Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                Text("\(group.name)")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 20)
                TabView(selection: $selection) {
                    
                    CalenderView(group: group)
                        .tabItem {
                            Image(systemName: "calendar")
                            //                            Text("calendar")
                        } .tag(1)
                    ChartView(group: group)
                        .tabItem {
                            Image(systemName: "chart.xyaxis.line")
                            //                            Text("chart")
                        } .tag(2)
                }
                .accentColor(.green)
            }
            .toolbar {
                Button(action: {
                    isShowingNewMission.toggle()
                }) {
                    Image(systemName: "plus")
                }
//                .sheet(isPresented: $isShowingNewMission, onDismiss: didDismiss)
            }
            
            .padding()
        }
        
    }
}

#Preview {
    GroupView(group: Group(name: "Ya", missionTitle: ["AA","BB"], memberCount: 3, category: "study", members: ["jin","min","jun"], color: "Black"))
        .modelContainer(for: Mission.self, inMemory: true)
}

