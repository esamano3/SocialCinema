//
//  FriendMovieReview.swift
//  SocialCinema
//
//  Created by Joseph Loveall (Student) on 4/18/26.
//

import Foundation

struct FriendMovieReview: Identifiable, Hashable {
    let id = UUID()
    let movieTitle: String
    let rating: Int
    let reviewText: String
}
