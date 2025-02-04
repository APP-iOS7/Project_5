//
//  ContentView.swift
//  DailyMission
//
//  Created by 이민서 on 2/4/25.
//

import SwiftUI
import SwiftData

struct GroupView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var missions: [Mission]
    
    @State private var newMissionTitle: String = ""
    @State private var showAddMissionAlert: Bool = false

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(missions) { mission in
                    NavigationLink {
                        Text("Item at \(mission.title)")
                    } label: {
                        Text(mission.title)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: {
                        showAddMissionAlert = true
                    }) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .alert("새로운 미션 추가", isPresented: $showAddMissionAlert) {
                TextField("미션 제목을 입력하세요", text: $newMissionTitle)
                Button("추가", action: addItem)
                Button("취소", role: .cancel, action: {}) 
            } message: {
                Text("미션의 제목을 입력하세요.")
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            guard !newMissionTitle.isEmpty else { return } // ✅ 입력값이 비어있지 않은 경우만 추가
            let newItem = Mission(title: newMissionTitle) // ✅ 입력값 사용
            modelContext.insert(newItem)
            newMissionTitle = "" // ✅ 입력 필드 초기화
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(missions[index])
            }
        }
    }
}

//#Preview {
//    ContentView()
//        .modelContainer(for: Mission.self, inMemory: true)
//}
