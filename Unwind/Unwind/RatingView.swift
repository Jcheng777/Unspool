//
//  MoodView.swift
//  Unwind
//
//  Created by Jesse Cheng on 10/5/24.
//

import Foundation

import SwiftUI

struct RatingView: View {
    @State private var selectedMood: Double = 1 // Slider value (1 to 5)
    @State private var moodImages: [String] = [
        "feeling1",   // Replace with your actual SVG asset names
        "feeling2",
        "feeling3",
        "feeling4",
        "feeling5"
    ]

    var body: some View {
        VStack {
            Text("How are you feeling?")
                .font(.largeTitle)
                .padding()

            // Display the corresponding SVG based on the slider value
            Image(moodImages[Int(selectedMood) - 1]) // Assuming the images are named correctly
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100) // Adjust size as needed
                .padding()

            // Slider for mood rating
            Slider(value: $selectedMood, in: 1...5, step: 1)
                .padding()

            // Button to submit mood rating
            Button(action: {
                submitMoodRating(moodRating: Int(selectedMood))
            }) {
                Text("Check-in")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
        }
        .padding()
    }

    // Function to submit mood rating to backend
    func submitMoodRating(moodRating: Int) {
        let url = URL(string: "https://flask-app-91222939065.us-east1.run.app/createFeelingsEntry")! // Replace with your actual backend URL
        
        let bearerToken = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjI4YTQyMWNhZmJlM2RkODg5MjcxZGY5MDBmNGJiZjE2ZGI1YzI0ZDQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIzMjU1NTk0MDU1OS5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsImF1ZCI6IjMyNTU1OTQwNTU5LmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwic3ViIjoiMTAxMTcwMzIwOTMzMjQwMzYwOTMwIiwiaGQiOiJjb3JuZWxsLmVkdSIsImVtYWlsIjoiY2RjMjM2QGNvcm5lbGwuZWR1IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJvNmVLSmlQUnl1ZGFMMGphN3FTaXJnIiwiaWF0IjoxNzI4MjA3OTU2LCJleHAiOjE3MjgyMTE1NTZ9.tJ8AmOqOaIAD5EOsW18OclTxbsTsQdpQg8qPRoLKhDGQkIBVzUzOki-2crBUkXSYwLEDCTgAUCX6mmjj7f02dhnxgz1nMpmL7dvxNDP71sPY73RrNRdPtWZO6zr8Rb8Wwul-jBRVWe3mC4xK065RlguQ5a94XX-2BeR2WMI6xZe1bdfP_eJtMggtFsoNseEPLyv7Tbl37EXm89WGIYA19S3pEoe3J7jpyVDmBWe13ANr6_18_UvbZSnE3bZqHbwUipqCBxvbCD7gb7BihTTwtpIwWxW5qjVfH45kGCDVJu0lpYACyvZGvVZTJoxYh2paRMY8ZdRGSo0TXE1QUxIoSg" // Use your actual bearer token
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")


        let body: [String: Int] = ["moodRating": moodRating]
        let jsonData = try? JSONSerialization.data(withJSONObject: body)

        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error occurred: \(error)")
                return
            }
            
            if let data = data {
                // Handle response if needed
                print("Response data: \(String(data: data, encoding: .utf8) ?? "")")
            }
        }.resume()
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView()
    }
}

