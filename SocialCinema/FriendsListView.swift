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
        .cornerRadius(10)
    }
}

struct FriendsListView: View {
    @Binding var path: NavigationPath
    let testFriendsList: [User] = [User(name: "Evan"), User(name: "Joe"), User(name: "Arav"), User(name: "Jackson")]
    
    var body: some View {
        // Add a friend button
        // TODO: this adds two friend tabs to the contentView????/ Why????
        // I think maybe each tab should have its own NavigationStack
        /*Button("Add a Friend") {
            
        }.padding()
            .frame(maxWidth: .infinity, alignment: .center)
            .cornerRadius(10)
            .buttonStyle(.borderedProminent)*/
        
        // list of friends
        List {
            ForEach(testFriendsList.indices, id: \.self) { index in
                NavigationLink() {
                    FriendView(path: $path, friend: testFriendsList[index])
                } label: {
                    FriendCardView(friend: testFriendsList[index])
                }
            }
        }
    }
}

#Preview {
    FriendsListView(path: .constant(NavigationPath()))
}
