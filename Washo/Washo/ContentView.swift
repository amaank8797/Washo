//
//  ContentView.swift
//  Washo
//
//  Created by Amaan Amaan on 05/01/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isLoading = true
    
    var body: some View {
        Group {
            if isLoading {
                LaunchScreenView() // Show the custom launch screen
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            isLoading = false
                        }
                    }
            } else {
                if authViewModel.userSession == nil {
                    LoginView()
                } else {
                    MainTabView()
                }
            }
        }
        .environmentObject(authViewModel)
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}

