import Foundation
import SwiftUI

struct SummaryView: View {
    @State private var selectedOption: String = "Month" // Default to Month
    @State private var numbers: [Int] = [] // Array to hold numbers from the backend
    
    // Array of SVG asset names (replace with your actual asset names)
    let svgAssets = ["feeling1", "feeling2", "feeling3", "feeling4", "feeling5"]

    var body: some View {
        VStack(spacing: 10) { // Adjusted spacing
            // Title at the top
            Text("Summary")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 10) // Reduced padding here

            // Box containing buttons for Month and Week selection
            HStack {
                Button(action: {
                    selectedOption = "Week"
                }) {
                    Text("Week")
                        .padding()
                        .frame(maxWidth: .infinity) // Make the button stretch to fill space
                        .background(selectedOption == "Week" ? Color(red: 0.6, green: 0.45, blue: 0.76) : Color(red:0.78, green:0.68, blue:0.91))
                        .foregroundColor(selectedOption == "Week" ? Color.white : Color(red: 0.49, green: 0.36, blue: 0.63))
                        .cornerRadius(8)
                }

                Button(action: {
                    selectedOption = "Month"
                }) {
                    Text("Month")
                        .padding()
                        .frame(maxWidth: .infinity) // Make the button stretch to fill space
                        .background(selectedOption == "Month" ? Color(red: 0.6, green: 0.45, blue: 0.76) : Color(red:0.78, green:0.68, blue:0.91))
                        .foregroundColor(selectedOption == "Month" ? Color.white : Color(red: 0.49, green: 0.36, blue: 0.63))
                        .cornerRadius(8)
                }
            }
            .padding()

            // Grid to display SVGs and labels
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 5), spacing: 16) {
                ForEach(numbers.indices, id: \.self) { index in
                    VStack {
                        // Display the SVG asset
                        Image(svgAssets[index]) // Load the SVG asset
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 50) // Adjust height as needed
                            .cornerRadius(8)

                        // Label for each number
                        Text("\(numbers[index])")
                            .font(.headline)
                            .padding(.top, 5)
                    }
                }
            }
            .padding(.top, 20)

            // Box displaying "This week you made:"
            VStack(alignment: .center) { // Change alignment to center
                Text("This week you made:")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)

                HStack(spacing: 20) {
                    // Box for Journal Entries
                    VStack {
                        // Larger number above the text
                        Text("5") // Replace with actual data
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .offset(y:8)
                            .foregroundColor(.white)


                        Text("Journal Entries")
                            .font(.headline)
                            .padding(.top, 10) // Increased padding here
                            .offset(y:-15)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity) // Make the box stretch to fill space
                    .background(Color(red: 0.67, green: 0.56, blue: 0.8)) // Background for the box
                    .cornerRadius(8)

                    // Box for Check-ins
                    VStack {
                        // Larger number above the text
                        Text("26") // Replace with actual data
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .offset(y:8)
                            .foregroundColor(.white)


                        Text("Check-ins")
                            .font(.headline)
                            .padding(.top, 10) // Increased padding here
                            .offset(y:-15)
                            .foregroundColor(.white)

                    }
                    .frame(maxWidth: .infinity) // Make the box stretch to fill space
                    .background(Color(red: 0.67, green: 0.56, blue: 0.8)) // Background for the box
                    .cornerRadius(8)
                }
                .padding(.top, 10)
            }
            .padding()

            // All-time Summary section
            VStack(alignment: .leading) {
                Text("All-time Summary")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                    .offset(x: 70)

                HStack {
                    // Image placeholder
                    Image("cat") // Replace with your image asset name
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100) // Adjust size as needed
                        .cornerRadius(8)

                    // Text description
                    Text("Check out the feelings blanket I made for you!")
                        .font(.headline)
                        .padding()
                        .foregroundColor(Color(red: 0.54, green: 0.45, blue: 0.65))
                        .background(Color(red: 0.94, green: 0.92, blue: 0.98)) // Different colored background
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .padding(.horizontal) // Keeping horizontal padding while reducing vertical
        .onAppear {
            // Simulating a backend call to fetch numbers
            fetchNumbersFromBackend()
        }
    }

    // Simulated function to fetch numbers from the backend
    private func fetchNumbersFromBackend() {
        // Here, you'd typically make your network request to fetch the data
        // For now, we'll simulate it with some hard-coded values
        numbers = [2, 4, 3, 7, 10] // Example numbers fetched from the backend
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView()
    }
}
