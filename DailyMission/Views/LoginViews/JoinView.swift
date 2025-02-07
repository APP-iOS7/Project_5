//
//  JoinView.swift
//  DailyMission
//
//  Created by 양준호 on 2/6/25.
//

import SwiftUI
import SwiftData

struct JoinView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [User]
    
    @AppStorage("loginMember") var member: String?
    
    @State private var userId: String = ""
    @State private var password: String = ""
    @State private var password_confirm: String = ""
    
    @State private var loggedInUser: User?
    
    @State private var isRegistered: Bool = false
    @State private var showAlert_wrong = false
    @State private var showAlert_blank = false
    @State private var showAlert_password_confirm_mismatch = false
    @State private var showAlert_exising_id = false
    @State private var showAlert_join_success = false
    
    
    var body: some View {
        
        ZStack {
            NavigationStack {
                VStack {
                    Spacer()
                    
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 330, height: 150)
                        .cornerRadius(20)  // Radius 가 안 먹는다.
                    //                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    Spacer()
                    
                    TextField("아이디 입력", text: $userId)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 50)
                        .padding(.bottom)
                    
                    
                    SecureField("비밀번호 입력", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 50)
                    
                    
                    SecureField("비밀번호 확인", text: $password_confirm)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 50)
                    
                    Spacer()
                    
                    Button(action: {
                        join()
                    }) {
                        Text("가 입 하 기")
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(100)
                            .padding(.horizontal, 50)
                    }
                    NavigationLink(destination: ContentView(), isActive: $isRegistered) {
                        EmptyView()
                    }
                    
                    Spacer()
                    
                }
                .padding(.bottom, 20)
                
                Spacer()
                
                
                
            }
            
            
        }
        .padding()
        
        .background(Color(red: 242/256, green: 234/256, blue: 221/256))
        .alert("", isPresented: $showAlert_wrong, actions: {
            Button("확인", role: .cancel) {}
        }, message: {
            Text("아이디 또는 비밀번호가 맞지 않습니다")
        })
        .alert("", isPresented: $showAlert_blank, actions: {
            Button("확인", role: .cancel) {}
        }, message: {
            Text("아이디 또는 비밀번호가 입력되지 않았습니다")
        })
        .alert("", isPresented: $showAlert_password_confirm_mismatch, actions: {
            Button("확인", role: .cancel) {}
        }, message: {
            Text("비밀번호와 확인 번호가 일치하지 않습니다")
        })
        .alert("", isPresented: $showAlert_exising_id, actions: {
            Button("확인", role: .cancel) {}
        }, message: {
            Text("이미 사용중인 아이디입니다.")
        })
        .alert("", isPresented: $showAlert_join_success, actions: {
            Button("확인", role: .cancel) { isRegistered = true /* ContentView 로 이동 */ }
        }, message: {
            Text("축하합니다.\n회원 가입에 성공했습니다.")
        })
        
    }
    
    
    private func join() {
        if userId == "" || password == "" || password_confirm == "" {
            showAlert_blank.toggle()
            print("로그인 실패: 아이디 또는 비밀번호가 입력되지 않았습니다.")
        }
        else if password != password_confirm {
            showAlert_password_confirm_mismatch.toggle()
        }
        else {
            
            if let user = users.first(where: { $0.id == userId }) { // // 이미 사용중인 id
                showAlert_exising_id.toggle()
            }
            else {  // 사용 가능한 id
                
                // User 테이블에 Insert
                modelContext.insert(User(id: userId, password: password))
                
                // loginMember 전역변수에 저장
                member = userId
                
                // 회원 가입 성공 Alert
                showAlert_join_success.toggle()
                
                userId = ""
                password = ""
                
                print("회원 가입 성공")
            }
            
        }
    }
    
}

#Preview {
    JoinView()
}
