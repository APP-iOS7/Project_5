//
//  ContentView.swift
//  DailyMission
//
//  Created by 이민서 on 2/4/25.
//
//민서님 작성
import SwiftUI
import SwiftData

struct EditModeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [User]
    @AppStorage("loginMember") var loggedInUser: String?
    var usergroups: [Group] {
        guard let user = users.first(where: { $0.id == loggedInUser }) else {
            print("로그인한 사용자를 찾을 수 없습니다. 빈 그룹 반환.")
            return []
        }
        print("로그인한 사용자: \(user.id), 속한 그룹 개수: \(user.groups.count)")
        return user.groups
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
    let minusSize: CGFloat = 23
    
    @State private var showDeleteAlert = false
    @State private var groupToDelete: Group?
    
    var body: some View {
        NavigationStack {
            VStack {
                if usergroups.isEmpty {
                    Text("가입한 그룹이 없습니다.")
                        .foregroundColor(.gray)
                        .font(.title3)
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(usergroups, id: \.self) { group in
                                editRow(group: group)
                                
                            }
                        }
                    }
                    
                }
            }
        }
        .alert("그룹을 나가시겠습니까?", isPresented: $showDeleteAlert) {
            Button("취소", role: .cancel) { }
            Button("나가기", role: .destructive) {
                if let group = groupToDelete {
                    deleteGroup(group)
                }
            }
        } message: {
            Text("이 작업은 되돌릴 수 없습니다.")
        }
        
    }
    private func deleteGroup(_ group: Group) {
        guard let user = users.first(where: { $0.id == loggedInUser }) else {
            print("로그인한 사용자를 찾을 수 없습니다.")
            return
        }
        print("🚀 그룹 나가기 요청: \(group.name)")

        if let memberIndex = group.members?.firstIndex(where: { $0.id == user.id }) {
            group.members?.remove(at: memberIndex)
            print("✅ \(user.id)가 \(group.name)에서 제거됨.")
        }

        if let groupIndex = user.groups.firstIndex(where: { $0.id == group.id }) {
            user.groups.remove(at: groupIndex)
            print("✅ \(group.name)이 \(user.id)의 그룹 목록에서 제거됨.")
        }

        try? modelContext.save()
    }

    
    private func editRow(group: Group) -> some View {
        print("editRow 실행: \(group.name)")
        return HStack {
            
            
            Image(systemName: "person.2.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: iconSize)
                .foregroundColor(colorMap[group.color ?? "blue"] ?? .blue)
                .padding()
            
            Text(group.name)
                .font(.system(size: 18))
                .foregroundColor(.black)
            
            Spacer()
            Button(action: {
                groupToDelete = group
                showDeleteAlert = true
                
            }) {
                Text("나가기")
                    .foregroundColor(.red)
                    .font(.system(size: 18))
            }
            .buttonStyle(PlainButtonStyle())
            .contentShape(Rectangle())
            
        }
        .listRowBackground(Color.white)
    }
}

//#Preview {
//    ContentView()
//        .modelContainer(for: Group.self, inMemory: true)
//}
