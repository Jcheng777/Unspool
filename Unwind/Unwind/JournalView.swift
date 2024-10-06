//
//  JournalView.swift
//  Unwind
//
//  Created by Jesse Cheng on 10/5/24.
//

import Foundation

import SwiftUI


struct JournalView: View {
    @State private var entries: [JournalEntry] = []
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
                .listRowBackground(Color(UIColor.systemGray6))

                // Section for displaying journal entries
                Section {
                    ForEach(entries) { entry in
                        NavigationLink(destination: JournalEntryDetailView(entry: entry)) {
                            VStack(alignment: .leading) {
                                Text(entry.title)   // Display the title of the journal entry
                                    .font(.headline)
                                Text(entry.date)    // Display the date
                                    .font(.subheadline)
                            }
                            .padding(.vertical, 5)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Journal Entries", displayMode: .inline)
            .navigationDestination(for: String.self) { value in
                if value == "AddJournalEntry" {
                    JournalEntryView() // Navigate to JournalEntryView for adding new entries
                }
            }
            .onAppear {
                fetchJournalEntries()  // Fetch the journal entries when the view appears
            }
        }
    }


    
    // Function to fetch journal entries from the backend
    func fetchJournalEntries() {
        guard let url = URL(string: "https://flask-app-91222939065.us-east1.run.app/getAllJournalEntries") else { return }
        
        let bearerToken = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjI4YTQyMWNhZmJlM2RkODg5MjcxZGY5MDBmNGJiZjE2ZGI1YzI0ZDQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIzMjU1NTk0MDU1OS5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsImF1ZCI6IjMyNTU1OTQwNTU5LmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwic3ViIjoiMTAxMTcwMzIwOTMzMjQwMzYwOTMwIiwiaGQiOiJjb3JuZWxsLmVkdSIsImVtYWlsIjoiY2RjMjM2QGNvcm5lbGwuZWR1IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJ6VGl1Xy1RWGNWcTRZUFg2RUVYMVJRIiwiaWF0IjoxNzI4MTc2NzQ1LCJleHAiOjE3MjgxODAzNDV9.sAI_iEOC4BbE9D8TZXWnIxPNJ5OdOo0Gx9htjLXt-7uREUdvPJbRsme-772NjR36dLcoXm8Il2CVXXYUA2-00eb-PAegMo7qbJoqdgysDNpFZSq8CjVR55exfTdxb-rLeF20UrieQwAlJVOHjwekyr3FWQdwuSTT3YTTxNuevWGwgrf8B5LCHnT8XDeVAEJXoSW6_qFDc3YeLHppDaLaupExGl1zJJswlOTj79BA7MmLporO4ZdsepYyU4omgNC6K_U9hVZ-jm5du_xqGS6qVeLcroLVm9zUxlAjFxGMfoBY_L2rlO6OcLyFLzY8IY5zaFdtes5K3YYjV3i6BSYR-g" // Replace with your actual token
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        // Perform the GET request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching entries: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                // Decode the JSON data into an array of JournalEntry
                let entries = try JSONDecoder().decode([JournalEntry].self, from: data)
                
                // Update the entries state on the main thread
                DispatchQueue.main.async {
                    self.entries = entries
                }
            } catch {
                print("Error decoding entries: \(error)")
            }
        }.resume()
    }
}
