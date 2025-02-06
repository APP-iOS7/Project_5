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
    
    @State var selectedDate: Date = Date()
    @State var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    @State private var memberRatios: [(id: String, ratio: Double)] = []
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack(alignment: .center) {
            DatePicker("날짜 선택", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.compact)
                .onChange(of: selectedDate) { _, newValue in
                    selectedMonth = Calendar.current.component(.month, from: newValue)
                    updateGraphData()
                }
            
            
            
            if let members = group.members, !members.isEmpty {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(members) { member in
                            let missionsForMember = memberMission(member, group)
                            let completedRatio = completedRatio(member, missionsForMember, selectedDate)
                            listButton(title: member.id, color: groupColor, ratio: completedRatio)
                        }
                    }
                }
                .background()
                
            } else {
                Text("멤버가 없습니다.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            
            if let members = group.members, !members.isEmpty {
                HStack {
                    //Text("\(selectedMonth)월")
                    HStack(alignment: .bottom, spacing: 20) {
                        let sortedMemberRatios = memberRatios.sorted { $0.ratio > $1.ratio }
                        ForEach(sortedMemberRatios.indices, id: \.self) { i in
                            VStack {
                                
                                Rectangle()
                                    .fill(groupColor)
                                    .frame(width: (UIScreen.main.bounds.width - 200) / CGFloat(sortedMemberRatios.count),
                                           height: CGFloat(sortedMemberRatios[i].ratio) * 2)
                                
                                Text(sortedMemberRatios[i].id)
                                    .font(.caption)
                                    .foregroundColor(.black)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width - 200)
                }
                
                
                
            } else {
                Text("멤버가 없습니다.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            
        }
        .onAppear {
            updateFilteredMissions()
            updateGraphData()
        }
        .padding(.bottom, 50)
    }
    private func updateGraphData() {
        if let members = group.members {
            let rawRatios = members.map { member in
                (id: member.id, ratio: totalMonthlyRatio(member: member, selectedMonth: selectedMonth) * 100)
            }
            
            let maxRatio = rawRatios.map { $0.ratio }.max() ?? 1
            
            memberRatios = rawRatios.map { member in
                let normalizedRatio = (maxRatio > 0) ? (member.ratio / maxRatio) * 100 : 0
                return (id: member.id, ratio: normalizedRatio)
            }
        }
    }
    private func totalMonthlyRatio(member: User, selectedMonth: Int) -> Double {
        let calendar = Calendar.current
        
        guard let range = calendar.range(of: .day, in: .month, for: selectedDate) else { return 0 }
        
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedDate))!
        var totalRatio: Double = 0.0
        
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                let missionsForMember = memberMission(member, group)
                let dailyRatio = completedRatio(member, missionsForMember, date)
                if !dailyRatio.isNaN {
                    totalRatio += dailyRatio
                }
            }
        }
        
        return totalRatio
    }
    
    
    private func listButton(title: String, color: Color, ratio: Double) -> some View {
        HStack(alignment: .top) {
            
            VStack(alignment: .leading) {
                Text(title)
                    .foregroundColor(.black)
                    .font(.headline)
                    .fontWeight(.bold)
                let percentage = ratio.isNaN ? 0 : Int(ratio * 100)
                Text(String(format: "%d%%", percentage))
                    .foregroundColor(.black)
                    .font(.body)
            }
            
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
        guard let groups = user.groups,
              let index = groups.firstIndex(where: { $0.id == group.id }),
              let missions = groups[index].missionTitle else {
            return []
        }
        return missions
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

