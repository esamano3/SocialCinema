//
//  FriendView.swift
//  SocialCinema
//
//  Created by Evan Samano on 3/21/26.
//

import SwiftUI

struct FriendView: View {
    @Binding var path: NavigationPath
    let friend: User
    
    var body: some View {
        VStack {
            Text("Hi there I am \(friend.name)")
        }.padding()
            .navigationTitle("\(friend.name)")
    }
}

#Preview {
    FriendView(path: .constant(NavigationPath()), friend: User(name: "Test Friend"))
}
