//
//  FriendsListView.swift
//  SocialCinema
//
//  Created by Evan Samano on 3/21/26.
//

import SwiftUI

struct FriendsListView: View {
    @Binding var path: NavigationPath

    @State private var friends: [FriendUser] = [
        FriendUser(
            name: "Evan Samano",
            email: "evan@example.com",
            favoriteMovie: "Inception",
            reviews: [
                FriendMovieReview(movieTitle: "Inception", rating: 5, reviewText: "Still one of my all-time favorites."),
                FriendMovieReview(movieTitle: "Interstellar", rating: 5, reviewText: "Amazing visuals and story.")
            ]
        ),
        FriendUser(
            name: "Mia Chen",
            email: "mia@example.com",
            favoriteMovie: "La La Land",
            reviews: [
                FriendMovieReview(movieTitle: "La La Land", rating: 4, reviewText: "Beautiful soundtrack and style."),
                FriendMovieReview(movieTitle: "Dune", rating: 5, reviewText: "Huge scale and very immersive.")
            ]
        )
    ]

    @State private var newFriendName: String = ""
    @State private var newFriendEmail: String = ""

    var body: some View {
        VStack(spacing: 16) {
            addFriendSection

            if friends.isEmpty {
                Spacer()

                VStack(spacing: 12) {
                    Image(systemName: "person.2")
                        .font(.system(size: 42))

                    Text("No friends yet")
                        .font(.title3)
                        .fontWeight(.semibold)

                    Text("Add a friend to start building your SocialCinema circle.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                }

                Spacer()
            } else {
                List {
                    Section("My Friends") {
                        ForEach(friends) { friend in
                            NavigationLink(value: friend) {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(friend.name)
                                        .font(.headline)

                                    Text(friend.email)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)

                                    Text("Favorite Movie: \(friend.favoriteMovie)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .onDelete(perform: deleteFriend)
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("Friends")
    }

    private var addFriendSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Add Friend")
                .font(.headline)

            TextField("Friend name", text: $newFriendName)
                .textFieldStyle(.roundedBorder)

            TextField("Friend email", text: $newFriendEmail)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

            Button("Add Friend") {
                addFriend()
            }
            .buttonStyle(.borderedProminent)
            .disabled(
                newFriendName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                newFriendEmail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            )
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal)
    }

    private func addFriend() {
        let trimmedName = newFriendName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = newFriendEmail.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty, !trimmedEmail.isEmpty else { return }

        let friend = FriendUser(
            name: trimmedName,
            email: trimmedEmail,
            favoriteMovie: "Unknown",
            reviews: []
        )

        friends.append(friend)
        newFriendName = ""
        newFriendEmail = ""
    }

    private func deleteFriend(at offsets: IndexSet) {
        friends.remove(atOffsets: offsets)
    }
}

#Preview {
    NavigationStack {
        FriendsListView(path: .constant(NavigationPath()))
    }
}
