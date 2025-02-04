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
    @Query private var missions: [Mission]
    
    
    @State private var newMissionTitle: String = ""
    @State private var showAddMissionAlert: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                Text("ContentView")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 20)
                
                
                NavigationLink(destination: GroupView(group: Group(name: "ya", missionTitle: ["1","2"], memberCount: 2, category: "study"))) {
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
