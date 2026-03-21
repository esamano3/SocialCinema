//
//  ContentView.swift
//  SocialCinema
//
//  Created by Evan Samano on 3/21/26.
//

import SwiftUI

struct ContentView: View {
    @State var path: NavigationPath = NavigationPath()
    @State var movieSearchTitle: String = ""
    
    var body: some View {
        NavigationStack(path: $path) {
            TabView {
                // First Tab
                MovieSearchView(path: $path, movieSearchTitle: $movieSearchTitle)
                    .tabItem {
                        Label("Movies", systemImage: "film") // Use Label for icon and text
                    }
                
                // Second Tab
                Text("Second Tab Content")
                    .tabItem {
                        Label("Friends", systemImage: "person")
                    }
                
                /*
                // Third Tab, we could use this for user settings. But that is not necessarily necessary, iykyk
                Text("Third Tab Content")
                    .tabItem {
                        Label("Settings", systemImage: "gearshape")
                    } */
            }
            .navigationTitle("Social Cinema")
            .navigationBarTitleDisplayMode(.inline) // display title in the top center middle of screen
            .navigationDestination(for: Int.self) { numberValue in
                if numberValue == 2 {
                    MovieDetailsView(path: $path, movie: Movie(title: movieSearchTitle, genre: "Sci-Fi", synopsis: "Science teacher Ryland Grace wakes up on a spaceship with no recollection of who he is or how he got there. As his memory slowly returns, he soon discovers he must solve the riddle behind a mysterious substance that's causing the sun to die out. As details of the mission unravel, he calls on his scientific training and sheer ingenuity -- but he may not have to do it alone."))
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
