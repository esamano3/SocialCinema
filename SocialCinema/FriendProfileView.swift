//
//  FriendProfileView.swift
//  SocialCinema
//
//  Created by Joseph Loveall (Student) on 4/18/26.
//

import SwiftUI

struct FriendProfileView: View {
    let friend: FriendUser

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(friend.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text(friend.email)
                        .foregroundStyle(.secondary)

                    Text("Favorite Movie: \(friend.favoriteMovie)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Divider()

                VStack(alignment: .leading, spacing: 12) {
                    Text("Reviews")
                        .font(.title3)
                        .fontWeight(.semibold)

                    if friend.reviews.isEmpty {
                        Text("This friend has not posted any reviews yet.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(friend.reviews) { review in
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
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Friend Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        FriendProfileView(
            friend: FriendUser(
                name: "Evan Samano",
                email: "evan@example.com",
                favoriteMovie: "Inception",
                reviews: [
                    FriendMovieReview(movieTitle: "Inception", rating: 5, reviewText: "Still one of my all-time favorites.")
                ]
            )
        )
    }
}
