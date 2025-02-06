//
//  CalenderView.swift
//  DailyMission
//
//  Created by 최하진 on 2/4/25.
//

import SwiftUI
import SwiftData



struct CalendarView: View {
    @Environment(\.modelContext) private var modelContext
    var group : Group
    
    @Query private var missions: [Mission]
    var filteredMissions: [Mission] {
        missions.filter { $0.group?.id == group.id }
    }
    var groupColor : Color
    var user : User
    @State var clickedDate: Date? = Date()
    
    let missionIcons = [
        "star", "heart", "flame", "bolt", "leaf",
        "pencil", "book", "clock", "figure.walk", "bicycle",
        "gamecontroller", "paintbrush", "camera", "music.note", "flag"
    ]
    var body: some View {
        VStack{
            CalenderBodyView(group: group, groupColor: groupColor, groupMission: filteredMissions, clickedDate: $clickedDate, user: user)
            List {
                Section(content: {
                    ForEach(filteredMissions.sorted(by: { first, second in
                        let firstCompleted = isMissionCompleted(for: first)
                        let secondCompleted = isMissionCompleted(for: second)
                        return firstCompleted == secondCompleted ? first.title < second.title : !firstCompleted
                    })) { mission in
                        if let clickedDate = clickedDate,
                           let userStamp = mission.userStamp?.first(where: { $0.userId == user.id }),
                           let index = userStamp.dateStamp.firstIndex(where: { $0.date.isSameDate(date: clickedDate) }) {
                            
                            HStack {
                                let missionIcon = missionIcons.contains(mission.icon ?? "") ? mission.icon : "doc"
                                
                                Image(systemName: missionIcon!)
                                    .foregroundColor(groupColor)
                                    .frame(minWidth: 30)
                                
                                Text("\(mission.title)")
                                Spacer()
                                
                                Image(systemName: (userStamp.dateStamp[index].isCompleted) ? "checkmark.square.fill" : "square")
                                    .foregroundColor(groupColor)
                                    .onTapGesture {
                                        userStamp.dateStamp[index].isCompleted.toggle()
                                        try? modelContext.save()
                                    }
                            }
                            .padding(.vertical, 5)
                        }
                    }
                }, header: {
                    Text("미션")
                })
            }
            .scrollContentBackground(.hidden)
            
        }
    }
    private func isMissionCompleted(for mission: Mission) -> Bool {
        guard let userStamp = mission.userStamp?.first(where: { $0.userId == user.id }) else {
            return false
        }
        return userStamp.dateStamp.contains(where: { $0.isCompleted })
    }
}

//#Preview {
//    CalenderView(group: Group(name: "ya", missionTitle: ["1","2"], memberCount: 2, category: "study"), month: Date())
//}
