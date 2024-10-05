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
        
        let bearerToken = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjI4YTQyMWNhZmJlM2RkODg5MjcxZGY5MDBmNGJiZjE2ZGI1YzI0ZDQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIzMjU1NTk0MDU1OS5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsImF1ZCI6IjMyNTU1OTQwNTU5LmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwic3ViIjoiMTAxMTcwMzIwOTMzMjQwMzYwOTMwIiwiaGQiOiJjb3JuZWxsLmVkdSIsImVtYWlsIjoiY2RjMjM2QGNvcm5lbGwuZWR1IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJWNk84WHo1VDNYRTA4em1Dc09fZHpnIiwiaWF0IjoxNzI4MTcxNTgwLCJleHAiOjE3MjgxNzUxODB9.RNcmq20VXrlD-CAJ2pJquV833GunWuprng2MFeWzEppiaYtv2vQxf1fxNx1NvW8OW6mUv8a_8v4wZfdYi1EkAtKCjfTHAZ1ZmuMQeWORLs2ojmkAZEArN3Pqy9-Ry3ROY-7Jfb1CUMXvr0dvlumqABd8LDghg29kZMvlvvU17dHTSXWZ8DhctDjf7s1Y3940njeyo4UwvuMPSmDzewx2Se3uq6l-uRtoHEF1ZV4QfllHeQBk26k-L06u6o241HZGFpEZXuf7J_H59MfLK821QDTfrVEdC0wj1vvSr8Eg4EoKAcclR-qXftBEGUu30OlMfYdnnsNobEzQ9gUae5Ao-w"
        
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
