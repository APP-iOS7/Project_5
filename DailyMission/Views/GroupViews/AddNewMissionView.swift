//
//  AddNewMissionView.swift
//  DailyMission
//
//  Created by 최하진 on 2/5/25.
//

import SwiftUI
import SwiftData

struct AddNewMissionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var endDate: Date? = nil
    @State private var icon: String? = "doc"

    @Bindable var group : Group
    @Query private var missions: [Mission]
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
    let missionIcons = [
        "star", "heart", "flame", "bolt", "leaf",
        "pencil", "book", "clock", "figure.walk", "bicycle",
        "gamecontroller", "paintbrush", "camera", "music.note", "flag"
    ]
    var body: some View {
        NavigationStack{
            VStack {
                VStack(alignment: .center) {
                    HStack{
                        TextField("새 미션 제목", text: $title)
                            .padding()
                            .overlay(
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(.black),
                                alignment: .bottom
                            )
                            .foregroundColor(colorMap[group.color ?? "blue"] ?? .blue)
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                    VStack(alignment: .leading) {
                        
                        Text("미션 기한")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text(formattedDate(endDate ?? Date()))

                            .foregroundColor(colorMap[group.color ?? "blue"] ?? .blue)
                            .font(.footnote)
                        DatePicker("", selection: Binding(get: {
                            endDate ?? Date()
                        }, set: { endDate = $0 }),
                                   displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                        .tint(colorMap[group.color ?? "blue"] ?? .gray)
                        
                    }
                    .padding()
                    HStack {

                        Picker(selection: $icon, label: Text("아이콘 선택")
                                .font(.headline)
                                .foregroundColor(.gray)) {
                            Text("선택 없음")
                                        .tag(nil as String?)
                                        
                            ForEach(missionIcons, id: \.self) { iconName in
                                HStack {
                                    Image(systemName: iconName)
                                    Text(iconName)
                                }
                                .tag(iconName as String?)
                                .foregroundColor(colorMap[group.color ?? "blue"] ?? .blue)

                            }
                        }
                        .pickerStyle(NavigationLinkPickerStyle())
                    }
                    .padding()
                    Spacer()
                }
                .padding()
                
            }
            .navigationTitle(
                Text("새 미션 추가")
            )
            .toolbar() {
                ToolbarItem(placement: .topBarLeading){
                    Button("취소"){
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("등록") {
                        let userStamps = group.members?.map { user in
                            UserStamp(userId: user.id, dateStamp: [DateStamp(date: Date(), isCompleted: false)])
                        } ?? []
                        
                        let newMission = Mission(
                            title: title,
                            userStamp: userStamps,
                            endDate: endDate,
                            icon: icon,
                            group: group
                        )

                        modelContext.insert(newMission)

                        group.missionTitle = (group.missionTitle ?? []) + [newMission]

                        try? modelContext.save()
                        dismiss()
                    }
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
//    AddNewMissionView(group: Group(name: "Ya", missionTitle: ["AA","BB"], memberCount: 3, category: "study", members: ["jin","min","jun"], color: "Black"))
//}
