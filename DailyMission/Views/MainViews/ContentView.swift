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
    @AppStorage("loginMember") var loggedInUser: String?
    var userGroups: [Group] {
        if let user = users.first(where: { $0.id == loggedInUser }) {
            return user.groups
        }
        return []
    }
    
    @State private var showAddGroup: Bool = false
    @State private var isEditMode: EditMode = .inactive
    
    var body: some View {
        NavigationStack {
            VStack {
                
                if isEditMode == .active {
                    EditModeView()
                } else {
                    MainView()
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
                    if let user = loggedInUser {
                        Text("\(user) 님 환영합니다.")
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
        .sheet(isPresented: $showAddGroup) {
            GroupAddView()
        }
    }
    
}

//#Preview {
//    ContentView()
//        .modelContainer(for: Group.self, inMemory: true)
//}
