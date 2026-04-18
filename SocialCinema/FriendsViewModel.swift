//
//  FriendsViewModel.swift
//  SocialCinema
//
//  Created by Joseph Loveall (Student) on 4/18/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
class FriendsViewModel: ObservableObject {
    @Published var friends: [AppUser] = []
    @Published var availableUsers: [AppUser] = []
    @Published var incomingRequests: [FriendRequest] = []
    @Published var newFriendEmail: String = ""
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false

    private let db = Firestore.firestore()

    func loadFriends() {
        guard let currentUser = Auth.auth().currentUser,
              let currentEmail = currentUser.email else {
            errorMessage = "You must be logged in to load friends."
            friends = []
            return
        }

        isLoading = true
        errorMessage = ""

        db.collection("friends")
            .whereField("ownerEmail", isEqualTo: currentEmail)
            .order(by: "friendEmail")
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                    self.friends = []
                    return
                }

                let friendEmails = snapshot?.documents.compactMap { $0.data()["friendEmail"] as? String } ?? []

                if friendEmails.isEmpty {
                    self.isLoading = false
                    self.friends = []
                    return
                }

                self.loadUserProfiles(for: friendEmails)
            }
    }

    func loadIncomingRequests() {
        guard let currentEmail = Auth.auth().currentUser?.email else {
            errorMessage = "You must be logged in to load friend requests."
            incomingRequests = []
            return
        }

        db.collection("friendRequests")
            .whereField("toEmail", isEqualTo: currentEmail)
            .whereField("status", isEqualTo: "pending")
            .order(by: "createdAt", descending: true)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.incomingRequests = []
                    return
                }

                let requests = snapshot?.documents.compactMap { FriendRequest(document: $0) } ?? []
                self.incomingRequests = requests
            }
    }

    func searchUsers() {
        let trimmedEmail = newFriendEmail.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        guard !trimmedEmail.isEmpty else {
            availableUsers = []
            errorMessage = ""
            return
        }

        guard let currentEmail = Auth.auth().currentUser?.email?.lowercased() else {
            errorMessage = "You must be logged in to search for users."
            availableUsers = []
            return
        }

        errorMessage = ""

        db.collection("users")
            .whereField("email", isEqualTo: trimmedEmail)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.availableUsers = []
                    return
                }

                let users = snapshot?.documents.compactMap { AppUser(document: $0) } ?? []
                self.availableUsers = users.filter { $0.email.lowercased() != currentEmail }
            }
    }

    func sendFriendRequest(to user: AppUser) {
        guard let currentUser = Auth.auth().currentUser,
              let fromEmail = currentUser.email else {
            errorMessage = "You must be logged in to send a friend request."
            return
        }

        if friends.contains(where: { $0.email.lowercased() == user.email.lowercased() }) {
            errorMessage = "That user is already in your friends list."
            return
        }

        if incomingRequests.contains(where: { $0.fromEmail.lowercased() == user.email.lowercased() }) {
            errorMessage = "That user already sent you a request."
            return
        }

        errorMessage = ""

        let fromDisplayName = fromEmail.components(separatedBy: "@").first ?? fromEmail

        db.collection("friendRequests")
            .whereField("fromEmail", isEqualTo: fromEmail)
            .whereField("toEmail", isEqualTo: user.email)
            .whereField("status", isEqualTo: "pending")
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }

                if let documents = snapshot?.documents, !documents.isEmpty {
                    self.errorMessage = "A pending request already exists."
                    return
                }

                let request = FriendRequest(
                    fromEmail: fromEmail,
                    fromDisplayName: fromDisplayName,
                    toEmail: user.email
                )

                self.db.collection("friendRequests").addDocument(data: request.dictionary) { addError in
                    if let addError = addError {
                        self.errorMessage = addError.localizedDescription
                        return
                    }

                    self.newFriendEmail = ""
                    self.availableUsers = []
                }
            }
    }

    func acceptRequest(_ request: FriendRequest) {
        guard let currentEmail = Auth.auth().currentUser?.email else {
            errorMessage = "You must be logged in to accept requests."
            return
        }

        errorMessage = ""

        let batch = db.batch()

        let currentUserFriendRef = db.collection("friends").document()
        batch.setData([
            "ownerEmail": currentEmail,
            "friendEmail": request.fromEmail,
            "friendName": request.fromDisplayName,
            "createdAt": Timestamp(date: Date())
        ], forDocument: currentUserFriendRef)

        let reverseFriendRef = db.collection("friends").document()
        let reverseDisplayName = currentEmail.components(separatedBy: "@").first ?? currentEmail
        batch.setData([
            "ownerEmail": request.fromEmail,
            "friendEmail": currentEmail,
            "friendName": reverseDisplayName,
            "createdAt": Timestamp(date: Date())
        ], forDocument: reverseFriendRef)

        let requestRef = db.collection("friendRequests").document(request.id)
        batch.updateData(["status": "accepted"], forDocument: requestRef)

        batch.commit { [weak self] error in
            guard let self = self else { return }

            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }

            self.loadIncomingRequests()
            self.loadFriends()
        }
    }

    func declineRequest(_ request: FriendRequest) {
        errorMessage = ""

        db.collection("friendRequests")
            .document(request.id)
            .updateData(["status": "declined"]) { [weak self] error in
                guard let self = self else { return }

                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }

                self.loadIncomingRequests()
            }
    }

    func removeFriend(_ friend: AppUser) {
        guard let ownerEmail = Auth.auth().currentUser?.email else {
            errorMessage = "You must be logged in to remove a friend."
            return
        }

        errorMessage = ""

        db.collection("friends")
            .whereField("ownerEmail", isEqualTo: ownerEmail)
            .whereField("friendEmail", isEqualTo: friend.email)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }

                let documents = snapshot?.documents ?? []

                if documents.isEmpty {
                    self.errorMessage = "Friend record not found."
                    return
                }

                let group = DispatchGroup()

                for document in documents {
                    group.enter()
                    document.reference.delete { deleteError in
                        if let deleteError = deleteError {
                            self.errorMessage = deleteError.localizedDescription
                        }
                        group.leave()
                    }
                }

                group.notify(queue: .main) {
                    self.loadFriends()
                }
            }
    }

    private func loadUserProfiles(for emails: [String]) {
        db.collection("users")
            .whereField("email", in: emails)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }

                self.isLoading = false

                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.friends = []
                    return
                }

                let users = snapshot?.documents.compactMap { AppUser(document: $0) } ?? []

                self.friends = users.sorted {
                    $0.displayName.localizedCaseInsensitiveCompare($1.displayName) == .orderedAscending
                }
            }
    }
}
