import SwiftUI

struct ChatView: View {
    @State private var userInput: String = "" // Holds the text the user inputs
    @State private var responseMessage: String? // To store the API response message
    
    var body: some View {
        VStack {
            Spacer() // Push content to the top

            // Label above the TextField, styled as a box
            VStack(alignment: .leading) {
                Text("What would you like to talk about? I'm all ears!")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray5)) // Box-like appearance
                    .cornerRadius(10)
                    .padding(.bottom, 5)

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

                if let response = responseMessage {
                    Text("Response: \(response)")
                        .padding()
                        .foregroundColor(.green)
                }
            }
            .padding()

        }
        .padding(.bottom, 10) // Padding at the bottom to keep text input above screen bottom
    }
    
    // Function to send user input to the backend API
    func sendMessage() {
        guard !userInput.isEmpty else { return } // Don't send empty messages
        
        let url = URL(string: "https://flask-app-91222939065.us-east1.run.app/callCompanion")! // Replace with your actual backend URL
        
        let bearerToken = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjI4YTQyMWNhZmJlM2RkODg5MjcxZGY5MDBmNGJiZjE2ZGI1YzI0ZDQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIzMjU1NTk0MDU1OS5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsImF1ZCI6IjMyNTU1OTQwNTU5LmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwic3ViIjoiMTAxMTcwMzIwOTMzMjQwMzYwOTMwIiwiaGQiOiJjb3JuZWxsLmVkdSIsImVtYWlsIjoiY2RjMjM2QGNvcm5lbGwuZWR1IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiIwczVVbGxOSXZfWHhRcC1rMElRM2JnIiwiaWF0IjoxNzI4MTgyMDU0LCJleHAiOjE3MjgxODU2NTR9.upiRN1Yt7WaYjk4R-MHyVSPGvaZEWpqa775kaXpFQwBYaEmen1c09RTBBQ1gZ5EOX5PmujR6TFjgkyBHqURUy4Ibm5hXtoXUeEo2ptaszC66kE9UbnXbRuYznOd6POFqrXDUBJPWoN7Y00-jLUx3rZlmK-rrHIuDBLEQ1iHLYl1pxZ9ZKuGmrIdB20rJ9Yd9qXYv2xjUU2iZks_b1qPmy3Qi6iupBEwV0rDyk8ba43DqB7xPfbwj3abqKGwwGcSw8DylvGjNcHQnbGUFaYJzL_mfnPaYyJvACwXJ6w1tvcxLIYhfUGoDri8Aw8hFeSONggIjeRqHryZ0dfyTFlzbUA"
        
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
                    DispatchQueue.main.async {
                        self.responseMessage = responseString // Display API response
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
