//
//  SocialCinemaApp.swift
//  SocialCinema
//
//  Created by Evan Samano on 3/21/26.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        print("Firebase configured: \(FirebaseApp.app() != nil)")
        return true
    }
}

@main
struct SocialCinemaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var session = SessionViewModel()

    var body: some Scene {
        WindowGroup {
            if session.user != nil {
                ContentView()
                    .environmentObject(session)
            } else {
                LoginView()
                    .environmentObject(session)
            }
        }
    }
}
