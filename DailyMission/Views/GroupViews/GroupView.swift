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
    var user : User
    @Query private var missions: [Mission]
    var filteredMissions: [Mission] {
        missions.filter { $0.group?.id == group.id }
    }
    
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
        let groupColor : Color = colorMap[group.color!] ?? .blue
        NavigationStack {
            VStack {
                TabView(selection: $selection) {
                    CalendarView(group: group, groupColor: groupColor, user: user)
                        .tabItem {
                            Image(systemName: "calendar")
                            //                            Text("calendar")
                        } .tag(1)
                    ChartView(group: group, groupColor: groupColor, user: user)
                        .tabItem {
                            Image(systemName: "chart.xyaxis.line")
                            //                            Text("chart")
                        } .tag(2)
                }
                .accentColor(groupColor)
            }
            .navigationTitle(group.name)
            .onAppear {
                MakeDailyTimeStamp(missions: filteredMissions)
            }
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
    //미션->유저스탬프->dateStamp 에서 뉴 dateStamp 추가
    private func MakeDailyTimeStamp(missions: [Mission]) {
        var dateStamp : [DateStamp]
        for mission in missions {
            if let index = mission.userStamp?.firstIndex(where: {$0.userId == user.id}) {
                dateStamp = mission.userStamp?[index].dateStamp ?? []
                if (((dateStamp.firstIndex(where: { $0.date.isSameDate(date: Date.now) })) != nil)) {
                    mission.userStamp?[index].dateStamp.append(DateStamp(date: Date.now, isCompleted: false))
                }
            }
            
        }
    }
}

//#Preview {
//    GroupView(group: Group(name: "aaa", memberCount: 3, category: "qq", members: ["q","b","c"], color: "ww", dueDate: Date()))
//        .modelContainer(for: Mission.self, inMemory: true)
//}

