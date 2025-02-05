//
//  ContentView.swift
//  DailyMission
//
//  Created by 이민서 on 2/4/25.
//
//민서님 작성
import SwiftUI
import SwiftData

struct OtherGroupView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var users: [User]
    @AppStorage("loginMember") var loggedInUser: String?
    @Query private var allgroups: [Group]
    var usergroups: [Group] {
        guard let user = users.first(where: { $0.id == loggedInUser }) else {
            return []
        }
        return user.groups
    }
    
    var group : Group
    @Query private var missions: [Mission]
    var filteredMissions: [Mission] {
        missions.filter { $0.group?.id == group.id }
    }
    
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
    let iconSize: CGFloat = 30
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 15) {
                VStack(alignment: .leading, spacing: 15) {
                    Text("\(group.name)에서 하는 일!!")
                        .font(.title3)
                        .fontWeight(.bold)
                    ForEach(filteredMissions) { mission in
                        VStack(alignment:.leading) {
                            HStack {
                                Image(systemName: "checkmark")
                                    .font(.body)
                                    .foregroundColor(colorMap[group.color ?? "blue"] ?? .blue)

                                
                                Text(" \(mission.title)")
                                    .font(.body)
                            }
                        }
                    }
                }
                .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("카테고리")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("\(group.category)")
                }
                .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("기간")
                        .font(.title3)
                        .fontWeight(.bold)
                    if let dueDate = group.dueDate {
                        Text(formattedDate(dueDate))
                    } else {
                        Text("마감 기한 없음")
                    }

                }
                .cornerRadius(12)
                Spacer()
                
            }
            .navigationTitle(group.name)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                    .foregroundColor(.black)
                }
            }
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
//    ContentView()
//        .modelContainer(for: Group.self, inMemory: true)
//}
