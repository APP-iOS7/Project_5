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
    
    var selectedgroup : Group
    @Query private var missions: [Mission]
    var filteredMissions: [Mission] {
        missions.filter { $0.group?.id == selectedgroup.id }
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
    @State private var isJoined: Bool = false
    var body: some View {
        NavigationStack {
            Divider()
            VStack(alignment: .leading, spacing: 15) {
                VStack(alignment: .leading, spacing: 15) {
                    Text("\(selectedgroup.name)에서 하는 일!!")
                        .font(.title)
                        .fontWeight(.bold)
                    ForEach(filteredMissions) { mission in
                        VStack(alignment:.leading) {
                            HStack {
                                Image(systemName: "checkmark")
                                    .font(.body)
                                    .foregroundColor(colorMap[selectedgroup.color ?? "blue"] ?? .blue)
                                
                                
                                Text(" \(mission.title)")
                                    .font(.headline)
                            }
                        }
                    }
                }
                Rectangle()
                    .frame(height: 20)
                    .foregroundColor(Color.white)
                VStack(alignment: .leading, spacing: 15) {
                    Text("카테고리")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("\(selectedgroup.category)")
                }
                Rectangle()
                    .frame(height: 20)
                    .foregroundColor(Color.white)
                VStack(alignment: .leading, spacing: 15) {
                    Text("기간")
                        .font(.title)
                        .fontWeight(.bold)
                    if let dueDate = selectedgroup.dueDate {
                        Text(formattedDate(dueDate))
                            .font(.headline)
                    } else {
                        Text("마감 기한 없음")
                            .font(.headline)
                    }
                    
                }
                Spacer()
                Button(action: {
                    joinGroup()
                }) {
                    Text(isJoined ? "이미 참여한 그룹입니다" : "그룹 참여")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isJoined ? Color.gray : colorMap[selectedgroup.color ?? "blue"] ?? .blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(isJoined)
                
            }
            .padding()
            .onAppear {
                checkIfJoined()
            }
            .navigationTitle(selectedgroup.name)
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
    private func checkIfJoined() {
        if let user = users.first(where: { $0.id == loggedInUser }) {
            isJoined = user.groups.contains(where: { $0.id == selectedgroup.id })
        }
    }
    
    private func joinGroup() {
        if let user = users.first(where: { $0.id == loggedInUser }) {
            if !user.groups.contains(where: { $0.id == selectedgroup.id }) {
                user.groups.append(selectedgroup)
                if selectedgroup.members == nil {
                    selectedgroup.members = []
                }
                selectedgroup.members?.append(user)
                try? modelContext.save()
                isJoined = true
            }
        }
    }
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "~ yyyy년 M월 d일 E요일"
        return formatter.string(from: date)
    }
    
}

//#Preview {
//    ContentView()
//        .modelContainer(for: Group.self, inMemory: true)
//}
