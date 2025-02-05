//
//  ContentView.swift
//  DailyMission
//
//  Created by 이민서 on 2/4/25.
//
//민서님 작성
import SwiftUI
import SwiftData

struct GroupAddView: View {
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
    @State private var dueDate: Date?
    @State private var enableDueDate: Bool = false
    
    @State private var categoryEnable: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .center) {
                    
                    TextField("이름", text: $name)
                        .padding()
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.black),
                            alignment: .bottom
                        )
                    
                        .foregroundColor(colorMap[selectedColor] ?? .blue)
                        .font(.headline)
                        .fontWeight(.bold)
                    TextField("카테고리", text: $category)
                        .padding()
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.black),
                            alignment: .bottom
                        )
                        .foregroundColor(colorMap[selectedColor] ?? .blue)
                        .font(.headline)
                    HStack {
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Toggle("날짜", isOn: $enableDueDate)
                            
                            
                            if enableDueDate {
                                Text(dueDate == nil ? "" : formattedDate(dueDate!))
                                    .foregroundColor(.blue)
                                    .font(.footnote)
                                    .padding(.top, -5)
                            }
                        }
                        .padding(.leading, 10)
                    }
                    if enableDueDate {
                        DatePicker("", selection: Binding(get: {
                            dueDate ?? Date()
                        }, set: { dueDate = $0 }),
                                   displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .padding(-10)
                        .labelsHidden()
                    }
                    HStack {
                        Text("색깔 지정")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Picker(selection: $selectedColor, label: Text("")) {
                            ForEach(colors, id: \.self) { color in
                                HStack {
                                    Circle()
                                        .fill(colorMap[color] ?? .gray)
                                        .frame(width: 20, height: 20)
                                    
                                    Text(color)
                                    
                                }
                                .font(.headline)
                                .tag(color)
                            }
                        }
                        .pickerStyle(NavigationLinkPickerStyle())
                        .labelsHidden()
                        
                    }
                    .padding()
                    
                    
                }
                
                Spacer()
                
            }
            .padding()
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
                                          color:selectedColor,
                                          dueDate: dueDate,
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
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일 E요일"
        return formatter.string(from: date)
    }
}

//#Preview {
//    ContentView()
//        .modelContainer(for: Group.self, inMemory: true)
//}
