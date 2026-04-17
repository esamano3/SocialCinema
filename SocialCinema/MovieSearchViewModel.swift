//
//  MovieSearchViewModel.swift
//  SocialCinema
//
//  Created by Joseph Loveall (Student) on 4/17/26.
//

import Foundation

@MainActor
class MovieSearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var movies: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let apiService = MovieAPIService()

    func searchMovies() {
        let trimmedQuery = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedQuery.isEmpty else {
            movies = []
            errorMessage = nil
            return
        }

        isLoading = true
        errorMessage = nil

        apiService.fetchMovies(query: trimmedQuery) { [weak self] result in
            guard let self = self else { return }

            self.isLoading = false

            switch result {
            case .success(let movies):
                self.movies = movies
            case .failure(let error):
                self.movies = []
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
