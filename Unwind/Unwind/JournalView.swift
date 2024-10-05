//
//  JournalView.swift
//  Unwind
//
//  Created by Jesse Cheng on 10/5/24.
//

import Foundation

import SwiftUI


struct JournalView: View {
    @State private var entries: [JournalEntry] = [
        JournalEntry(date: "Yesterday", content: "It was a good day."),
        JournalEntry(date: "Wednesday", content: "A bit tired but overall fine.")
    ]
    
    // Navigation state for tracking navigation
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            List {
                // Section for "Add New Entry" Button
                Section {
                    Button(action: {
                        path.append("AddJournalEntry")
                    }) {
                        Text("Add New Entry")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.pink.opacity(0.3))
                            .cornerRadius(10)
                    }
                    .padding(.vertical, 10)
                }
                .listRowBackground(Color(UIColor.systemGray6))  // Adds the gray background like in the screenshot

                // Section for displaying journal entries
                Section {
                    ForEach(entries) { entry in
                        VStack(alignment: .leading) {
                            Text(entry.date)
                                .font(.headline)
                            Text(entry.content)
                                .font(.subheadline)
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())  // This style helps achieve the look of grouped sections
            .navigationBarTitle("Journal Entries", displayMode: .inline)
            .navigationDestination(for: String.self) { value in
                if value == "AddJournalEntry" {
                    JournalEntryView() // Placeholder for AddJournalEntryView
                }
            }
        }
    }
}
