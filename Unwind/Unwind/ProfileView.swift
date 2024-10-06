import Foundation
import SwiftUI

struct ProfileView: View {
    var profileImage: String = "profile" // Replace with your image asset name
    var name: String = "Dean Bala" // Replace with dynamic name if needed
    var bio: String = "Unspooling since October 2024."
    var additionalImage: String = "cat" // New image asset below boxes
    
    var body: some View {
        VStack {
            // Profile Picture
            Image(profileImage)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150) // Increased size
                .clipShape(Circle())
                .padding()
            
            // Name
            Text(name)
                .font(.system(size: 36, weight: .bold)) // Increased font size
                .padding()
            
            // Bio
            Text(bio)
                .font(.system(size: 24)) // Increased font size
                .multilineTextAlignment(.center)
                .padding()
            
            // Check-ins and Journal Entries Boxes
            HStack(spacing: 20) {
                // Box for Journal Entries
                VStack {
                    Text("5") // Replace with actual data
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .offset(y:8)
                    
                    Text("Journal Entries")
                        .font(.headline)
                        .padding(.top, 10)
                        .offset(y:-15)
                }
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                
                // Box for Check-ins
                VStack {
                    Text("26") // Replace with actual data
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .offset(y:8)
                    
                    Text("Check-ins")
                        .font(.headline)
                        .padding(.top, 10)
                        .offset(y:-15)
                }
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            }
            .padding() // Add padding around the boxes
            
            // Additional Image below the boxes
            Image(additionalImage)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .clipShape(Circle())
                .padding()
            
            Spacer() // Push content upwards
        }
        .navigationTitle("Profile")
        .padding()
    }
}
