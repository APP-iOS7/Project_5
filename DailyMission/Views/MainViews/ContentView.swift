//
//  ContentView.swift
//  DailyMission
//
//  Created by 이민서 on 2/4/25.
//
//민서님 작성
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var showAddGroup: Bool = false
    @State private var isEditMode: EditMode = .inactive

    var body: some View {
        NavigationStack {
            VStack {

                if isEditMode == .active {
                    EditModeView()
                } else {
                    MainView()
                }
                Spacer()
                
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .navigationTitle("My Groups")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button(action: {
                            withAnimation {
                                isEditMode = isEditMode == .active ? .inactive : .active
                            }
                        }) {
                            Text(isEditMode == .active ? "완료" : "편집")
                                .foregroundColor(.black)
                                .font(.headline)
                        }
                        Spacer()
                        Button(action: {
                            showAddGroup = true
                        }) {
                            Text("그룹 추가")
                                .foregroundColor(.black)
                                .font(.headline)
                        }
                    }
                    
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                        }) {
                            Label("우땨땨", systemImage: "info.circle")
                        }
                        
                        Button(action: {
                        }) {
                            Label("우땨땨", systemImage: "info.circle")
                        }
                        
                        Button(action: {
                        }) {
                            Label("우땨땨", systemImage: "info.circle")
                        }
                        
                        Button(action: {
                        }) {
                            Label("우땨땨", systemImage: "info.circle")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .imageScale(.large)
                            .foregroundColor(.black)
                    }
                    
                }
            }
        }
        .sheet(isPresented: $showAddGroup) {
            GroupAddView()
        }
    }

}

//#Preview {
//    ContentView()
//        .modelContainer(for: Group.self, inMemory: true)
//}
