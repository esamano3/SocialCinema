//
//  MovieShowtimesViewModel.swift
//  SocialCinema
//
//  Created by Joseph Loveall (Student) on 4/17/26.
//

import Foundation

@MainActor
class MovieShowtimesViewModel: ObservableObject {
    @Published var theaters: [Theater] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let showtimesService = ShowtimesAPIService()

    func loadShowtimes(for movieTitle: String, location: String) {
        let trimmedMovieTitle = movieTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedLocation = location.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedMovieTitle.isEmpty, !trimmedLocation.isEmpty else {
            theaters = []
            errorMessage = "A movie title and location are required."
            return
        }

        isLoading = true
        errorMessage = nil
        theaters = []

        showtimesService.fetchShowtimes(movieTitle: trimmedMovieTitle, location: trimmedLocation) { [weak self] result in
            guard let self = self else { return }

            self.isLoading = false

            switch result {
            case .success(let theaters):
                self.theaters = theaters
                self.errorMessage = nil
            case .failure(let error):
                self.theaters = []
                self.errorMessage = error.localizedDescription
            }
        }
    }

    func clearResults() {
        theaters = []
        errorMessage = nil
        isLoading = false
    }
}
