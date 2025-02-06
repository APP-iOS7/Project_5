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
    @State private var filteredMissionsState: [Mission] = []
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
            CalenderBodyView(group: group, groupColor: groupColor, groupMission: filteredMissionsState, clickedDate: $clickedDate, user: user)
            List {
                Section(header: Text("미션")) {
                    ForEach(filteredMissionsState.sorted(by: { first, second in
                        let firstCompleted = isMissionCompleted(for: first)
                        let secondCompleted = isMissionCompleted(for: second)
                        return firstCompleted == secondCompleted ? first.title < second.title : !firstCompleted
                    })) { mission in
                        
                        HStack {
                            let missionIcon = missionIcons.contains(mission.icon ?? "") ? mission.icon : "doc"
                            
                            Image(systemName: missionIcon!)
                                .foregroundColor(groupColor)
                                .frame(minWidth: 30)
                            
                            Text("\(mission.title)")
                            Spacer()
                            
                            if let clickedDate = clickedDate,
                               let userStamp = mission.userStamp?.first(where: { $0.userId == user.id }),
                               let index = userStamp.dateStamp.firstIndex(where: { $0.date.isSameDate(date: clickedDate) }) {
                                
                                Image(systemName: (userStamp.dateStamp[index].isCompleted) ? "checkmark.square.fill" : "square")
                                    .foregroundColor(groupColor)
                                    .onTapGesture {
                                        toggleMissionCompletion(userStamp: userStamp, index: index)
                                    }
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            
        }
        .onAppear {
            updateFilteredMissions()
        }
    }
    private func updateFilteredMissions() {
        DispatchQueue.main.async {
            self.filteredMissionsState = self.missions.filter { $0.group?.id == self.group.id }
            
            if let clickedDate = self.clickedDate {
                for mission in self.filteredMissionsState {
                    if let userStamp = mission.userStamp?.first(where: { $0.userId == self.user.id }) {
                        if !userStamp.dateStamp.contains(where: { $0.date.isSameDate(date: clickedDate) }) {
                            print("Adding missing dateStamp for clickedDate: \(clickedDate)")
                            userStamp.dateStamp.append(DateStamp(date: clickedDate, isCompleted: false))
                            try? self.modelContext.save()
                        }
                    }
                }
            }
            
            print("Updated filteredMissionsState count: \(self.filteredMissionsState.count)")
        }
    }

    private func isMissionCompleted(for mission: Mission) -> Bool {
        guard let userStamp = mission.userStamp?.first(where: { $0.userId == user.id }) else {
            return false
        }
        return userStamp.dateStamp.contains(where: { $0.isCompleted })
    }
    private func toggleMissionCompletion(userStamp: UserStamp, index: Int) {
        userStamp.dateStamp[index].isCompleted.toggle()
        do {
            try modelContext.save()
            print("Mission completion toggled")
            
            DispatchQueue.main.async {
                self.updateFilteredMissions()
            }
        } catch {
            print("Failed to save mission completion: \(error.localizedDescription)")
        }
    }
}

//#Preview {
//    CalenderView(group: Group(name: "ya", missionTitle: ["1","2"], memberCount: 2, category: "study"), month: Date())
//}
