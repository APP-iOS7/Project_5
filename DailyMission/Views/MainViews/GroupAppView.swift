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
    @State private var selectedColor: String = "blue"
    
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
    @State private var name: String = ""
    @State private var category: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()
                VStack {
                    Section {
                        VStack(alignment: .center) {
                            Image(systemName: "person.3.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 100)
                                .foregroundColor(colorMap[selectedColor] ?? .blue)
                                .padding()
                            
                            TextField("이름", text: $name)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                            
                                .foregroundColor(colorMap[selectedColor] ?? .blue)
                                .font(.headline)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            
                            TextField("카테고리", text: $category)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                                .foregroundColor(colorMap[selectedColor] ?? .blue)
                                .font(.headline)
                                .multilineTextAlignment(.center)
                        }
                    }
                    Picker("색상 선택", selection: $selectedColor) {
                        ForEach(colors, id: \.self) { color in
                            HStack {
                                Circle()
                                    .fill(colorMap[color] ?? .gray)
                                    .frame(width: 20, height: 20)
                                
                                Text(color)
                            }
                            .tag(color)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    Spacer()
                    
                }
                .padding()
                .navigationTitle("그룹 추가")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("취소") {
                            dismiss()
                        }
                        .foregroundColor(.black)
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
                        .foregroundColor(.black)
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
