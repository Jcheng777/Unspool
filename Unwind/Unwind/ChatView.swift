//
//  ChatView.swift
//  Unwind
//
//  Created by Jesse Cheng on 10/5/24.
//
import SwiftUI

struct ChatView: View {
    @State private var userInput: String = ""  // State to store the user input
    @State private var isSending: Bool = false  // State to track if data is being sent
    @State private var journalEntries: [JournalEntry] = []  // Store the fetched journal entries
    
    var body: some View {
        VStack {
            Spacer()  // Pushes the content to the middle

            // Display the message
            Text("What would you like to talk about? I'm all ears!")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding()

            // TextField for user input with onCommit to handle Enter key press
            TextField("Type something here...", text: $userInput, onCommit: {
                sendMessage()  // Call API request when "Enter" is pressed
            })
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)

            // Buttons for journal entries
            VStack {
                Text("Journal Entries:")
                    .font(.headline)
                    .padding(.top)
                
                // Scrollable list of buttons for each journal entry
                ScrollView {
                    VStack {
                        ForEach(journalEntries) { entry in
                            Button(action: {
                                sendJournalEntryRequest()  // Send API request with the journal entry ID
                            }) {
                                Text(entry.title)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(8)
                                    .padding(.vertical, 2)
                            }
                        }
                    }
                }
                .frame(maxHeight: 250)  // Adjust the height of the scroll view to display all buttons properly
                .padding(.horizontal)
            }

            Spacer()  // Adds space below the input field
        }
        .padding()
        .navigationBarTitle("Chat", displayMode: .inline)
        .onAppear {
            fetchJournalEntries()  // Fetch the journal entries when the view appears
        }
    }
    
    
    // Function to send message via an API request
    func sendMessage() {
        guard !userInput.isEmpty else { return }  // Do not send empty messages

        let urlString = "https://flask-app-91222939065.us-east1.run.app/callCompanion"  // Replace with your actual API endpoint
        
        let bearerToken = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjI4YTQyMWNhZmJlM2RkODg5MjcxZGY5MDBmNGJiZjE2ZGI1YzI0ZDQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIzMjU1NTk0MDU1OS5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsImF1ZCI6IjMyNTU1OTQwNTU5LmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwic3ViIjoiMTAxMTcwMzIwOTMzMjQwMzYwOTMwIiwiaGQiOiJjb3JuZWxsLmVkdSIsImVtYWlsIjoiY2RjMjM2QGNvcm5lbGwuZWR1IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJ6VGl1Xy1RWGNWcTRZUFg2RUVYMVJRIiwiaWF0IjoxNzI4MTc2NzQ1LCJleHAiOjE3MjgxODAzNDV9.sAI_iEOC4BbE9D8TZXWnIxPNJ5OdOo0Gx9htjLXt-7uREUdvPJbRsme-772NjR36dLcoXm8Il2CVXXYUA2-00eb-PAegMo7qbJoqdgysDNpFZSq8CjVR55exfTdxb-rLeF20UrieQwAlJVOHjwekyr3FWQdwuSTT3YTTxNuevWGwgrf8B5LCHnT8XDeVAEJXoSW6_qFDc3YeLHppDaLaupExGl1zJJswlOTj79BA7MmLporO4ZdsepYyU4omgNC6K_U9hVZ-jm5du_xqGS6qVeLcroLVm9zUxlAjFxGMfoBY_L2rlO6OcLyFLzY8IY5zaFdtes5K3YYjV3i6BSYR-g"
        
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")

        
        // The body of the request (your chat message)
        let body: [String: Any] = ["message": userInput]
        
        // Convert body to JSON
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else { return }
        request.httpBody = jsonData
        
        // Set isSending to true to show user it's being sent
        isSending = true
        
        // Send the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isSending = false  // Mark as not sending anymore
            }
            
            if let error = error {
                print("Error sending message: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response from the server")
                return
            }
            
            print("Message sent successfully")
            
            // Clear the input field after sending
            DispatchQueue.main.async {
                userInput = ""
            }
        }.resume()
    }
    
    // Function to fetch journal entries from the backend
    func fetchJournalEntries() {
        let urlString = "https://flask-app-91222939065.us-east1.run.app/getAllJournalEntries"  // Replace with your API endpoint
        guard let url = URL(string: urlString) else { return }
        
        let bearerToken = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjI4YTQyMWNhZmJlM2RkODg5MjcxZGY5MDBmNGJiZjE2ZGI1YzI0ZDQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIzMjU1NTk0MDU1OS5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsImF1ZCI6IjMyNTU1OTQwNTU5LmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwic3ViIjoiMTAxMTcwMzIwOTMzMjQwMzYwOTMwIiwiaGQiOiJjb3JuZWxsLmVkdSIsImVtYWlsIjoiY2RjMjM2QGNvcm5lbGwuZWR1IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJ6VGl1Xy1RWGNWcTRZUFg2RUVYMVJRIiwiaWF0IjoxNzI4MTc2NzQ1LCJleHAiOjE3MjgxODAzNDV9.sAI_iEOC4BbE9D8TZXWnIxPNJ5OdOo0Gx9htjLXt-7uREUdvPJbRsme-772NjR36dLcoXm8Il2CVXXYUA2-00eb-PAegMo7qbJoqdgysDNpFZSq8CjVR55exfTdxb-rLeF20UrieQwAlJVOHjwekyr3FWQdwuSTT3YTTxNuevWGwgrf8B5LCHnT8XDeVAEJXoSW6_qFDc3YeLHppDaLaupExGl1zJJswlOTj79BA7MmLporO4ZdsepYyU4omgNC6K_U9hVZ-jm5du_xqGS6qVeLcroLVm9zUxlAjFxGMfoBY_L2rlO6OcLyFLzY8IY5zaFdtes5K3YYjV3i6BSYR-g" // Replace with your actual token
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching entries: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                // Decode the JSON data into an array of JournalEntry
                let entries = try JSONDecoder().decode([JournalEntry].self, from: data)
                
                // Update the journalEntries state on the main thread
                DispatchQueue.main.async {
                    self.journalEntries = entries
                }
            } catch {
                print("Error decoding entries: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    // Function to send an API request when a journal entry button is pressed
    func sendJournalEntryRequest() {
        let urlString = "https://flask-app-91222939065.us-east1.run.app/processJournalEntry"  // Replace with your actual API endpoint
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // The body of the request (journal entry ID)
        let body: [String: Any] = ["entryId": "placeholder"]
        
        // Convert body to JSON
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else { return }
        request.httpBody = jsonData
        
        // Send the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending journal entry request: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response from the server")
                return
            }
            
            print("Journal entry processed successfully")
        }.resume()
    }
}

