import Foundation

import SwiftUI

struct JournalView: View {
    @State private var entries: [JournalEntry] = []
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                // Button outside of List
                Button(action: {
                    path.append("AddJournalEntry")
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 40))
                        .foregroundColor(Color(red: 0.37, green: 0.25, blue: 0.5)) // Change the color to match your design
                }
                .frame(width: 345, height: 110) // Adjust size as needed
                .background(Color(red: 0.94, green: 0.92, blue: 0.98)) // Light purple background
                .cornerRadius(30) // Rounded corners
                .padding(.bottom, 20) // Add some space below the button

                // List for displaying journal entries
                List {
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
            }
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
        
        let bearerToken = "zLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsImF1ZCI6IjMyNTU1OTQwNTU5LmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwic3ViIjoiMTAxMTcwMzIwOTMzMjQwMzYwOTMwIiwiaGQiOiJjb3JuZWxsLmVkdSIsImVtYWlsIjoiY2RjMjM2QGNvcm5lbGwuZWR1IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJSdzdqcVRkNWFkdng3WTNOS0tocklRIiwiaWF0IjoxNzI4MTk2NDcwLCJleHAiOjE3MjgyMDAwNzB9.N1_bqExNsIrwrPf6Kh7A7TNadweCo8DXQ-oEw0hNYpOPFQgK3fmvwQwSGmmfZbda27MDMRUxuDxZ0hoyS6wOJcqBM2vwWKCmuEwyrWtJQBQVUUnNdWjAs2xXtwMStHtHs5e5Dgs4yVHf4tn5PGZ6umuLxpUqHsYJgKBteo3QA0an27majIYd8gjdRn1RoKiScpHtaOSpzvee01aM_lRCIGwK_4z9CB0PdWKx6YZ6fT4QCYXOoq8PXeSZqvluzmlNCfnlD9pbwJVr64aE1EEeQy8833dl3fbeLQQuG_2mkqTMcAYNGusMzx7zdiphIeK4azzGrSa4nzB6zanBpYdIzA" // Replace with your actual token
        
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
