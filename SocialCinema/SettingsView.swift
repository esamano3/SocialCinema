//
//  SettingsView.swift
//  SocialCinema
//
//  Created by Joseph Loveall (Student) on 4/18/26.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var session: SessionViewModel

    var body: some View {
        NavigationStack {
            List {
                Section("Account") {
                    if let email = session.user?.email {
                        HStack {
                            Text("Signed in as")
                            Spacer()
                            Text(email)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Button(role: .destructive) {
                        session.signOut()
                        dismiss()
                    } label: {
                        Text("Sign Out")
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SessionViewModel())
}
