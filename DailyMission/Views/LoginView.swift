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
    @Environment(\.modelContext) private var modelContext
    @Query private var missions: [Mission]
    
    @State private var isNavigated: Bool = false
    
    @State private var newMissionTitle: String = ""
    @State private var showAddMissionAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("LoginView")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 20)
                
                Button(action: {
                    isNavigated = true // ✅ 버튼 클릭 시 ContentView로 이동
                }) {
                    Text("시작하기")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                NavigationLink(destination: ContentView()) {
                    Text("이동")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

            }
            .padding()
        }
    }
}


//#Preview {
//    ContentView()
//        .modelContainer(for: Mission.self, inMemory: true)
//}
