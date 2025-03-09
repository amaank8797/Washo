//
//  MainTabView.swift
//  Washo
//
//  Created by Amaan Amaan on 05/01/25.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedIndex: Int = 0

    var body: some View {
        NavigationStack {
            TabView(selection: $selectedIndex) {
                // Dashboard Tab
                dashboardView
                    .tabItem {
                        Image(systemName: "house.fill")
                    }
                    .tag(0)

                // To-Do List Tab
                TodoListView()
                    .tabItem {
                        Image(systemName: "list.clipboard")
                    }
                    .tag(1)

                // Video Watch Tab
                VideoListView()
                    .tabItem {
                        Image(systemName: "play.square.stack.fill")
                    }
                    .tag(2)

                // Profile Tab
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.fill")
                    }
                    .tag(3)
            }
            .navigationTitle(tabTitle)
            .navigationBarTitleDisplayMode(.inline)
            .accentColor(.blue.opacity(0.6))
        }
    }

    // Role-based dashboard view
    private var dashboardView: some View {
        if authViewModel.currentUser?.role == "worker" {
            return AnyView(WorkerDashboardView())
        } else if authViewModel.currentUser?.role == "admin" {
            return AnyView(AdminDashboardView())
        } else {
            return AnyView(Text("Unauthorized Role").foregroundColor(.red))
        }
    }

    private var tabTitle: String {
        switch selectedIndex {
        case 0: return "Dashboard"
        case 1: return "Check List"
        case 2: return "Videos"
        case 3: return "Account"
        default: return ""
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthViewModel())
}
