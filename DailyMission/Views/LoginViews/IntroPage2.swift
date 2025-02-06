//
//  IntroPage2.swift
//  DailyMission
//
//  Created by 양준호 on 2/5/25.
//

import SwiftUI

struct IntroPage2: View {

    private var string: String = "오늘은 뭐 하지? 할 게 많네~~"
    
    var body: some View {
        
        VStack {
            Spacer()
            
            Image("intro_2")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 530)
                .clipShape(RoundedRectangle(cornerRadius: 40))
                .shadow(radius: 10)

            Text(string)
                .font(.title)
                .fontWeight(.semibold)
                .padding(.vertical, 10)
            
            Spacer()
        }
        
    }
}

#Preview {
    IntroPage2()
}
