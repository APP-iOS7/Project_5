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
    var user: User
    @Query private var missions: [Mission]
    @State private var filteredMissionsState: [Mission] = []
    
    @State var clickedDate: Date = Date()
    
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(formattedDate(clickedDate))
            
            if let members = group.members, !members.isEmpty {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(members) { member in
                        let missionsForMember = memberMission(member, group)
                        let completedRatio = completedRatio(member, missionsForMember, clickedDate)
                        listButton(title: member.id, color: groupColor, ratio: completedRatio)
                    }
                }
            } else {
                Text("멤버가 없습니다.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Spacer()
        }
        .onAppear {
            updateFilteredMissions()
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
    private func updateFilteredMissions() {
        DispatchQueue.main.async {
            self.filteredMissionsState = missions.filter { $0.group?.id == self.group.id }
        }
    }
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일 E요일"
        return formatter.string(from: date)
    }
}

//#Preview {
//    ChartView()
//}

