//
//  IntroView.swift
//  DailyMission
//
//  Created by 양준호 on 2/5/25.
//

import SwiftUI

struct IntroView: View {
    @State private var currentPageNum: Int = 0
    

    var body: some View {
        
        NavigationStack {
            VStack {
                IntroPagesView()
                    .onAppear {
                        setUpAppearance()
                    }
                    .background(Color.clear)
                
                NavigationLink(destination: LoginView()) {
                    Text("Login")
                        .font(.title)
                        .frame(width: 200)
                }
                .buttonStyle(.borderedProminent)
                .clipShape(Capsule())
                .tint(.orange)
                .padding()
            }
            .background(Color(red: 242/256, green: 234/256, blue: 221/256))
        }
    }
    
    
    func setUpAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .orange
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.gray
    }
}


#Preview {
    IntroView()
}
