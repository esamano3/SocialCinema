//
//  ContentView.swift
//  SocialCinema
//
//  Created by Evan Samano on 3/21/26.
//

import SwiftUI

struct ContentView: View {
    @State var path: NavigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            TabView {
                // First Tab
                MovieSearchView(path: $path)
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
                    MovieDetailsView(path: $path)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
