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
    
    let members = ["minseo" : "1234", "hajin" : "1234", "junho" : "1234"]
    @AppStorage("loginMember") var member1: String = "minseo"
    @AppStorage("loginMember") var member2: String = "hajin"
    @AppStorage("loginMember") var member3: String = "junho"
    
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
                
                listButton(title: member1, color: group.color ?? "blue", ratio: completedMissionRatio)
                listButton(title: member2, color: group.color ?? "blue", ratio: completedMissionRatio)
                listButton(title: member3, color: group.color ?? "blue", ratio: completedMissionRatio)
            }
            Spacer()
        }
        
    }
    private func listButton(title: String, color: String, ratio: Double) -> some View {
        HStack(alignment: .top) {
            
            Text(title)
                .foregroundColor(.black)
                .font(.headline)
                .fontWeight(.bold)
            Spacer()
            ZStack {
                Circle()
                    .trim(from: 0, to: 1)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 20)
                
                Circle()
                    .trim(from: 0, to: CGFloat(ratio))
                    .stroke(colorMap[color] ?? .blue, lineWidth: 20)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.0), value: ratio)
                
            }
            .padding()
            .frame(width: 70, height: 70)
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
