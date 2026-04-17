//
//  ContentView.swift
//  SocialCinema
//
//  Created by Evan Samano on 3/21/26.
//

import SwiftUI

struct ContentView: View {
    @State private var path = NavigationPath()
    @State private var movieSearchTitle: String = ""

    var body: some View {
        NavigationStack(path: $path) {
            TabView {
                MovieSearchView(
                    path: $path,
                    movieSearchTitle: $movieSearchTitle
                )
                .tabItem {
                    Label("Movies", systemImage: "film")
                }

                FriendsListView(path: $path)
                    .tabItem {
                        Label("Friends", systemImage: "person.2")
                    }

                ShowtimesTestView()
                    .tabItem {
                        Label("Test", systemImage: "location")
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
