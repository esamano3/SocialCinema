//
//  FriendUser.swift
//  SocialCinema
//
//  Created by Joseph Loveall (Student) on 4/18/26.
//

import Foundation

struct FriendUser: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let email: String
    let favoriteMovie: String
    let reviews: [FriendMovieReview]
}
