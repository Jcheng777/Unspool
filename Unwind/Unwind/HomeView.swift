//
//  HomeView.swift
//  Unwind
//
//  Created by Jesse Cheng on 10/5/24.
//

import Foundation

import SwiftUI


struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                Text("Unspool")
                    .font(.largeTitle)
                
                // Button to navigate to ChatView
                NavigationLink(destination: ChatView()) {
                    ButtonView(text: "Good morning!\nHow are you?", iconName: "sun.max.fill")
                }
                
                // Button to navigate to JournalView
                NavigationLink(destination: JournalView()) {
                    ButtonView(text: "Let's journal!", iconName: "book.fill")
                }
                
                // Button to navigate to MoodView
                NavigationLink(destination: MoodView()) {
                    ButtonView(text: "How are you feeling today?", iconName: "face.smiling")
                }
                
                Spacer()
            }
            .navigationBarHidden(true)
            .padding()
            
        }
    }
    
    struct ButtonView: View {
        var text: String
        var iconName: String
        
        var body: some View {
            HStack {
                Image(systemName: iconName)
                    .font(.title)
                Text(text)
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .frame(width: 350, height: 75)
            .background(Color.purple.opacity(0.3))
            .cornerRadius(15)
        }
    }
}
