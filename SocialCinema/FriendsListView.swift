//
//  FriendsListView.swift
//  SocialCinema
//
//  Created by Evan Samano on 3/21/26.
//

import SwiftUI

struct FriendCardView: View {
    let friend: User
    var body: some View {
        VStack(alignment: .leading) {
            Text(friend.name)
                .font(.title3)
                .fontWeight(.bold)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.green)
        .cornerRadius(10)
    }
}

struct FriendsListView: View {
    @Binding var path: NavigationPath
    let friendsList: [User] = [User(name: "Evan"), User(name: "Joe"), User(name: "Arav"), User(name: "Jackson")]
    
    var body: some View {
        // list of friends
        List {
            ForEach(friendsList.indices, id: \.self) { index in
                FriendCardView(friend: friendsList[index])
            }
        }
    }
}

#Preview {
    FriendsListView(path: .constant(NavigationPath()))
}
