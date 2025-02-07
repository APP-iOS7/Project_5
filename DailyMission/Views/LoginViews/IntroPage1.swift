//
//  IntroPage1.swift
//  DailyMission
//
//  Created by 양준호 on 2/5/25.
//

import SwiftUI

struct IntroPage1: View {
    
    private var string: String = "Daily Mission~ Let it go!!!"
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(EdgeInsets(top: 0, leading: 30, bottom: 30, trailing: 30))
            
            Text(string)
                .font(.title)
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    IntroPage1()
}
