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
    
    @State var clickedDate: Date? = Date()
    
    var body: some View {
            VStack{
                CalenderBodyView(group: group, month: Date(), clickedDate: $clickedDate)
                List {
                    Section(content: {
                        ForEach(filteredMissions) { mission in
                            if let clickedDate = clickedDate, let index = mission.dateStamp?.firstIndex(where: { $0.date.isSameDate(date: clickedDate) }) {
                                HStack{
                                    Text("\(mission.title)")
                                    Spacer()
                                    Image(systemName: (mission.dateStamp![index].isCompleted) ? "checkmark.square.fill" : "square")
                                        .onTapGesture {
                                            mission.dateStamp?[index].isCompleted.toggle()
                                        }
                                }
                            }
                        }
                    }, header: {
                        Text("미션")
                    })
                }
                .scrollContentBackground(.hidden)
                .padding()
            }
    }
}

//#Preview {
//    CalenderView(group: Group(name: "ya", missionTitle: ["1","2"], memberCount: 2, category: "study"), month: Date())
//}
