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
        
        let bearerToken = "<insert_token_here>"
        
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
