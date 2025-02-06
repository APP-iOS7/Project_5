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
    @State var clickedDate: Date? = Date()
    
    let missionIcons = [
        "star", "heart", "flame", "bolt", "leaf",
        "pencil", "book", "clock", "figure.walk", "bicycle",
        "gamecontroller", "paintbrush", "camera", "music.note", "flag"
    ]
    var body: some View {
        VStack{
            CalenderBodyView(group: group, groupColor: groupColor, groupMission: filteredMissions, clickedDate: $clickedDate)
            List {
                Section(content: {
                    ForEach(filteredMissions.sorted(by: {
                        let firstCompleted = $0.dateStamp?.contains(where: { $0.isCompleted }) ?? false
                        let secondCompleted = $1.dateStamp?.contains(where: { $0.isCompleted }) ?? false
                        return firstCompleted == secondCompleted ? $0.title < $1.title : !firstCompleted
                    })) { mission in
                        if let clickedDate = clickedDate, let index = mission.dateStamp?.firstIndex(where: { $0.date.isSameDate(date: clickedDate) }) {
                            HStack {
                                let missionIcon = missionIcons.contains(mission.icon ?? "") ? mission.icon : "doc"
                                
                                Image(systemName: missionIcon!)
                                    .foregroundColor(groupColor)
                                    .frame(minWidth: 30)
                                
                                Text("\(mission.title)")
                                Spacer()
                                
                                Image(systemName: (mission.dateStamp![index].isCompleted) ? "checkmark.square.fill" : "square")
                                    .foregroundColor(groupColor)
                                    .onTapGesture {
                                        mission.dateStamp?[index].isCompleted.toggle()
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
}

//#Preview {
//    CalenderView(group: Group(name: "ya", missionTitle: ["1","2"], memberCount: 2, category: "study"), month: Date())
//}
