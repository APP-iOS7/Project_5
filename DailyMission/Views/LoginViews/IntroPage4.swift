//
//  IntroPage4.swift
//  DailyMission
//
//  Created by 양준호 on 2/5/25.
//

import SwiftUI

struct IntroPage4: View {

    private var string: String = "다른 사람들도 열심히네.\n그럼 나도~"
    
    var body: some View {
        
        VStack {
            Spacer()
            
            Image("intro_4")
                .resizable()
                .scaledToFit()
                .frame(width: 270, height: 500)
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
    IntroPage4()
}
