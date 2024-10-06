//
//  ContentView.swift
//  Unwind
//
//  Created by Jesse Cheng on 10/5/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color(red: 0.94, green: 0.94, blue: 0.94)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            TabView {
                HomeView()
                    .tabItem {
                        Image("chatbot")
                    }
                
                JournalView()
                    .tabItem {
                        Image("journal")
                    }
                
                HomeView()
                    .tabItem {
                        Image("home icon")
                    }
                
                MoodView()
                    .tabItem {
                        Image("graph")
                    }
                
                ProfileView()
                    .tabItem {
                        Image("profile")
                    }
            }
            .onAppear() {
                UITabBar.appearance().backgroundColor = .white
            }

        }
    }
}

#Preview {
    ContentView()
}
