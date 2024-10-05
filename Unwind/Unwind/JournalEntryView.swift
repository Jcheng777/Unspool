//
//  JournalEntryView.swift
//  Unwind
//
//  Created by Jesse Cheng on 10/5/24.
//

import Foundation

import SwiftUI

struct JournalEntryView: View {
    @State private var title: String = ""
    @State private var content: String = ""

    var body: some View {
        VStack {
            TextField("Title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextEditor(text: $content)
                .frame(minHeight: 300)
                .padding(.horizontal)
                .border(Color.gray, width: 1)

            Spacer()

            Button("Save Entry") {
                // Logic to save the new journal entry
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .navigationTitle("New Journal Entry")
        .padding()
        
    }
}
