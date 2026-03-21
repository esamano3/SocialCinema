//
//  MovieDetailsView.swift
//  SocialCinema
//
//  Created by Evan Samano on 3/21/26.
//

import SwiftUI

struct MovieDetailsView: View {
    @Binding var path: NavigationPath
    let movie: Movie
    
    var body: some View {
        VStack {
            Text("Title: \(movie.title)")
            Text("Genre: \(movie.genre)")
            Text("Synopsis: \(movie.synopsis)")
        }.padding()
    }
}

#Preview {
    MovieDetailsView(path: .constant(NavigationPath()), movie: Movie(title: "Project Hail Mary", genre: "Sci-Fi", synopsis: "Science teacher Ryland Grace wakes up on a spaceship with no recollection of who he is or how he got there. As his memory slowly returns, he soon discovers he must solve the riddle behind a mysterious substance that's causing the sun to die out. As details of the mission unravel, he calls on his scientific training and sheer ingenuity -- but he may not have to do it alone."))
}
