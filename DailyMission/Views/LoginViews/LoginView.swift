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
                    
                    SecureField("비밀번호 입력", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 50)
                    
                    Button(action: {
                        login()
                    }) {
                        Text("로    그    인")
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(100)
                            .padding(.horizontal, 50)
                    }
                    NavigationLink(destination: ContentView(), isActive: $isLoggedIn) {
                        EmptyView()
                    }
                    
                    
                    Spacer()
                    
                    // 소셜 로그인 버튼 섹션
                    VStack(spacing: 13) {
                        // 카카오 로그인 버튼
                        NavigationLink(destination: ContentView()) {
                            HStack {
                                Image("kakaoLogo")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                Text("카카오톡으로 시작")
                                    .font(.system(size: 16))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .background(Color.yellow)
                            .foregroundColor(.black)
                            .cornerRadius(100)
                        }
                        .frame(height: 50)
                        .padding(.horizontal, 50)
                        
                        // Google 로그인 버튼
                        NavigationLink(destination: ContentView()) {
                            HStack {
                                Image("googleLogo")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                Text("Google로 시작")
                                    .font(.system(size: 16))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(100)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 100)
//                                    .stroke(Color.gray, lineWidth: 1)
//                            )
                        }
                        .frame(height: 50)
                        .padding(.horizontal, 50)
                        
                        // Apple 로그인 버튼
                        NavigationLink(destination: ContentView()) {
                            HStack {
                                Image(systemName: "applelogo")
                                    .resizable()
                                    .frame(width: 20, height: 24)
                                Text("Apple로 등록")
                                    .font(.system(size: 16))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(100)
                        }
                        .frame(height: 50)
                        .padding(.horizontal, 50)
                        
                        // Facebook 로그인 버튼
                        NavigationLink(destination: ContentView()) {
                            HStack {
                                Image("facebookLogo")
                                    .resizable()
                                    .frame(width: 35, height: 24)
                                Text("Facebook으로 시작")
                                    .font(.system(size: 16))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(100)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 100)
//                                    .stroke(Color.gray, lineWidth: 1)
//                            )
                        }
                        .frame(height: 50)
                        .padding(.horizontal, 50)
                    }
                    .padding(.bottom, 20)
                    
                    Spacer()
                    
                    

                }
    //            .navigationBarBackButtonHidden()
    //            .background(Color.white.edgesIgnoringSafeArea(.all))
                
            }
            .padding()
        }
        .background(Color(red: 242/256, green: 234/256, blue: 221/256))

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


#Preview {
    LoginView()
}
