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
    @Query private var groups: [Group]

    @State private var showAddGroup: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                Text("그룹 목록")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 20)

                List {
                    ForEach(groups) { group in
                        HStack {
                            Text(group.name)
                                .foregroundColor(.black)
                            Text(group.category)
                                .foregroundColor(.gray)
                        }
                    }
                    .onDelete(perform: deleteGroup)
                }
                HStack {
                    Spacer()
                    Button(action: { showAddGroup = true }) {
                        Text("목록 추가")
                            .foregroundColor(.black)
                            .font(.headline)
                    }
                }
                .padding(.vertical)
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .navigationTitle("My Groups")
        }
        .sheet(isPresented: $showAddGroup) {
            GroupAppView()
        }
    }

    private func deleteGroup(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(groups[index])
        }
    }
}

//#Preview {
//    ContentView()
//        .modelContainer(for: Group.self, inMemory: true)
//}
