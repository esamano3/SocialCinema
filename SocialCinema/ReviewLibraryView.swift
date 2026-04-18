//
//  ReviewLibraryView.swift
//  SocialCinema
//
//  Created by Joseph Loveall (Student) on 4/18/26.
//

import SwiftUI

struct ReviewLibraryView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: "books.vertical")
                    .font(.system(size: 48))

                Text("Review Library")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("This holds your saved reviews, favorites, or movie library next.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Library")
        }
    }
}

#Preview {
    ReviewLibraryView()
}
