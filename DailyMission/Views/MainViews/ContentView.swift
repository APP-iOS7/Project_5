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

    let colors: [String] = ["red", "orange", "yellow", "green", "blue", "purple", "brown"]
    let colorMap: [String: Color] = [
        "red": .red,
        "orange": .orange,
        "yellow": .yellow,
        "green": .green,
        "blue": .blue,
        "purple": .purple,
        "brown": .brown
    ]
    var body: some View {
        NavigationStack {
            VStack {

                List {
                    ForEach(groups, id: \.self) { group in
                        listRow(color: group.color ?? "blue",
                                        name: group.name,
                                        category: group.category)
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
    private func listRow(color: String, name: String, category: String) -> some View {
        NavigationLink(destination: GroupView(group: Group(name: name,
                                                           missionTitle: [],
                                                           memberCount: 0,
                                                           category: category,
                                                           members: [],
                                                           color: color))) {
            HStack {
                Image(systemName: "person.3.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 10)
                    .foregroundColor(colorMap[color] ?? .blue)
                    .padding()
                
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
