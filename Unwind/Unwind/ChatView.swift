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
        
        let bearerToken = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjI4YTQyMWNhZmJlM2RkODg5MjcxZGY5MDBmNGJiZjE2ZGI1YzI0ZDQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIzMjU1NTk0MDU1OS5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsImF1ZCI6IjMyNTU1OTQwNTU5LmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwic3ViIjoiMTAxMTcwMzIwOTMzMjQwMzYwOTMwIiwiaGQiOiJjb3JuZWxsLmVkdSIsImVtYWlsIjoiY2RjMjM2QGNvcm5lbGwuZWR1IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiIyekVWbU9GMGFkUlM0YWd6clNJMWRRIiwiaWF0IjoxNzI4MTg1NTUwLCJleHAiOjE3MjgxODkxNTB9.I23JsHb8_PlHXKC9l7KDetq0TncAgjTqnjebhaYuvWW4J4mS6Jcblp4bZ-aT6AHs0jitl_AX_XStegYIQA6o4Bmyel0ZTOfPxYs-KE-yNaJDgL7D3c_XhCgGy6kTVogITuoaGscnGvjzGotWkIJ0rNTQNGgaNFYZF9UGBwN63lfn5QLUdlCP2xFVToHngFcUxHAkB4GpBX9TaXtJwbrebO1l2PT6cCq4E23qrZ7TrMPlc58Jv2ezVYQJXd8Ygf806oO_aj4FEwKrXdkHlQ0VwD0ruYD3gdVL51mc4TKB_2vgwhUxGGWzbY4w2fxlQMqGrk8bbypOXMdg4iyBA8H_zg" // Use your actual bearer token
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        let body: [String: String] = ["message": userInput]
        let jsonData = try? JSONSerialization.data(withJSONObject: body)

        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error occurred: \(error)")
                return
            }
            
            if let data = data {
                if let responseString = String(data: data, encoding: .utf8) {
                    let cleanedResponse = responseString.replacingOccurrences(of: "\"", with: "")
                    
                    DispatchQueue.main.async {
                        // Add API response to messages array without quotation marks
                        self.messages.append(Message(text: cleanedResponse, isUser: false))
                    }
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

