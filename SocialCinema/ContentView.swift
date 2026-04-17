//
//  ContentView.swift
//  SocialCinema
//
//  Created by Evan Samano on 3/21/26.
//

import SwiftUI

struct ContentView: View {
    @State private var path = NavigationPath()
    @State private var movieSearchTitle = ""

    var body: some View {
        NavigationStack(path: $path) {
            MovieSearchView(path: $path, movieSearchTitle: $movieSearchTitle)
                .navigationDestination(for: Int.self) { value in
                    if value == 2 {
                        MovieDetailsView(
                            path: $path,
                            movie: Movie(
                                id: 27205,
                                title: movieSearchTitle.isEmpty ? "Inception" : movieSearchTitle,
                                overview: "Temporary placeholder overview until the real TMDB API search is connected.",
                                posterPath: nil,
                                releaseDate: "2010-07-15"
                            )
                        )
                    }
                }
                .navigationDestination(for: Movie.self) { movie in
                    MovieDetailsView(path: $path, movie: movie)
                }
        }
    }
}

#Preview {
    ContentView()
}
