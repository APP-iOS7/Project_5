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
    
    @State private var isNavigated: Bool = false
    
    @State private var newMissionTitle: String = ""
    @State private var showAddMissionAlert: Bool = false
    @State private var selection = 1
    @State private var isShowingNewMission : Bool = false
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
                .accentColor(.green)
            }
            .navigationTitle(group.name)
            .toolbar {
                Button(action: {
                    isShowingNewMission.toggle()
                }) {
                    Image(systemName: "plus")
                }
                .sheet(isPresented: $isShowingNewMission, onDismiss: didDismiss) {
                    AddNewMissionView(group: group)
                }
            }
            
            .padding()
        }
        
    }
    
    func didDismiss() {
        dismiss()
        }
}

//#Preview {
//    GroupView(group: Group(name: "aaa", memberCount: 3, category: "qq", members: ["q","b","c"], color: "ww", dueDate: Date()))
//        .modelContainer(for: Mission.self, inMemory: true)
//}
//
