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

                List {
                    ForEach(groups, id: \.self) { group in
                        listRow(
                            name: group.name,
                            category: group.category
                        )
                    }
                    .onDelete(perform: deleteGroup)
                }
                .listStyle(.plain)
                .cornerRadius(12)
                HStack {
                    Spacer()
                    Button(action: {
                        showAddGroup = true
                    }) {
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
    private func listRow(name: String, category: String) -> some View {
        NavigationLink(destination: GroupView(group: Group(name: "ya", missionTitle: ["1","2"], memberCount: 2, category: "study", members: []))) {
            HStack {
                
                
                Text(name)
                    .font(.system(size: 18))
                    .foregroundColor(.black)
                
                Spacer()
                
                Text(category)
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
                
            }
            .listRowBackground(Color.white)
        }
    }
}

//#Preview {
//    ContentView()
//        .modelContainer(for: Group.self, inMemory: true)
//}
