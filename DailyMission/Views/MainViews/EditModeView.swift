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
    let iconSize: CGFloat = 30
    let minusSize: CGFloat = 23
    
    @State private var showDeleteAlert = false
    @State private var groupToDelete: Group?
    
    var body: some View {
        NavigationStack {
            VStack {
                
                List {
                    ForEach(groups, id: \.self) { group in
                        editRow(color: group.color ?? "blue",
                                name: group.name,
                                category: group.category,
                                group: group
                        )
                    }
                }
                .listStyle(.plain)
                .cornerRadius(12)
                
            }
        }
        .alert("그룹을 나가시겠습니까?", isPresented: $showDeleteAlert) {
            Button("취소", role: .cancel) { }
            Button("나가기", role: .destructive) {
                if let group = groupToDelete {
                    deleteGroup(group)
                }
            }
        } message: {
            Text("이 작업은 되돌릴 수 없습니다.")
        }
    }
    private func deleteGroup(_ group: Group) {
        modelContext.delete(group)
    }
    
    private func editRow(color: String, name: String, category: String, group: Group) -> some View {
        HStack {
            Button(action: {
                groupToDelete = group
                showDeleteAlert = true
                
            }) {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(.red)
                    .font(.system(size: minusSize))
            }
            .buttonStyle(PlainButtonStyle())
            .contentShape(Rectangle())
            
            Image(systemName: "person.2.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: iconSize)
                .foregroundColor(colorMap[color] ?? .blue)
                .padding()
            
            Text(name)
                .font(.system(size: 18))
                .foregroundColor(.black)
            
            Spacer()
            
            
        }
        .listRowBackground(Color.white)
    }
}

//#Preview {
//    ContentView()
//        .modelContainer(for: Group.self, inMemory: true)
//}
