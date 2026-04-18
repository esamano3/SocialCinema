//
//  MovieSearchView.swift
//  SocialCinema
//
//  Created by Evan Samano on 3/21/26.
//

import SwiftUI

struct MovieSearchView: View {
    @Binding var path: NavigationPath
    @Binding var movieSearchTitle: String
    @StateObject private var viewModel = MovieSearchViewModel()

    var body: some View {
        VStack(spacing: 16) {
            Text("Search for a Movie")
                .font(.title)
                .fontWeight(.bold)

            TextField("Enter movie title", text: $viewModel.searchText)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            Button("Search") {
                movieSearchTitle = viewModel.searchText
                viewModel.searchMovies()
            }
            .buttonStyle(.borderedProminent)

            if viewModel.isLoading {
                ProgressView("Searching...")
            }

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .font(.footnote)
                    .padding(.horizontal)
            }

            List(viewModel.movies) { movie in
                NavigationLink(value: movie) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(movie.title)
                            .font(.headline)

                        if let releaseDate = movie.releaseDate, !releaseDate.isEmpty {
                            Text(releaseDate)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        Text(movie.overview.isEmpty ? "No overview available." : movie.overview)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .listStyle(.plain)
        }
        .padding()
    }
}

#Preview {
    MovieSearchView(
        path: .constant(NavigationPath()),
        movieSearchTitle: .constant("")
    )
}
