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
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(movie.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                if let releaseDate = movie.releaseDate, !releaseDate.isEmpty {
                    Text("Release Date: \(releaseDate)")
                        .font(.subheadline) //test commit
                        .foregroundStyle(.secondary)
                }
                
                Text("Overview")
                    .font(.headline)
                
                Text(movie.overview.isEmpty ? "No overview available." : movie.overview)
                    .font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationTitle("Movie Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MovieDetailsView(
        path: .constant(NavigationPath()),
        movie: Movie(
            id: 27205,
            title: "Inception",
            overview: "Cobb, a skilled thief who commits corporate espionage by infiltrating the subconscious of his targets is offered a chance to regain his old life.",
            posterPath: "/xlaY2zyzMfkhk0HSC5VUwzoZPU1.jpg",
            releaseDate: "2010-07-15"
        )
    )
}
