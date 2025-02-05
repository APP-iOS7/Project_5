//
//  ContentView.swift
//  DailyMission
//
//  Created by 이민서 on 2/4/25.
//
//준호님 작성
import SwiftUI
import SwiftData

struct LoginView: View {
    
    let members = ["minseo" : "1234", "hajin" : "1234", "junho" : "1234"]
    @AppStorage("loginMember") var member: String?
    
    @Environment(\.modelContext) private var modelContext
    @Query private var missions: [Mission]
    
    @State private var userId: String = ""
    @State private var password: String = ""
    @State private var loggedInUser: User?
    @State private var newMissionTitle: String = ""
    @State private var isLoggedIn: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("로그인")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 20)
                
                TextField("아이디 입력", text: $userId)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("비밀번호 입력", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button(action: {
                    login()
                }) {
                    Text("로그인")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                NavigationLink(destination: ContentView(), isActive: $isLoggedIn) {
                    EmptyView()
                }
                
            }
            .padding()
        }
    }
    private func login() {
        if let storedPassword = members[userId], storedPassword == password {
            loggedInUser = User(id: userId, password: storedPassword)
            member = userId
            isLoggedIn = true
            userId = ""
            password = ""
        } else {
            print("로그인 실패: 아이디 또는 비밀번호가 일치하지 않습니다.")
        }
    }

}


//#Preview {
//    ContentView()
//        .modelContainer(for: Mission.self, inMemory: true)
//}
