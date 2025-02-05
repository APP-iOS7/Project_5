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
            print("로그인한 사용자를 찾을 수 없습니다. 빈 그룹 반환.")
            return []
        }
        print("로그인한 사용자: \(user.id), 속한 그룹 개수: \(user.groups.count)")
        return user.groups
    }
    
    var group : Group
    @Query private var missions: [Mission]
    
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
                Text("Other Group \(group.name)")
                
            }
        }
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

//#Preview {
//    ContentView()
//        .modelContainer(for: Group.self, inMemory: true)
//}
