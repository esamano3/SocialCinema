//
//  MovieDetailsView.swift
//  SocialCinema
//
//  Created by Evan Samano on 3/21/26.
//

import SwiftUI

struct MovieDetailsView: View {
    @Binding var path: NavigationPath
    let movie: Movie

    @StateObject private var locationManager = LocationManager()
    @StateObject private var showtimesViewModel = MovieShowtimesViewModel()

    @State private var manualLocation: String = ""

    private var activeLocation: String {
        let trimmedManual = manualLocation.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedManual.isEmpty ? locationManager.locationName : trimmedManual
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                movieHeaderSection
                divider
                locationSection
                divider
                showtimesSection
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationTitle("Movie Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if locationManager.authorizationStatus == .notDetermined {
                locationManager.requestPermission()
            }
        }
    }

    private var movieHeaderSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(movie.title)
                .font(.title)
                .fontWeight(.bold)

            if let releaseDate = movie.releaseDate, !releaseDate.isEmpty {
                Text("Release Date: \(releaseDate)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Text("Overview")
                .font(.headline)

            Text(movie.overview.isEmpty ? "No overview available." : movie.overview)
                .font(.body)
        }
    }

    private var locationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Find Nearby Showtimes")
                .font(.title3)
                .fontWeight(.semibold)

            Text("Current Location: \(locationManager.locationName.isEmpty ? "Not set yet" : locationManager.locationName)")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            TextField("Enter location manually (ex: Tempe, AZ)", text: $manualLocation)
                .textFieldStyle(.roundedBorder)

            Text("Using Location: \(activeLocation.isEmpty ? "None selected" : activeLocation)")
                .font(.subheadline)

            if let location = locationManager.location {
                Text("Lat: \(location.coordinate.latitude)")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text("Lon: \(location.coordinate.longitude)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            HStack {
                Button("Use Current Location") {
                    locationManager.requestPermission()
                    locationManager.startUpdatingLocation()
                }
                .buttonStyle(.bordered)

                Button("Load Showtimes") {
                    showtimesViewModel.loadShowtimes(for: movie.title, location: activeLocation)
                }
                .buttonStyle(.borderedProminent)
                .disabled(activeLocation.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
    }

    private var showtimesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Nearby Theaters")
                .font(.headline)

            if showtimesViewModel.isLoading {
                ProgressView("Loading showtimes...")
            }

            if let errorMessage = showtimesViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .font(.footnote)
            }

            if !showtimesViewModel.theaters.isEmpty {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(showtimesViewModel.theaters) { theater in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(theater.name)
                                .font(.headline)

                            Text(theater.address)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            if let distance = theater.distance, !distance.isEmpty {
                                Text("Distance: \(distance)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            ForEach(theater.showing, id: \.self) { show in
                                Text("\(show.type): \(show.time.joined(separator: ", "))")
                                    .font(.caption)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            } else if !showtimesViewModel.isLoading && showtimesViewModel.errorMessage == nil {
                Text("Load showtimes for this movie to see nearby theaters.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var divider: some View {
        Divider()
    }
}

#Preview {
    MovieDetailsView(
        path: .constant(NavigationPath()),
        movie: Movie(
            id: 27205,
            title: "Inception",
            overview: "Cobb, a skilled thief who commits corporate espionage by infiltrating the subconscious of his targets is offered a chance to regain his old life.",
            posterPath: "/xlaY2zyzMfkhk0HSC5VUwzoZPU1.jpg",
            releaseDate: "2010-07-15"
        )
    )
}
