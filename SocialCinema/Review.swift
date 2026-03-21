//
//  Review.swift
//  SocialCinema
//
//  Created by Evan Samano on 3/21/26.
//

import Foundation

struct Review {
    let movieTitle: String
    let rating: Int // 1-10
    let reviewBody: String? // reviewBody is optional. Only the rating number is needed to make a review.
}
