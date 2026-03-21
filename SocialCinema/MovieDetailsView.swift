//
//  MovieDetailsView.swift
//  SocialCinema
//
//  Created by Evan Samano on 3/21/26.
//

import SwiftUI

struct MovieDetailsView: View {
    @Binding var path: NavigationPath
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    MovieDetailsView(path: .constant(NavigationPath()))
}
