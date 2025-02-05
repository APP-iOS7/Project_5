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
    @State private var endDate: Date = Date()
    var group : Group
    @Query private var missions: [Mission]
    
    var body: some View {
        NavigationStack{
            Form {
                HStack{
                    Image(systemName: (title == "" ) ? "doc" : "doc.text.fill" )
                    TextField("새 미션 제목", text: $title)
                }
                DatePicker("미션 기한", selection: $endDate, displayedComponents: [.date])
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
                ToolbarItem(placement: .topBarTrailing){
                    Button("등록"){
                        let newMission = Mission(title: title, group: group)
                        newMission.dateStamp?.append(DateStamp(date: Date.now, isCompleted: false))
                        modelContext.insert(newMission)
                        dismiss()
                    }
                }
            }
        }
    }
}

//#Preview {
//    AddNewMissionView(group: Group(name: "Ya", missionTitle: ["AA","BB"], memberCount: 3, category: "study", members: ["jin","min","jun"], color: "Black"))
//}
