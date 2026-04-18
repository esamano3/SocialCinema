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
    @StateObject private var reviewsViewModel = ReviewsViewModel()

    @State private var manualLocation: String = ""

    private var activeLocation: String {
        let trimmedManual = manualLocation.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedManual.isEmpty ? locationManager.locationName : trimmedManual
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                movieHeaderSection
                Divider()
                reviewComposerSection
                Divider()
                reviewsListSection
                Divider()
                locationSection
                Divider()
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

            reviewsViewModel.loadReviews(for: movie.id)
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
            
            // movie image / poster
            if let posterPath: String = movie.posterPath {
                // base_url + size + poster_path
                let posterURL: String = "https://image.tmdb.org/t/p/" + "w342" + posterPath
                AsyncImage(url: URL(string: posterURL)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 200, height: 200)
            }
            

            Text("Overview")
                .font(.headline)

            Text(movie.overview.isEmpty ? "No overview available." : movie.overview)
                .font(.body)
        }
    }

    private var reviewComposerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Write a Review")
                .font(.title3)
                .fontWeight(.semibold)

            Text("Rating")
                .font(.subheadline)
                .fontWeight(.medium)

            Picker("Rating", selection: $reviewsViewModel.rating) {
                ForEach(1...5, id: \.self) { value in
                    Text("\(value) Star\(value == 1 ? "" : "s")").tag(value)
                }
            }
            .pickerStyle(.segmented)

            Text("Your Review")
                .font(.subheadline)
                .fontWeight(.medium)

            TextEditor(text: $reviewsViewModel.reviewText)
                .frame(minHeight: 120)
                .padding(8)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            if !reviewsViewModel.errorMessage.isEmpty {
                Text(reviewsViewModel.errorMessage)
                    .foregroundStyle(.red)
                    .font(.footnote)
            }

            Button("Submit Review") {
                reviewsViewModel.submitReview(for: movie.id, movieTitle: movie.title)
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private var reviewsListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Reviews")
                .font(.headline)

            if reviewsViewModel.isLoading {
                ProgressView("Loading reviews...")
            } else if reviewsViewModel.reviews.isEmpty {
                Text("No reviews yet for this movie.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            } else {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(reviewsViewModel.reviews) { review in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(review.userEmail)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)

                                Spacer()

                                Text(String(repeating: "★", count: review.rating))
                                    .foregroundStyle(.yellow)
                            }

                            Text(review.reviewText)
                                .font(.body)

                            Text(review.createdAt.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
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
                LazyVStack(alignment: .leading, spacing: 14) {
                    ForEach(showtimesViewModel.theaters) { theater in
                        VStack(alignment: .leading, spacing: 10) {
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

                            Divider()

                            ForEach(theater.showing, id: \.self) { showing in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(showing.type)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)

                                    ForEach(showing.time, id: \.self) { time in
                                        NavigationLink {
                                            TheaterMapView(
                                                theater: theater,
                                                showType: showing.type,
                                                selectedTime: time
                                            )
                                        } label: {
                                            HStack {
                                                Image(systemName: "mappin.and.ellipse")
                                                Text(time)
                                                Spacer()
                                                Image(systemName: "chevron.right")
                                                    .font(.caption)
                                                    .foregroundStyle(.secondary)
                                            }
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 10)
                                            .background(Color(.systemGray6))
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
            } else if !showtimesViewModel.isLoading && showtimesViewModel.errorMessage == nil {
                Text("Load showtimes for this movie to see nearby theaters.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    NavigationStack {
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
}
