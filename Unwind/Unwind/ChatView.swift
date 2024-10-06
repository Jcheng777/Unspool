import SwiftUI

struct Message: Identifiable {
    let id = UUID() // Unique ID for each message
    let text: String
    let isUser: Bool // To distinguish between user and response
}

struct ChatView: View {
    @State private var userInput: String = "" // Holds the text the user inputs
    @State private var messages: [Message] = [] // Array to store conversation messages
    @State private var showPrompt = true // State to control the visibility of the prompt message
    @State private var conversationId: String? // Variable to hold conversation ID
    @State private var journalTitles: [String] = [] // Array to hold journal entry titles
    
    // Define grid columns to lay out buttons in a flexible grid
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    var body: some View {
        VStack {
            ScrollView {
                // List of messages
                LazyVStack(alignment: .leading, spacing: 10) {
                    if showPrompt {
                        Text("Hi Dean Bala! What would you like to talk about? I'm all ears!")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 0.72, green: 0.62, blue: 0.83)) // Box-like appearance
                            .cornerRadius(10)
                            .padding(.bottom, 5)
                    }
                    
                    ForEach(messages) { message in
                        Text(message.text)
                            .padding(10)
                            .foregroundColor(message.isUser ? .white : .black)
                            .background(message.isUser ? Color(red:0.79, green:0.68, blue:0.9) : Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .frame(maxWidth: 300, alignment: message.isUser ? .trailing : .leading) // Align based on user or AI
                            .frame(maxWidth: .infinity, alignment: message.isUser ? .trailing : .leading) // Full width with appropriate alignment
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 10) // Padding at the bottom of the messages
            }
            
            // Label for journal titles
            if !journalTitles.isEmpty {
                Text("Select a journal entry:")
                    .font(.headline)
                    .padding(.horizontal)
            }
            
            // Display buttons for journal titles in a grid layout
            if !journalTitles.isEmpty {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(journalTitles, id: \.self) { title in
                        Button(action: {
                            fetchJournalEntry(for: title) // Fetch journal entry on button click
                        }) {
                            Text(title)
                                .font(.system(size: 12)) // Smaller font size
                                .padding(8) // Smaller padding
                                .frame(maxWidth: .infinity, minHeight: 40) // Set minHeight for smaller buttons
                                .background(Color(red:0.79, green:0.68, blue:0.9))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            // Text field for user input
            HStack {
                TextField("Type your message...", text: $userInput, onCommit: sendMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // + Button to fetch journal titles
                Button(action: {
                    fetchJournalTitles() // Fetch titles when plus button is clicked
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 24))
                        .padding()
                }
            }
            .padding()
        }
        .padding(.bottom, 10) // Padding at the bottom to keep text input above screen bottom
    }
    
    // Function to send user input to the backend API
    func sendMessage() {
        guard !userInput.isEmpty else { return } // Don't send empty messages
        
        // Add user message to messages array
        messages.append(Message(text: userInput, isUser: true))
        
        // Hide the prompt after the first message
        if showPrompt {
            showPrompt = false
        }
        
        let url = URL(string: "https://flask-app-91222939065.us-east1.run.app/callCompanion")! // Replace with your actual backend URL
        
        let bearerToken = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjI4YTQyMWNhZmJlM2RkODg5MjcxZGY5MDBmNGJiZjE2ZGI1YzI0ZDQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIzMjU1NTk0MDU1OS5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsImF1ZCI6IjMyNTU1OTQwNTU5LmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwic3ViIjoiMTAxMTcwMzIwOTMzMjQwMzYwOTMwIiwiaGQiOiJjb3JuZWxsLmVkdSIsImVtYWlsIjoiY2RjMjM2QGNvcm5lbGwuZWR1IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJBYkExMkN1UHE5SWQ3RlpNUkNuUWhBIiwiaWF0IjoxNzI4MjEyMDA0LCJleHAiOjE3MjgyMTU2MDR9.0NDYjczTAdRHENNAGwu-It4zeX-PXNIFHc8vJYrz55GlWCvNeoblsPjVSlzhenW9IKafrNeVUmsKcRMaNgJzOE5f_LNMIGtOyzbIKImgUBgNCwfURVnL5qyCzH3mZ1oPuxNUngAvc-7uU5Sr2p3R8Z4Pkm2EpNDmTDLAO65EwOY1bNJA4tSc-Ou_mzzuDLLOD7Z7ocUCq9I_6EC-SY0taTU7nf0C0neU2SPtDDcxiZGKJa5QLNaKnQwbzziU47c-C5nj4jZAbSn_yYt1P4GJZTrC_cNyaqHamme7QC1Iot3BpVng4p9DTJRWuespmQjVLf99xBWxZkL_53G421SdYw"

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        // Create the body with conversationId (nil if first message)
        var body: [String: Any] = ["message": userInput, "userId": "testUserId"]
        if let conversationId = self.conversationId {
            body["conversationId"] = conversationId // Add if it's not nil
        }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error occurred: \(error)")
                return
            }
            
            if let data = data {
                do {
                    // Attempt to parse the response as JSON
                    if let responseDict = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        // Extract the conversationId from the response if it exists
                        if let newConversationId = responseDict["conversationId"] as? String {
                            DispatchQueue.main.async {
                                self.conversationId = newConversationId // Update conversationId
                            }
                        }
                        
                        // Assuming the response also has a message field
                        if let responseMessage = responseDict["response"] as? String {
                            DispatchQueue.main.async {
                                self.messages.append(Message(text: responseMessage, isUser: false)) // Add AI response
                            }
                        }
                    }
                } catch {
                    print("Failed to parse response: \(error)")
                }
            }
        }.resume()
        
        // Reset the text field
        userInput = ""
    }
    
    // Function to fetch journal titles
    func fetchJournalTitles() {
        guard let url = URL(string: "https://flask-app-91222939065.us-east1.run.app/getAllJournalEntries") else { return }
        
        let bearerToken = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjI4YTQyMWNhZmJlM2RkODg5MjcxZGY5MDBmNGJiZjE2ZGI1YzI0ZDQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIzMjU1NTk0MDU1OS5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsImF1ZCI6IjMyNTU1OTQwNTU5LmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwic3ViIjoiMTAxMTcwMzIwOTMzMjQwMzYwOTMwIiwiaGQiOiJjb3JuZWxsLmVkdSIsImVtYWlsIjoiY2RjMjM2QGNvcm5lbGwuZWR1IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJBYkExMkN1UHE5SWQ3RlpNUkNuUWhBIiwiaWF0IjoxNzI4MjEyMDA0LCJleHAiOjE3MjgyMTU2MDR9.0NDYjczTAdRHENNAGwu-It4zeX-PXNIFHc8vJYrz55GlWCvNeoblsPjVSlzhenW9IKafrNeVUmsKcRMaNgJzOE5f_LNMIGtOyzbIKImgUBgNCwfURVnL5qyCzH3mZ1oPuxNUngAvc-7uU5Sr2p3R8Z4Pkm2EpNDmTDLAO65EwOY1bNJA4tSc-Ou_mzzuDLLOD7Z7ocUCq9I_6EC-SY0taTU7nf0C0neU2SPtDDcxiZGKJa5QLNaKnQwbzziU47c-C5nj4jZAbSn_yYt1P4GJZTrC_cNyaqHamme7QC1Iot3BpVng4p9DTJRWuespmQjVLf99xBWxZkL_53G421SdYw"
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
                
                let titles = entries.map { $0.title }
                // Update the entries state on the main thread
                DispatchQueue.main.async {
                    self.journalTitles = titles
                }
            } catch {
                print("Error decoding entries: \(error)")
            }
        }.resume()
    }
    
    // Function to fetch a specific journal entry and send it as a message
    func fetchJournalEntry(for title: String) {
        guard let url = URL(string: "https://flask-app-91222939065.us-east1.run.app/getJournalEntryContent") else { return }
        
        let bearerToken = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjI4YTQyMWNhZmJlM2RkODg5MjcxZGY5MDBmNGJiZjE2ZGI1YzI0ZDQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIzMjU1NTk0MDU1OS5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsImF1ZCI6IjMyNTU1OTQwNTU5LmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwic3ViIjoiMTAxMTcwMzIwOTMzMjQwMzYwOTMwIiwiaGQiOiJjb3JuZWxsLmVkdSIsImVtYWlsIjoiY2RjMjM2QGNvcm5lbGwuZWR1IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJBYkExMkN1UHE5SWQ3RlpNUkNuUWhBIiwiaWF0IjoxNzI4MjEyMDA0LCJleHAiOjE3MjgyMTU2MDR9.0NDYjczTAdRHENNAGwu-It4zeX-PXNIFHc8vJYrz55GlWCvNeoblsPjVSlzhenW9IKafrNeVUmsKcRMaNgJzOE5f_LNMIGtOyzbIKImgUBgNCwfURVnL5qyCzH3mZ1oPuxNUngAvc-7uU5Sr2p3R8Z4Pkm2EpNDmTDLAO65EwOY1bNJA4tSc-Ou_mzzuDLLOD7Z7ocUCq9I_6EC-SY0taTU7nf0C0neU2SPtDDcxiZGKJa5QLNaKnQwbzziU47c-C5nj4jZAbSn_yYt1P4GJZTrC_cNyaqHamme7QC1Iot3BpVng4p9DTJRWuespmQjVLf99xBWxZkL_53G421SdYw" // Replace with your actual bearer token
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"  // Use POST instead of GET since you're sending a JSON body

        // Set headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")

        // Create JSON body with the journal title
        let body: [String: Any] = ["title": title]
        let jsonData = try? JSONSerialization.data(withJSONObject: body)

        request.httpBody = jsonData  // Add the JSON body to the request

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching journal entry: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                if let journalContent = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        print("Original journal content: '\(journalContent)'") // Log the content with visible quotes
                        
                        // Use regular expression to remove leading and trailing quotes
                        userInput = journalContent.replacingOccurrences(of: "^['\"]+|['\"]+$", with: "", options: .regularExpression)
                        
                        sendMessage() // Call the sendMessage function
                        
                        // Clear the journal titles after selecting one
                        self.journalTitles = []
                    }
                }            } catch {
                print("Error decoding journal entry: \(error)")
            }
        }.resume()
    }
}

