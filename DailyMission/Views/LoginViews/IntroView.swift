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
                Spacer(minLength: 110)
                IntroPagesView()
                    .onAppear {
                        setUpAppearance()
                    }
            }
            
            VStack {
                NavigationLink(destination: LoginView()) {
                    Text("Login")
                        .font(.title)
                        .padding()
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .clipShape(Capsule())
                .tint(.primary)
                .padding()
            }
            
            
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
