//
//  ShowtimesResponse.swift
//  SocialCinema
//
//  Created by Joseph Loveall (Student) on 4/17/26.
//
import Foundation

struct ShowtimesResponse: Codable {
    let showtimes: [ShowtimeDay]?
    let knowledgeGraph: KnowledgeGraph?

    enum CodingKeys: String, CodingKey {
        case showtimes
        case knowledgeGraph = "knowledge_graph"
    }
}

struct ShowtimeDay: Codable, Hashable {
    let day: String
    let theaters: [Theater]
}

struct Theater: Codable, Hashable, Identifiable {
    let id = UUID()
    let name: String
    let link: String?
    let distance: String?
    let address: String
    let showing: [Showing]

    enum CodingKeys: String, CodingKey {
        case name
        case link
        case distance
        case address
        case showing
    }
}

struct Showing: Codable, Hashable {
    let time: [String]
    let type: String
}

struct KnowledgeGraph: Codable, Hashable {
    let title: String?
    let description: String?
    let releaseDate: String?

    enum CodingKeys: String, CodingKey {
        case title
        case description
        case releaseDate = "release_date"
    }
}
