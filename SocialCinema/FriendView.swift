//
//  FriendView.swift
//  SocialCinema
//
//  Created by Evan Samano on 3/21/26.
//

import SwiftUI

struct ReviewCardView: View {
    let review: Review
    var body: some View {
        VStack(alignment: .leading) {
            // Review title and rating number
            HStack {
                Text(review.movieTitle)
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                Text("\(review.rating)")
                    .font(.title3)
            }
            
            // Review body
            if let body: String = review.reviewBody {
                Spacer()
                Text(body)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .cornerRadius(10)
    }
}

struct FriendView: View {
    @Binding var path: NavigationPath
    let friend: User
    var testReviews: [Review] = [Review(movieTitle: "Project Hail Mary", rating: 10, reviewBody: "One of the best book-to-movie adapations I have ever seen. Hopeful sci-fi is something we need to see more of in today's age. Highly recommend."), Review(movieTitle: "Movie Review without a body", rating: 6, reviewBody: nil)]
    
    var body: some View {
        VStack {
            Text("\(friend.name)'s Reviews").font(.title2)
            List {
                ForEach(testReviews.indices, id: \.self) { index in
                    ReviewCardView(review: testReviews[index])
                }
            }
        }.padding()
    }
}

#Preview {
    FriendView(path: .constant(NavigationPath()), friend: User(name: "Test Friend"))
}
