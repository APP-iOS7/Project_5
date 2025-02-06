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
            
            Image("ContentView")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 450)
                .clipShape(RoundedRectangle(cornerRadius: 40))
                .shadow(radius: 10)
                .offset(x: 30)
            //                .resizable()
            //                .aspectRatio(contentMode: .fit)
            //                .padding(EdgeInsets(top: 0, leading: 30, bottom: 30, trailing: 30))
            
            Spacer()
            
            Text(string)
                .font(.title)
                .fontWeight(.semibold)
            
            Spacer()
        }
        
    }
}

#Preview {
    IntroPage2()
}
