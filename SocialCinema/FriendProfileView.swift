//
//  FriendProfileView.swift
//  SocialCinema
//
//  Created by Joseph Loveall (Student) on 4/18/26.
//

import SwiftUI
import FirebaseFirestore

struct FriendProfileView: View {
    let friend: AppUser

    @StateObject private var reviewsViewModel = ReviewsViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                profileHeaderSection
                Divider()
                reviewsSection
            }
            .padding()
        }
        .navigationTitle("Friend Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            reviewsViewModel.loadReviews(forUserEmail: friend.email)
        }
    }

    private var profileHeaderSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(friend.displayName)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(friend.email)
                .foregroundStyle(.secondary)

            Text("Joined \(friend.createdAt.formatted(date: .abbreviated, time: .omitted))")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var reviewsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Reviews")
                .font(.title3)
                .fontWeight(.semibold)

            if reviewsViewModel.isLoading {
                ProgressView("Loading reviews...")
            } else if !reviewsViewModel.errorMessage.isEmpty {
                Text(reviewsViewModel.errorMessage)
                    .foregroundStyle(.red)
                    .font(.footnote)
            } else if reviewsViewModel.reviews.isEmpty {
                Text("This friend has not posted any reviews yet.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(reviewsViewModel.reviews) { review in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
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
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        FriendProfileView(
            friend: AppUser(
                id: "preview",
                email: "friend@example.com",
                displayName: "Preview Friend"
            )
        )
    }
}
