//
//  SessionViewModel.swift
//  SocialCinema
//
//  Created by Joseph Loveall (Student) on 4/18/26.
//

import Foundation
import FirebaseAuth

@MainActor
class SessionViewModel: ObservableObject {
    @Published var user: FirebaseAuth.User?
    @Published var errorMessage: String = ""

    init() {
        self.user = Auth.auth().currentUser
    }

    func signIn(email: String, password: String) {
        errorMessage = ""

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                return
            }

            self?.user = result?.user
        }
    }

    func signUp(email: String, password: String) {
        errorMessage = ""

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                return
            }

            self?.user = result?.user
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
}
