//
//  AppUser.swift
//  SocialCinema
//
//  Created by Joseph Loveall (Student) on 4/18/26.
//

import Foundation
import FirebaseFirestore

struct AppUser: Identifiable, Hashable {
    let id: String
    let email: String
    let displayName: String
    let createdAt: Date

    init(
        id: String,
        email: String,
        displayName: String,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.email = email
        self.displayName = displayName
        self.createdAt = createdAt
    }

    init?(document: QueryDocumentSnapshot) {
        let data = document.data()

        guard
            let email = data["email"] as? String,
            let displayName = data["displayName"] as? String,
            let timestamp = data["createdAt"] as? Timestamp
        else {
            return nil
        }

        self.id = document.documentID
        self.email = email
        self.displayName = displayName
        self.createdAt = timestamp.dateValue()
    }

    var dictionary: [String: Any] {
        [
            "email": email,
            "displayName": displayName,
            "createdAt": Timestamp(date: createdAt)
        ]
    }
}
