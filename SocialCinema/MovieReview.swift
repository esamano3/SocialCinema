//
//  MovieReview.swift
//  SocialCinema
//
//  Created by Joseph Loveall (Student) on 4/18/26.
//

import Foundation
import FirebaseFirestore

struct MovieReview: Identifiable {
    let id: String
    let movieID: Int
    let movieTitle: String
    let userEmail: String
    let reviewText: String
    let rating: Int
    let createdAt: Date

    init(
        id: String = UUID().uuidString,
        movieID: Int,
        movieTitle: String,
        userEmail: String,
        reviewText: String,
        rating: Int,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.movieID = movieID
        self.movieTitle = movieTitle
        self.userEmail = userEmail
        self.reviewText = reviewText
        self.rating = rating
        self.createdAt = createdAt
    }

    init?(document: QueryDocumentSnapshot) {
        let data = document.data()

        guard
            let movieID = data["movieID"] as? Int,
            let movieTitle = data["movieTitle"] as? String,
            let userEmail = data["userEmail"] as? String,
            let reviewText = data["reviewText"] as? String,
            let rating = data["rating"] as? Int,
            let timestamp = data["createdAt"] as? Timestamp
        else {
            return nil
        }

        self.id = document.documentID
        self.movieID = movieID
        self.movieTitle = movieTitle
        self.userEmail = userEmail
        self.reviewText = reviewText
        self.rating = rating
        self.createdAt = timestamp.dateValue()
    }

    var dictionary: [String: Any] {
        [
            "movieID": movieID,
            "movieTitle": movieTitle,
            "userEmail": userEmail,
            "reviewText": reviewText,
            "rating": rating,
            "createdAt": Timestamp(date: createdAt)
        ]
    }
}
