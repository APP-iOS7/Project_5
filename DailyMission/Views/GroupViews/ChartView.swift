//
//  ChartView.swift
//  DailyMission
//
//  Created by 최하진 on 2/5/25.
//
import SwiftUI
import SwiftData

struct ChartView: View {
    
    @Environment(\.modelContext) private var modelContext
    var group : Group
    var groupColor : Color
    @Query private var missions: [Mission]
    var filteredMissions: [Mission] {
        missions.filter { $0.group?.id == group.id }
    }
    
    @State var clickedDate: Date = Date()
//    var completedMissionRatio: Double {
//        var completedCount : Double = 0.0
//        var dateMissionCount : Double = 0.0
//        for mission in missions {
//            if let index = mission.dateStamp?.firstIndex(where: { $0.date.isSameDate(date: clickedDate) }) {
//                dateMissionCount += 1
//                if mission.dateStamp![index].isCompleted == true { completedCount += 1 }
//            }
//        }
//        return completedCount / dateMissionCount
//    }

//    @AppStorage("loginMember") var member1: String = "minseo"
//    @AppStorage("loginMember") var member2: String = "hajin"
//    @AppStorage("loginMember") var member3: String = "junho"
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack {
            Text(clickedDate.formatted(
                Date.FormatStyle()
                    .year()
                    .month()
                    .day()
            ))
            
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(group.members!) { member in
                    var completedRatio = completedRatio(member, memberMission(member, group), clickedDate)
                    listButton(title: member.id, color: groupColor, ratio: completedRatio)
                }
            }
            Spacer()
        }
        
    }
    private func listButton(title: String, color: Color, ratio: Double) -> some View {
        HStack(alignment: .top) {
            
            Text(title)
                .foregroundColor(.black)
                .font(.headline)
                .fontWeight(.bold)
            Text("\(ratio)")
                .foregroundColor(.black)
                .font(.body)
            Spacer()
            ZStack {
                Circle()
                    .trim(from: 0, to: 1)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 20)
                
                Circle()
                    .trim(from: 0, to: CGFloat(ratio))
                    .stroke(color, lineWidth: 20)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.0), value: ratio)
                
            }
            .padding()
            .frame(width: 70, height: 70)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 80)
        .background(color.opacity(0.3))
        .cornerRadius(12)
    }
    
    private func completedRatio (_ user: User, _ missions: [Mission], _ date: Date) -> Double {
        var completedCount : Double = 0.0
        var dateMissionCount : Double = 0.0
        var dateStamp : [DateStamp]
        for mission in missions {
            if let index = mission.userStamp?.firstIndex(where: {$0.userId == user.id}){
                dateStamp = mission.userStamp?[index].dateStamp ?? []
                if let index2 = dateStamp.firstIndex(where: { $0.date.isSameDate(date: date)}) {
                    dateMissionCount += 1
                    if dateStamp[index2].isCompleted { completedCount += 1 }
                }
            }
        }
        let completedRatio = completedCount / dateMissionCount
        return completedRatio
    }
    
    private func memberMission (_ user: User, _ group: Group) -> [Mission] {
        if let index = user.groups.firstIndex(where: { $0.id == group.id }) {
            return user.groups[index].missionTitle!
        } else { return [] }
    }
}

//#Preview {
//    ChartView()
//}

