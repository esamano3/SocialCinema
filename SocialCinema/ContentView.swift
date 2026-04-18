//
//  ContentView.swift
//  SocialCinema
//
//  Created by Evan Samano on 3/21/26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var session: SessionViewModel

    @State private var path = NavigationPath()
    @State private var movieSearchTitle: String = ""
    @State private var showingSettings = false

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

                ReviewLibraryView()
                    .tabItem {
                        Label("Library", systemImage: "books.vertical")
                    }
            }
            .navigationTitle("SocialCinema")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
                    .environmentObject(session)
            }
            .navigationDestination(for: Movie.self) { movie in
                MovieDetailsView(path: $path, movie: movie)
            }
            .navigationDestination(for: FriendUser.self) { friend in
                FriendProfileView(friend: friend)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(SessionViewModel())
}
