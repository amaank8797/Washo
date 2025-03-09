//
//  WashoApp.swift
//  Washo
//
//  Created by Amaan Amaan on 05/01/25.
//

import SwiftUI
import UIKit
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
@main
struct WashoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authViewModel = AuthViewModel()
    @ObservedObject private var router = Router()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navPath) {
                ContentView()
                    .navigationDestination(for: Router.AuthFlow.self) { destination in
                        switch destination {
                        case .login:
                            LoginView()
                        case .createAccount(let role): // Handle the role
                            CreateAccountView(role: role) // Pass the role to the view
                        case .profile:
                            ProfileView()
                        case .forgotPassword:
                            ForgotPasswordView()
                        case .emailSent:
                            EmailSentView()
                        }
                    }            }
            .environmentObject(authViewModel)
            .environmentObject(router)
        }
    }
}
