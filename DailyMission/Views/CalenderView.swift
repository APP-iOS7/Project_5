//
//  CalenderView.swift
//  DailyMission
//
//  Created by 최하진 on 2/4/25.
//

import SwiftUI
import SwiftData



struct CalenderView: View {
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
                ForEach(filteredMissions) { mission in
                        HStack{
                            Text("\(mission.title)")
                            Spacer()
                            Image(systemName: mission.isCompleted ? "checkmark.square.fill" : "square")
                                .onTapGesture {
                                    mission.isCompleted.toggle()
                                }
                        
                    }
                }
            }
            .scrollContentBackground(.hidden)
            
        }
    }
}



//#Preview {
//    CalenderView(group: Group(name: "ya", missionTitle: ["1","2"], memberCount: 2, category: "study"), month: Date())
//}
