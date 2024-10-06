import SwiftUI
import Foundation

struct JournalEntryView: View {
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var fullText: String = "Start writing about your day here..."
    
    var body: some View {
        VStack(spacing: 20) {
            
            // Title Field
            TextField("Title...", text: $title)
                .padding(20)
                .foregroundColor(Color(red: 0.37, green: 0.25, blue: 0.5))
                .font(.system(size: 28, weight: .bold))
                .background(Color(red: 0.94, green: 0.92, blue: 0.98))
                .cornerRadius(28)
                .padding(.horizontal)
                .offset(y:10)
            
            TextEditor(text: $fullText)
                .padding(5)
                .foregroundColor(Color.gray)
                .foregroundColor(Color(red: 0.37, green: 0.25, blue: 0.5))
                .font(.system(size: 18, weight: .bold))
                .cornerRadius(32)
                .padding(.horizontal)
        }
        .padding(.horizontal)
        
        //            // TextEditor with Purple Background
        //            ZStack(alignment: .topLeading) {
        //                // Purple background
        //                Color(red: 0.74, green: 0.64, blue: 0.94) // A soft purple background color
        //                    .cornerRadius(40) // Rounded corners
        //                    .padding(.horizontal)
        
        // TextEditor
        
        
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

// Function to send the journal entry to the Flask backend
func createJournalEntry(title: String, content: String) {
    guard let url = URL(string: "https://flask-app-91222939065.us-east1.run.app/createJournalEntry") else { return }
    
    
    let bearerToken = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjI4YTQyMWNhZmJlM2RkODg5MjcxZGY5MDBmNGJiZjE2ZGI1YzI0ZDQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIzMjU1NTk0MDU1OS5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsImF1ZCI6IjMyNTU1OTQwNTU5LmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwic3ViIjoiMTAxMTcwMzIwOTMzMjQwMzYwOTMwIiwiaGQiOiJjb3JuZWxsLmVkdSIsImVtYWlsIjoiY2RjMjM2QGNvcm5lbGwuZWR1IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJBYkExMkN1UHE5SWQ3RlpNUkNuUWhBIiwiaWF0IjoxNzI4MjEyMDA0LCJleHAiOjE3MjgyMTU2MDR9.0NDYjczTAdRHENNAGwu-It4zeX-PXNIFHc8vJYrz55GlWCvNeoblsPjVSlzhenW9IKafrNeVUmsKcRMaNgJzOE5f_LNMIGtOyzbIKImgUBgNCwfURVnL5qyCzH3mZ1oPuxNUngAvc-7uU5Sr2p3R8Z4Pkm2EpNDmTDLAO65EwOY1bNJA4tSc-Ou_mzzuDLLOD7Z7ocUCq9I_6EC-SY0taTU7nf0C0neU2SPtDDcxiZGKJa5QLNaKnQwbzziU47c-C5nj4jZAbSn_yYt1P4GJZTrC_cNyaqHamme7QC1Iot3BpVng4p9DTJRWuespmQjVLf99xBWxZkL_53G421SdYw"
    
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
