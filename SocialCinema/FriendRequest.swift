//
//  FriendRequest.swift
//  SocialCinema
//
//  Created by Joseph Loveall (Student) on 4/18/26.
//

import Foundation
import FirebaseFirestore

struct FriendRequest: Identifiable, Hashable {
    let id: String
    let fromEmail: String
    let fromDisplayName: String
    let toEmail: String
    let status: String
    let createdAt: Date

    init(
        id: String = UUID().uuidString,
        fromEmail: String,
        fromDisplayName: String,
        toEmail: String,
        status: String = "pending",
        createdAt: Date = Date()
    ) {
        self.id = id
        self.fromEmail = fromEmail
        self.fromDisplayName = fromDisplayName
        self.toEmail = toEmail
        self.status = status
        self.createdAt = createdAt
    }

    init?(document: QueryDocumentSnapshot) {
        let data = document.data()

        guard
            let fromEmail = data["fromEmail"] as? String,
            let fromDisplayName = data["fromDisplayName"] as? String,
            let toEmail = data["toEmail"] as? String,
            let status = data["status"] as? String,
            let timestamp = data["createdAt"] as? Timestamp
        else {
            return nil
        }

        self.id = document.documentID
        self.fromEmail = fromEmail
        self.fromDisplayName = fromDisplayName
        self.toEmail = toEmail
        self.status = status
        self.createdAt = timestamp.dateValue()
    }

    var dictionary: [String: Any] {
        [
            "fromEmail": fromEmail,
            "fromDisplayName": fromDisplayName,
            "toEmail": toEmail,
            "status": status,
            "createdAt": Timestamp(date: createdAt)
        ]
    }
}
