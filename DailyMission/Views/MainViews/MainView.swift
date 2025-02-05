//
//  ContentView.swift
//  DailyMission
//
//  Created by 이민서 on 2/4/25.
//
//민서님 작성
import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [User]
    @AppStorage("loginMember") var loggedInUser: String?
    @Query private var allgroups: [Group]
    var usergroups: [Group] {
        guard let user = users.first(where: { $0.id == loggedInUser }) else {
            //print("로그인한 사용자를 찾을 수 없습니다. 빈 그룹 반환.")
            return []
        }
        //print("로그인한 사용자: \(user.id), 속한 그룹 개수: \(user.groups.count)")
        return user.groups
    }
    
    @State private var showAddGroup: Bool = false
    @State private var isEditMode: Bool = false
    @State private var showGroupInfo: Bool = false
    @State private var selectedGroup: Group?
    
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
    let iconSize: CGFloat = 30
    
    var body: some View {
        NavigationStack {
            VStack(alignment:.leading) {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(usergroups, id: \.self) { group in
                        userlistButton(group: group)
                        
                    }
                    .onDelete(perform: deleteGroup)
                }
                .padding(.bottom, 20)
                Text("더 많은 그룹 구경하기")
                    .font(.headline)
                    .fontWeight(.bold)
                LazyVGrid(columns: columns, spacing: 15) {
                    
                    ForEach(allgroups, id: \.self) { group in
                        
                        if !usergroups.contains(group) {
                            otherlistButton(group: group)
                        }
                    }
                    .onDelete(perform: deleteGroup)
                }
                
            }
        }
    }
    
    private func deleteGroup(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(usergroups[index])
        }
        
    }
    private func userlistButton(group: Group) -> some View {
        NavigationLink(destination: GroupView(group: group)) {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: iconSize))
                        .foregroundColor(colorMap[group.color ?? "blue"] ?? .blue)
                    
                    
                    Spacer()
                    
                    Text("\(group.memberCount)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                }
                Spacer()
                Text(group.name)
                    .font(.headline)
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                HStack {
                    Text(group.category)
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                    Spacer()
                    if let dueDate = group.dueDate {
                        Text(calculateDDay(from: dueDate)) // ✅ D-Day 형식으로 출력
                            .foregroundColor(colorMap[group.color ?? "blue"] ?? .blue)
                            .font(.system(size: 16))
                    }
                }
                
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 80)
            .background((colorMap[group.color ?? "blue"] ?? .blue).opacity(0.3))
            .cornerRadius(12)
            
        }
    }
    private func otherlistButton(group: Group) -> some View {
        Button(action: {
            selectedGroup = group
            showGroupInfo = true
        }) {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: iconSize))
                        .foregroundColor(colorMap[group.color ?? "blue"] ?? .blue)
                    
                    
                    Spacer()
                    
                    Text("\(group.memberCount)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                }
                Spacer()
                Text(group.name)
                    .font(.headline)
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                HStack {
                    Text(group.category)
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                    Spacer()
                    if let dueDate = group.dueDate {
                        Text(calculateDDay(from: dueDate))
                            .foregroundColor(colorMap[group.color ?? "blue"] ?? .blue)
                            .font(.system(size: 16))
                    }
                }
                
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 80)
            .background((colorMap[group.color ?? "blue"] ?? .blue).opacity(0.3))
            .cornerRadius(12)
            
        }
        .sheet(item: $selectedGroup) { group in
                OtherGroupView(group: group)
            }
    }
    func calculateDDay(from dueDate: Date) -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date()) // 오늘 날짜 (시간 제외)
        let targetDate = calendar.startOfDay(for: dueDate) // 목표 날짜 (시간 제외)
        
        let components = calendar.dateComponents([.day], from: today, to: targetDate)
        let daysRemaining = components.day ?? 0
        
        if daysRemaining > 0 {
            return "D-\(daysRemaining)" // 미래 날짜
        } else if daysRemaining == 0 {
            return "D-day" // 오늘
        } else {
            return "D+\(-daysRemaining)" // 지나간 날짜
        }
    }
    
}

//#Preview {
//    ContentView()
//        .modelContainer(for: Group.self, inMemory: true)
//}
