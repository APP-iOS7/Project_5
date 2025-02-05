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
    @Environment(\.dismiss) private var dismiss
    
    var group : Group
    @Query private var missions: [Mission]
    
    
    @State private var selection = 1
    @State private var newMissionTitle: String = ""
    @State private var isNavigated: Bool = false
    @State private var showAddMissionAlert: Bool = false
    @State private var isShowingNewMission : Bool = false
    
    let colorMap: [String: Color] = [
        "red": .red,
        "orange": .orange,
        "yellow": .yellow,
        "green": .green,
        "blue": .blue,
        "purple": .purple,
        "brown": .brown
    ]
    var body: some View {
        NavigationStack {
            VStack {
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
                .accentColor(colorMap[group.color!].opacity(0.2) as? Color)
            }
            
            .navigationTitle(group.name)
            .toolbar {
                Button(action: {
                    isShowingNewMission.toggle()
                }) {
                    Image(systemName: "plus")
                }
                .sheet(isPresented: $isShowingNewMission) {
                    AddNewMissionView(group: group)
                }
            }
            
            
            .padding()
        }
        
    }
}

//#Preview {
//    GroupView(group: Group(name: "aaa", memberCount: 3, category: "qq", members: ["q","b","c"], color: "ww", dueDate: Date()))
//        .modelContainer(for: Mission.self, inMemory: true)
//}

