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
    @AppStorage("loginMember") var member: String = "minseo"
    
    @Environment(\.modelContext) private var modelContext
    @Query private var missions: [Mission]
    
    
    @State private var newMissionTitle: String = ""
    @State private var showAddMissionAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("LoginView")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 20)
                
                
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
