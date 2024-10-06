//
//  JournalEntryDetailView.swift
//  Unwind
//
//  Created by Christopher Cheng on 10/5/24.
//

import SwiftUI

struct JournalEntryDetailView: View {
    var entry: JournalEntry  // The journal entry to display

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(entry.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text(entry.date)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text(entry.content)  // Assuming `content` is a property in your JournalEntry
                    .font(.body)

                Spacer()
            }
            .padding()
            .navigationTitle("Entry Details")
        }
    }
}
