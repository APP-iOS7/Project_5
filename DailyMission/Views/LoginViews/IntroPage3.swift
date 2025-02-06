//  IntroPage3.swift
//  DailyMission
//
//  Created by 양준호 on 2/5/25.
//

import SwiftUI

struct IntroPage3: View {
    
    private var string: String = "계획성 있게 꾸준히 해보자"
    
    var body: some View {
        
        VStack {
            Spacer()
            
            Image("intro_3")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 500)
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
    IntroPage3()
}
