//
//  JournalEntryView.swift
//  Unwind
//
//  Created by Jesse Cheng on 10/5/24.
//

import Foundation

import SwiftUI

struct JournalEntryView: View {
    @State private var title: String = ""
    @State private var content: String = ""

    var body: some View {
        VStack {
            TextField("Title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextEditor(text: $content)
                .frame(minHeight: 300)
                .padding(.horizontal)
                .border(Color.gray, width: 1)

            Spacer()

            Button("Save Entry") {
                createJournalEntry(title: title, content: content)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .navigationTitle("New Journal Entry")
        .padding()
        
    }
    
    // Function to send the journal entry to the Flask backend
    func createJournalEntry(title: String, content: String) {
        guard let url = URL(string: "https://flask-app-91222939065.us-east1.run.app/createJournalEntry") else { return }
        
        let bearerToken = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjI4YTQyMWNhZmJlM2RkODg5MjcxZGY5MDBmNGJiZjE2ZGI1YzI0ZDQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIzMjU1NTk0MDU1OS5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsImF1ZCI6IjMyNTU1OTQwNTU5LmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwic3ViIjoiMTAxMTcwMzIwOTMzMjQwMzYwOTMwIiwiaGQiOiJjb3JuZWxsLmVkdSIsImVtYWlsIjoiY2RjMjM2QGNvcm5lbGwuZWR1IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiIwczVVbGxOSXZfWHhRcC1rMElRM2JnIiwiaWF0IjoxNzI4MTgyMDU0LCJleHAiOjE3MjgxODU2NTR9.upiRN1Yt7WaYjk4R-MHyVSPGvaZEWpqa775kaXpFQwBYaEmen1c09RTBBQ1gZ5EOX5PmujR6TFjgkyBHqURUy4Ibm5hXtoXUeEo2ptaszC66kE9UbnXbRuYznOd6POFqrXDUBJPWoN7Y00-jLUx3rZlmK-rrHIuDBLEQ1iHLYl1pxZ9ZKuGmrIdB20rJ9Yd9qXYv2xjUU2iZks_b1qPmy3Qi6iupBEwV0rDyk8ba43DqB7xPfbwj3abqKGwwGcSw8DylvGjNcHQnbGUFaYJzL_mfnPaYyJvACwXJ6w1tvcxLIYhfUGoDri8Aw8hFeSONggIjeRqHryZ0dfyTFlzbUA"
        
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
