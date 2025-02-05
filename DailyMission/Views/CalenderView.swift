//
//  CalenderView.swift
//  DailyMission
//
//  Created by 최하진 on 2/4/25.
//

import SwiftUI
import SwiftData



struct CalenderView: View {
    @Environment(\.modelContext) private var modelContext
    var group : Group
    @Query private var missions: [Mission]
    
  @State var clickedDate: Date? = Date()
  
  var body: some View {
      VStack{
          CalenderBodyView(group: group, month: Date(), clickedDate: $clickedDate)
          
      }
  }
}



//#Preview {
//    CalenderView(group: Group(name: "ya", missionTitle: ["1","2"], memberCount: 2, category: "study"), month: Date())
//}
