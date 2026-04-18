//
//  SessionViewModel.swift
//  SocialCinema
//
//  Created by Joseph Loveall (Student) on 4/18/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
class SessionViewModel: ObservableObject {
    @Published var user: FirebaseAuth.User?
    @Published var errorMessage: String = ""

    private let db = Firestore.firestore()

    init() {
        self.user = Auth.auth().currentUser
    }

    func signIn(email: String, password: String) {
        errorMessage = ""

        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        Auth.auth().signIn(withEmail: trimmedEmail, password: password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                return
            }

            self?.user = result?.user
        }
    }

    func signUp(email: String, password: String) {
        errorMessage = ""

        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let displayName = Self.defaultDisplayName(from: trimmedEmail)

        Auth.auth().createUser(withEmail: trimmedEmail, password: password) { [weak self] result, error in
            guard let self = self else { return }

            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }

            guard let firebaseUser = result?.user else {
                self.errorMessage = "Could not create user."
                return
            }

            let appUser = AppUser(
                id: firebaseUser.uid,
                email: trimmedEmail,
                displayName: displayName
            )

            self.db.collection("users").document(firebaseUser.uid).setData(appUser.dictionary) { firestoreError in
                if let firestoreError = firestoreError {
                    self.errorMessage = firestoreError.localizedDescription
                    return
                }

                self.user = firebaseUser
            }
        }
    }

    func signOut() {
        errorMessage = ""

        do {
            try Auth.auth().signOut()
            self.user = nil
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    private static func defaultDisplayName(from email: String) -> String {
        let usernamePart = email.components(separatedBy: "@").first ?? email
        if usernamePart.isEmpty {
            return "User"
        }
        return usernamePart
    }
}
