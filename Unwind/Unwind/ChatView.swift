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

    var body: some View {
        VStack {
            ScrollView {
                // List of messages
                LazyVStack(alignment: .leading, spacing: 10) {
                    if showPrompt {
                        Text("What would you like to talk about? I'm all ears!")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray5)) // Box-like appearance
                            .cornerRadius(10)
                            .padding(.bottom, 5)
                    }

                    ForEach(messages) { message in
                        Text(message.text)
                            .padding(10)
                            .foregroundColor(message.isUser ? .white : .black)
                            .background(message.isUser ? Color.blue : Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .frame(maxWidth: 300, alignment: message.isUser ? .trailing : .leading) // Align based on user or AI
                            .frame(maxWidth: .infinity, alignment: message.isUser ? .trailing : .leading) // Full width with appropriate alignment
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 10) // Padding at the bottom of the messages
            }

            // Text field for user input
            HStack {
                TextField("Type your message...", text: $userInput, onCommit: sendMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                // + Button with no functionality for now
                Button(action: {
                    // Future functionality
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
        
        let bearerToken = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjI4YTQyMWNhZmJlM2RkODg5MjcxZGY5MDBmNGJiZjE2ZGI1YzI0ZDQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIzMjU1NTk0MDU1OS5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsImF1ZCI6IjMyNTU1OTQwNTU5LmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwic3ViIjoiMTAxMTcwMzIwOTMzMjQwMzYwOTMwIiwiaGQiOiJjb3JuZWxsLmVkdSIsImVtYWlsIjoiY2RjMjM2QGNvcm5lbGwuZWR1IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJxUkdseFcxN0FNa195bHFPa0Z3OXJRIiwiaWF0IjoxNzI4MTk0NjgzLCJleHAiOjE3MjgxOTgyODN9.0VhMgw5YLk_8ize87MDVl_9szvGoJeMA-Z3rRwSj-dYYVJ2ubhVTS-vpiYfYmDkSj_vbJFDmAK4xsXiBP3zc2ggG6NitBP1loULuogkqL4MtCZO-YApqjVSf0nPChXiT6phCUmR-ZHDTcj8cq16gD_u3SpUnay1z2AVSSrQ901KZMyz3a9whA9vPk1ogAscl1M7ERj7Xyg-KRPNxyI-KRlMVxi-LHi9wDj9gBdl4yTaeW7DwMYuvEgGqN4js0_tsUDz8OaPry4yXxyASfQuv8bPxfcSVZmnu4tItAk8tjoA4VqW_QBVJchEn4knXQIEMu3UdWF5nKZuikUnOti8rBA" // Use your actual bearer token
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        // Create the body with conversationId (nil if first message)
        var body: [String: Any] = ["message": userInput, "userId": "testUserId"]
        if let conversationId = self.conversationId {
            body["conversationId"] = conversationId // Add if it's not nil
        } // If conversationId is nil, it won't be added to the body
        
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
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
