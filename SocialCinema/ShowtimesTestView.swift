//
//  ShowtimesTestView.swift
//  SocialCinema
//
//  Created by Joseph Loveall (Student) on 4/17/26.
//

import SwiftUI

struct ShowtimesTestView: View {
    @StateObject private var locationManager = LocationManager()
    
    @State private var theaters: [Theater] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var manualLocation = ""
    
    private let showtimesService = ShowtimesAPIService()
    private let testMovieTitle = "Project Hail Mary"
    
    var activeLocation: String {
        let trimmedManual = manualLocation.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedManual.isEmpty ? locationManager.locationName : trimmedManual
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Showtimes Test")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Movie: \(testMovieTitle)")
                    .font(.headline)
                
                Text("Current Location: \(locationManager.locationName)")
                    .foregroundStyle(.secondary)
                
                TextField("Enter location manually (ex: Tempe, AZ)", text: $manualLocation)
                    .textFieldStyle(.roundedBorder)
                
                Text("Using Location: \(activeLocation)")
                    .font(.subheadline)
                
                if let location = locationManager.location {
                    Text("Lat: \(location.coordinate.latitude)")
                    Text("Lon: \(location.coordinate.longitude)")
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                }
                
                HStack {
                    Button("Use Current Location") {
                        locationManager.requestPermission()
                        locationManager.startUpdatingLocation()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Load Showtimes") {
                        loadShowtimes()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(activeLocation.isEmpty)
                }
                
                if isLoading {
                    ProgressView("Loading showtimes...")
                }
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .font(.footnote)
                        .padding(.horizontal)
                }
                
                List(theaters) { theater in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(theater.name)
                            .font(.headline)
                        
                        Text(theater.address)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        if let distance = theater.distance {
                            Text("Distance: \(distance)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        ForEach(theater.showing, id: \.self) { show in
                            Text("\(show.type): \(show.time.joined(separator: ", "))")
                                .font(.caption)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .listStyle(.plain)
            }
            .padding()
            .navigationTitle("Nearby Theaters")
        }
    }
    
    private func loadShowtimes() {
        guard !activeLocation.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        theaters = []
        
        showtimesService.fetchShowtimes(movieTitle: testMovieTitle, location: activeLocation) { result in
            isLoading = false
            
            switch result {
            case .success(let theaters):
                self.theaters = theaters
            case .failure(let error):
                self.theaters = []
                self.errorMessage = error.localizedDescription
            }
        }
    }
}

#Preview {
    ShowtimesTestView()
}
