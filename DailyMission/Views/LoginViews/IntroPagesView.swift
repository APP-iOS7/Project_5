//
//  IntroPagesView.swift
//  DailyMission
//
//  Created by 양준호 on 2/5/25.
//

import SwiftUI

struct IntroPagesView: View {
    @State var navigationPath: NavigationPath = .init()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            TabView {
                IntroPage1()
                IntroPage2()
                IntroPage3()
                IntroPage4()
            }
            .tabViewStyle(PageTabViewStyle())
        }
        
    }
}

#Preview {
    IntroPagesView()
}
