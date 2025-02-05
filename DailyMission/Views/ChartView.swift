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
    @Query private var missions: [Mission]
    var filteredMissions: [Mission] {
        missions.filter { $0.group?.id == group.id }
    }
    var completedMissionRatio: Double {
            let totalMissions = filteredMissions.count
            let completedMissions = filteredMissions.filter { $0.isCompleted }.count
            return totalMissions > 0 ? Double(completedMissions) / Double(totalMissions) : 0
        }
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    let colors: [String] = ["red", "orange", "yellow", "green", "blue", "purple", "brown"]
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
        VStack {
            
            LazyVGrid(columns: columns, spacing: 15) {
                
                listButton(title: "양준호", color: group.color ?? "blue", ratio: completedMissionRatio)
                listButton(title: "최하진", color: group.color ?? "blue", ratio: completedMissionRatio)
                listButton(title: "이민서", color: group.color ?? "blue", ratio: completedMissionRatio)
            }
            Spacer()
        }
        
    }
    private func listButton(title: String, color: String, ratio: Double) -> some View {
        VStack(alignment: .leading) {
            
            Text(title)
                .foregroundColor(.black)
                .font(.headline)
                .fontWeight(.bold)
            Text("완료된 미션 비율: \(ratio * 100, specifier: "%.1f")%")
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 80)
        .background((colorMap[color] ?? .blue).opacity(0.3))
        .cornerRadius(12)
    }
}

//#Preview {
//    ChartView()
//}
