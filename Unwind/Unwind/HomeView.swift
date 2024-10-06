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
                ZStack { // Wrap everything in a ZStack
                    // Background color for the whole screen
                    Color(red: 0.94, green: 0.94, blue: 0.94)
                        .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    
                    Image("cat")
                        .frame(width: 119.72414, height: 84)
                    
                    // Button to navigate to ChatView
                    NavigationLink(destination: ChatView()) {
                        VStack(spacing: 20) {
                            // Top "Good morning!" text
                            Text("Good morning!")
                                .font(
                                    Font.custom("MADE Carving Soft PERSONAL USE", size: 28)
                                        .weight(.medium)
                                )
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            // The inner rounded rectangle with "How have you been?" and arrow
                            HStack {
                                Text("How have you been?")
                                    .font(
                                        Font.custom("MADE Carving Soft PERSONAL USE", size: 16)
                                            .weight(.light)
                                    )
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                    .padding(.leading, 5)
                                    .padding(.bottom, 23)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .frame(width:16, height:16)
                                    .foregroundColor(.white)
                                    .padding(.trailing, 5)
                                    .offset(y: 15)
                            }
                            .padding()
                            .background(Color(red: 0.53, green: 0.41, blue: 0.68))
                            .cornerRadius(15)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 24)
                        .frame(maxWidth: .infinity, alignment: .top)
                        .background(
                            RoundedRectangle(cornerRadius: 32)
                                .fill(Color(red: 0.58, green: 0.45, blue: 0.72))
                        )
                        .padding(5)
                    }
                    
                    // Button to navigate to JournalView
                    NavigationLink(destination: JournalView()) {
                        VStack(spacing: 20) {
                            // "Let's journal!" Text
                            Text("Let's journal!")
                                .font(
                                    Font.custom("MADE Carving Soft PERSONAL USE", size: 28)
                                        .weight(.medium)
                                )
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(red: 0.54, green: 0.45, blue: 0.65))
                                .frame(maxWidth: .infinity, alignment: .top)
                            
                            // Space to align with "Good morning!" button
                            HStack {
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Color(red: 0.94, green: 0.92, blue: 0.98))
                            .cornerRadius(15)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 24)
                        .frame(maxWidth: .infinity, alignment: .top)
                        .background(
                            RoundedRectangle(cornerRadius: 32)
                                .fill(Color(red: 0.94, green: 0.92, blue: 0.98))
                        )
                        .padding(5)
                        
                    }
                    
                    // Button to navigate to MoodView
                    NavigationLink(destination: RatingView()) {
                        VStack(spacing: 20) {
                            // Top "Good morning!" text
                            Text("Check-in")
                                .font(
                                Font.custom("MADE Carving Soft PERSONAL USE", size: 28)
                                .weight(.medium)
                                )
                                .foregroundColor(Color(red: 0.67, green: 0.56, blue: 0.8))


                            
                            // The inner rounded rectangle with "How have you been?" and arrow
                            HStack {
                                Text("How are you feeling right now?")
                                    .font(
                                        Font.custom("MADE Carving Soft PERSONAL USE", size: 16)
                                            .weight(.light)
                                    )
                                    .foregroundColor(Color(red: 0.67, green: 0.56, blue: 0.8))
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                    .padding(.leading, 5)
                                    .padding(.bottom, 23)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .frame(width:16, height:16)
                                    .foregroundColor(.white)
                                    .padding(.trailing, 5)
                                    .offset(y: 15)
                            }
                            .padding()
                            .background(Color(red: 0.94, green: 0.92, blue: 0.98))
                            .cornerRadius(15)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 24)
                        .frame(maxWidth: .infinity, alignment: .top)
                        .background(
                            RoundedRectangle(cornerRadius: 32)
                                .fill(Color(red: 100, green: 100, blue: 100)))
                        .padding(5)
                    }
                    
                    Spacer()
                }
                .navigationBarHidden(true)
                .padding()
            }
            
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

