//
//  LoginView.swift
//  SocialCinema
//
//  Created by Joseph Loveall (Student) on 4/18/26.
//


import SwiftUI

struct LoginView: View {
    @EnvironmentObject var session: SessionViewModel

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoginMode: Bool = true

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()

                Text("SocialCinema")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text(isLoginMode ? "Login to your account" : "Create an account")
                    .foregroundStyle(.secondary)

                VStack(spacing: 12) {
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .keyboardType(.emailAddress)
                        .textFieldStyle(.roundedBorder)

                    SecureField("Password", text: $password)
                        .textFieldStyle(.roundedBorder)
                }

                if !session.errorMessage.isEmpty {
                    Text(session.errorMessage)
                        .foregroundStyle(.red)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                }

                Button {
                    if isLoginMode {
                        session.signIn(email: email, password: password)
                    } else {
                        session.signUp(email: email, password: password)
                    }
                } label: {
                    Text(isLoginMode ? "Login" : "Create Account")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || password.isEmpty)

                Button {
                    isLoginMode.toggle()
                    session.errorMessage = ""
                } label: {
                    Text(isLoginMode ? "Need an account? Sign Up" : "Already have an account? Login")
                }

                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(SessionViewModel())
}
