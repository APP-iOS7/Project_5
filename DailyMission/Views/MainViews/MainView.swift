//
//  ContentView.swift
//  DailyMission
//
//  Created by 이민서 on 2/4/25.
//
//민서님 작성
import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var groups: [Group]

    @State private var showAddGroup: Bool = false
    @State private var isEditMode: Bool = false
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

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
    let iconSize: CGFloat = 30
    
    var body: some View {
        NavigationStack {
            VStack {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(groups, id: \.self) { group in
                        listButton(color: group.color ?? "blue",
                                        name: group.name,
                                        category: group.category,
                                   count: group.memberCount)
                    }
                    .onDelete(perform: deleteGroup)
                }
                
            }
        }
    }

    private func deleteGroup(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(groups[index])
        }
    
    }
    private func listButton(color: String, name: String, category: String, count: Int) -> some View {
        NavigationLink(destination: GroupView(group: Group(name: name,
                                                           missionTitle: [],
                                                           memberCount: 0,
                                                           category: category,
                                                           members: [],
                                                           color: color))) {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: iconSize))
                        .foregroundColor(colorMap[color] ?? .blue)
                    
                    Spacer()
                    
                    Text("\(count)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                }
                Spacer()
                Text(name)
                    .font(.headline)
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                Text(category)
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 80)
            .background(Color(.white))
            .cornerRadius(12)
            
        }
    }
}

//#Preview {
//    ContentView()
//        .modelContainer(for: Group.self, inMemory: true)
//}
