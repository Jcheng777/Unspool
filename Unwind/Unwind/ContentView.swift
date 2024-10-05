//
//  ContentView.swift
//  Unwind
//
//  Created by Jesse Cheng on 10/5/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            JournalView()
                .tabItem {
                    Image(systemName: "book")
                    Text("Journal")
                }
            
            ChatView()
                .tabItem {
                    Image(systemName: "message")
                    Text("Chat")
                }
            
            
            MoodView()
                .tabItem {
                    Image(systemName: "smiley")
                    Text("Mood")
                }
        }
    }
}


#Preview {
    ContentView()
}
