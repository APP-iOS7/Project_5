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
    let columns = [GridItem(.flexible())]
    
    var body: some View {
        VStack (alignment: .leading){
            ScrollView {
                CalenderBodyView(group: group, groupColor: groupColor, groupMission: filteredMissionsState, clickedDate: $clickedDate, user: user)
                LazyVGrid(columns: columns, spacing: 15) {
                    Section() {//달력 밑에 클릭된 날짜의 미션 리스트 가져오기
                            ForEach(filteredMissionsState.sorted(by: { first, second in
                                let firstCompleted = isMissionCompleted(for: first)
                                let secondCompleted = isMissionCompleted(for: second)
                                return firstCompleted == secondCompleted ? first.title < second.title : !firstCompleted
                            })) { mission in
                                if let clickedDate = clickedDate,
                                   let userStamp = mission.userStamp?.first(where: { $0.userId == user.id }),//해당 미션-> 유저스탬프에 현재 유저의 스탬프가 존재할 때
                                   let index = userStamp.dateStamp.firstIndex(where: { $0.date.isSameDate(date: clickedDate) }) { //현재 클릭한 날과 같은 날의 데이트스탬프의 인덱스가 있다면 가져오기
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
                                                toggleMissionCompletion(userStamp: userStamp, index: index)
                                            }
                                    }
                                .padding()
                                .background(userStamp.dateStamp[index].isCompleted ? groupColor.opacity(0.3) : Color.white)
                                .cornerRadius(10)
                                }
                                
                            }
                            
                    }
                }
                .scrollContentBackground(.hidden)
                Spacer()
            }
            //달력
            
        }
        .onAppear {
            updateFilteredMissions()
        }
    }
    private func updateFilteredMissions() {
        DispatchQueue.main.async {
            self.filteredMissionsState = self.missions.filter { $0.group?.id == self.group.id }
            
            if let clickedDate = self.clickedDate {//선택된 날짜가 있을때
                for mission in self.filteredMissionsState { //그룹 미션들 중에서
                    if let userStamp = mission.userStamp?.first(where: { $0.userId == self.user.id }) { //현재 유저의 유저스탬프가 미션에 존재하면
                        if !userStamp.dateStamp.contains(where: { $0.date.isSameDate(date: Date.now) }) && //오늘 날짜의 데이트스탬프가 없고
                            ( ( compareDate(mission.endDate!, Date.now) >= 0  && mission.endDate != nil) || //날짜가 마감일 전일때
                             ( compareDate(group.dueDate!, Date.now) >= 0  && mission.endDate == nil) )
                        {
                            print("Adding missing dateStamp for clickedDate: \(clickedDate)")
                            userStamp.dateStamp.append(DateStamp(date: Date.now, isCompleted: false)) // 유저 데이트스탬프 생성
                            try? self.modelContext.save()
                        }
                    }
                }
            }
            
            print("Updated filteredMissionsState count: \(self.filteredMissionsState.count)")
        }
    }

    private func compareDate(_ today : Date, _ endDate : Date) -> Int {
        return Calendar.current.getDateGap(from: endDate, to: today)
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
