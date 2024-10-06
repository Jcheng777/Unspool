import SwiftUI
import Foundation

struct JournalEntryView: View {
    @State private var title: String = ""
    @State private var content: String = ""

    var body: some View {
        VStack(spacing: 20) {
            // Title Field
            TextField("Title...", text: $title)
                .padding(20)
                .foregroundColor(Color(red: 0.37, green: 0.25, blue: 0.5))
                .font(.system(size: 28, weight: .bold))
                .background(Color(red: 0.94, green: 0.92, blue: 0.98))
                .cornerRadius(40)
                .padding(.horizontal)

            // TextEditor with Purple Background
            ZStack(alignment: .topLeading) {
                // Purple background
                Color(red: 0.74, green: 0.64, blue: 0.94) // A soft purple background color
                    .cornerRadius(40) // Rounded corners
                    .padding(.horizontal)

                // TextEditor
                TextEditor(text: $content)
                    .padding(25)
                    .foregroundColor(Color(red: 0.37, green: 0.25, blue: 0.5))
                    .font(.system(size: 20))
                    .background(Color.clear) // Ensure the TextEditor background is clear so the ZStack background shows through
                    .cornerRadius(40)
            }
            .padding(.horizontal)

            // Save Entry Button
            Button(action: {
                createJournalEntry(title: title, content: content) // Call the function to save the entry
            }) {
                Text("Save Entry")
                    .font(.system(size: 20, weight: .bold))
                    .padding()
                    .frame(maxWidth: .infinity) // Make the button fill the width of the screen
                    .background(Color(red: 0.64, green: 0.53, blue: 0.79)) // Purple background color for button
                    .foregroundColor(.white) // White text color
                    .cornerRadius(40) // Rounded corners
                    .padding(.horizontal) // Horizontal padding for space on the sides
            }
            .padding(.bottom, 30) // Add some space at the bottom of the button
        }
        .background(Color(red: 0.94, green: 0.92, blue: 0.98).edgesIgnoringSafeArea(.all)) // Background to remove white space
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }

    // Function to send the journal entry to the Flask backend
    func createJournalEntry(title: String, content: String) {
        guard let url = URL(string: "https://flask-app-91222939065.us-east1.run.app/createJournalEntry") else { return }
        

        let bearerToken = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjI4YTQyMWNhZmJlM2RkODg5MjcxZGY5MDBmNGJiZjE2ZGI1YzI0ZDQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIzMjU1NTk0MDU1OS5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsImF1ZCI6IjMyNTU1OTQwNTU5LmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwic3ViIjoiMTAxMTcwMzIwOTMzMjQwMzYwOTMwIiwiaGQiOiJjb3JuZWxsLmVkdSIsImVtYWlsIjoiY2RjMjM2QGNvcm5lbGwuZWR1IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJuSUkxWGNncDdDRDR1ZmpjalpfZUN3IiwiaWF0IjoxNzI4MjA2NTk4LCJleHAiOjE3MjgyMTAxOTh9.lmRYurPjfwYaXznjjn5YUYuxs9deND3mlmsSRd6qe_mEtL13pZDmdqyiebzGYx14HjCZvzhohQoeYGlxIQEYsdFfYmLVFZZ38t6FVXSP3B1z5Fixe51NutrSgjOyoclOwbv329xDvrSNXGtcJ3HOP6XvzkQPNoHRM8VhL9VZbbdfD-k7w8dUJuR4wbeqDLKc9wTGJx56stFPsYzDqxTt4YdQjWoHoL8C1B-zPQpD6v8KcIkH2364nsPh1K-wwbTcIlLm9NnYRaNHZBAoglE2bubikmldpLAse9j0SxKJ4-FTrPoj6h2qXGH84uA_s03eCHRgdaNjD_YumHS8383kRA"
        
        // Get the current date and time
        let currentDate = Date()
        let dateFormatter = ISO8601DateFormatter() // Using ISO 8601 format
        let formattedDate = dateFormatter.string(from: currentDate)
        
        let entryData: [String: Any] = [
            "title": title,
            "content": content,
            "date": formattedDate
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        // Convert the dictionary to JSON data
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: entryData, options: .prettyPrinted)
        } catch let error {
            print("Failed to serialize entry data:", error)
            return
        }
        
        // Send the request using URLSession
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending request:", error)
                return
            }
            
            guard let data = data else {
                print("No data in response")
                return
            }
            
            // Handle the response here (optional)
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response from server: \(responseString)")
            }
        }
        
        task.resume() // Start the network task
    }
}
