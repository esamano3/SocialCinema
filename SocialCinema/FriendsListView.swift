//
//  FriendsListView.swift
//  SocialCinema
//
//  Created by Evan Samano on 3/21/26.
//

import SwiftUI

struct FriendsListView: View {
    @Binding var path: NavigationPath

    @StateObject private var friendsViewModel = FriendsViewModel()

    var body: some View {
        VStack(spacing: 16) {
            addFriendSection

            if !friendsViewModel.incomingRequests.isEmpty {
                incomingRequestsSection
            }

            if friendsViewModel.isLoading {
                Spacer()
                ProgressView("Loading friends...")
                Spacer()
            } else if !friendsViewModel.errorMessage.isEmpty && friendsViewModel.friends.isEmpty {
                Spacer()
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 40))

                    Text("Could not load friends")
                        .font(.title3)
                        .fontWeight(.semibold)

                    Text(friendsViewModel.errorMessage)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)

                    Button("Try Again") {
                        friendsViewModel.loadFriends()
                        friendsViewModel.loadIncomingRequests()
                    }
                    .buttonStyle(.borderedProminent)
                }
                Spacer()
            } else if friendsViewModel.friends.isEmpty {
                Spacer()

                VStack(spacing: 12) {
                    Image(systemName: "person.2")
                        .font(.system(size: 42))

                    Text("No friends yet")
                        .font(.title3)
                        .fontWeight(.semibold)

                    Text("Search by email and send someone a friend request.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                }

                Spacer()
            } else {
                List {
                    Section("My Friends") {
                        ForEach(friendsViewModel.friends) { friend in
                            NavigationLink(value: friend) {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(friend.displayName)
                                        .font(.headline)

                                    Text(friend.email)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.vertical, 4)
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    friendsViewModel.removeFriend(friend)
                                } label: {
                                    Label("Remove", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("Friends")
        .navigationDestination(for: AppUser.self) { friend in
            FriendProfileView(friend: friend)
        }
        .onAppear {
            friendsViewModel.loadFriends()
            friendsViewModel.loadIncomingRequests()
        }
    }

    private var addFriendSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Send Friend Request")
                .font(.headline)

            TextField("Enter friend email", text: $friendsViewModel.newFriendEmail)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

            Button("Search User") {
                friendsViewModel.searchUsers()
            }
            .buttonStyle(.bordered)

            if !friendsViewModel.availableUsers.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Search Results")
                        .font(.subheadline)
                        .fontWeight(.semibold)

                    ForEach(friendsViewModel.availableUsers) { user in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.displayName)
                                    .font(.headline)

                                Text(user.email)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Button("Send Request") {
                                friendsViewModel.sendFriendRequest(to: user)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }

            if !friendsViewModel.errorMessage.isEmpty {
                Text(friendsViewModel.errorMessage)
                    .foregroundStyle(.red)
                    .font(.footnote)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal)
    }

    private var incomingRequestsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Incoming Requests")
                .font(.headline)
                .padding(.horizontal)

            ForEach(friendsViewModel.incomingRequests) { request in
                VStack(alignment: .leading, spacing: 10) {
                    Text(request.fromDisplayName)
                        .font(.headline)

                    Text(request.fromEmail)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    HStack {
                        Button("Accept") {
                            friendsViewModel.acceptRequest(request)
                        }
                        .buttonStyle(.borderedProminent)

                        Button("Decline") {
                            friendsViewModel.declineRequest(request)
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    NavigationStack {
        FriendsListView(path: .constant(NavigationPath()))
    }
}
