//
//  ContentView.swift
//  DailyMission
//
//  Created by 이민서 on 2/4/25.
//
//민서님 작성
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var users: [User]
    //@Query private var userGroups: [UserGroup]
    @AppStorage("loginMember") var loggedInUser: String?
    var user: User? {
        users.first(where: { $0.id == loggedInUser })
    }
    @Query private var userGroups: [UserGroup]
    var usergroups: [Group] {
        guard let user = users.first(where: { $0.id == loggedInUser }) else {
            return []
        }
        return user.userGroups.map { $0.group }
    }
    
    @State private var showAddGroup: Bool = false
    @State private var isEditMode: EditMode = .inactive
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    
                    if isEditMode == .active {
                        EditModeView( user: user ?? User(id: "default", password: "1234"))
                    } else {
                        MainView( user: user ?? User(id: "default", password: "1234"))
                    }
                    Spacer()
                    
                }
                .padding()
                .navigationBarBackButtonHidden(true)
                .navigationTitle("My Groups")
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        HStack {
                            
                            
                            Button(action: {
                                showAddGroup = true
                            }) {
                                Text("그룹 추가")
                                    .foregroundColor(.black)
                                    .font(.headline)
                            }
                            Spacer()
                            Button(action: {
                                loggedInUser = nil
                                dismiss()
                            }) {
                                Label("로그아웃", systemImage: "rectangle.portrait.and.arrow.right")
                                    .foregroundColor(.black)
                                    .font(.headline)
                            }
                        }
                        
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        if let user = user {
                            Text("\(user.id) 님 환영합니다.")
                        } else {
                            Text("환영합니다.")
                        }
                        
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            withAnimation {
                                isEditMode = isEditMode == .active ? .inactive : .active
                            }
                        }) {
                            Text(isEditMode == .active ? "완료" : "편집")
                                .foregroundColor(.black)
                                .font(.headline)
                        }
                        
                    }
                }
            }
            
        }
        .sheet(isPresented: $showAddGroup) {
            GroupAddView()
        }
    }
    
}

//#Preview {
//    ContentView()
//        .modelContainer(for: Group.self, inMemory: true)
//}
