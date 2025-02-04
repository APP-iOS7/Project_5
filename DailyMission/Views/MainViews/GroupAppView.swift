//
//  ContentView.swift
//  DailyMission
//
//  Created by 이민서 on 2/4/25.
//
//민서님 작성
import SwiftUI
import SwiftData

struct GroupAppView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Query private var groups: [Group]
    
    @State private var name: String = ""
    @State private var category: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Section {
                    TextField("제목", text: $name)
                    TextField("카테고리", text: $category)
                    
                    
                    
                    
                }
            }
            .padding()
            .navigationTitle("그룹 추가")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("추가") {
                        let group = Group(name: name,
                                          missionTitle: [],
                                          memberCount: 0,
                                          category: category,
                                          members: [],
                                          Date()
                        )
                        modelContext.insert(group)
                        dismiss()
                    }
                }
            }
        }
    }
}

//#Preview {
//    ContentView()
//        .modelContainer(for: Group.self, inMemory: true)
//}
