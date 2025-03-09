//
//  Router.swift
//  Don't Crash Out
//
//  Created by Amaan Amaan on 11/12/24.
//

import SwiftUI


final class Router: ObservableObject {
    @Published var navPath = NavigationPath()
    
    enum AuthFlow: Hashable, Codable {
        case login
        case createAccount(role: String) // Add role as a parameter
        case profile
        case forgotPassword
        case emailSent
    }
    
    func navigate(to destination: AuthFlow) {
        navPath.append(destination)
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}
