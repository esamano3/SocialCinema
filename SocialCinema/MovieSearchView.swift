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
    
    var body: some View {
        VStack {
            Text("Search for a movie")
            TextField("Enter a movie title", text: $movieSearchTitle)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .disableAutocorrection(true)
                .autocapitalization(.none)
            NavigationLink("Search", value: 2).buttonStyle(.borderedProminent)
        }.padding()
    }
}

#Preview {
    MovieSearchView(path: .constant(NavigationPath()), movieSearchTitle: .constant("Project Hail Mary"))
}
