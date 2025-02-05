//
//  ContentView.swift
//  DailyMission
//
//  Created by 이민서 on 2/4/25.
//
//민서님 작성
import SwiftUI
import SwiftData

struct EditModeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var groups: [Group]

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
                        listRowEditMode(color: group.color ?? "blue",
                                        name: group.name,
                                        category: group.category)
                    }
                    .onDelete(perform: deleteGroup)
                }
                .listStyle(.plain)
                .cornerRadius(12)
                
            }
        }
    }

    private func deleteGroup(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(groups[index])
        }
    
    }
    private func listRowEditMode(color: String, name: String, category: String) -> some View {
        NavigationLink(destination: GroupView(group: Group(name: name,
                                                           missionTitle: [],
                                                           memberCount: 0,
                                                           category: category,
                                                           members: [],
                                                           color: color))) {
            HStack {
                Image(systemName: "person.2.fill")
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
