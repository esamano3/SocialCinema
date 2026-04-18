//
//  ReviewLibraryView.swift
//  SocialCinema
//
//  Created by Joseph Loveall (Student) on 4/18/26.
//

import SwiftUI
import FirebaseAuth

struct ReviewLibraryView: View {
    @StateObject private var reviewsViewModel = ReviewsViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if reviewsViewModel.isLoading {
                    ProgressView("Loading your reviews...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if !reviewsViewModel.errorMessage.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 40))

                        Text("Could not load reviews")
                            .font(.title3)
                            .fontWeight(.semibold)

                        Text(reviewsViewModel.errorMessage)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)

                        Button("Try Again") {
                            reviewsViewModel.loadReviewsForCurrentUser()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                } else if reviewsViewModel.reviews.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "books.vertical")
                            .font(.system(size: 48))

                        Text("Review Library")
                            .font(.title2)
                            .fontWeight(.semibold)

                        Text("You have not written any reviews yet.")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        if let email = Auth.auth().currentUser?.email {
                            Section("Account") {
                                Text(email)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Section("My Reviews") {
                            ForEach(reviewsViewModel.reviews) { review in
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(alignment: .top) {
                                        Text(review.movieTitle)
                                            .font(.headline)

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
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Library")
            .onAppear {
                reviewsViewModel.loadReviewsForCurrentUser()
            }
        }
    }
}

#Preview {
    ReviewLibraryView()
}
