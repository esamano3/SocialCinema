//
//  MovieSearchView.swift
//  SocialCinema
//
//  Created by Evan Samano on 3/21/26.
//

import SwiftUI

struct MovieSearchView: View {
    @Binding var path: NavigationPath
    @State var movieSearchTitle: String = ""
    
    var body: some View {
        VStack {
            Text("Search for a movie")
            TextField("What the heck", text: $movieSearchTitle)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .disableAutocorrection(true)
                .autocapitalization(.none)
            NavigationLink("Search", value: 2).buttonStyle(.borderedProminent).padding()
        }.padding()
    }
}

#Preview {
    MovieSearchView(path: .constant(NavigationPath()))
}
