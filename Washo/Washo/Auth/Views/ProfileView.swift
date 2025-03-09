//
//  ProfileView.swift
//  Don't Crash Out
//
//  Created by Amaan Amaan on 11/12/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var router: Router
    
    @State private var showSettings = false
    @State private var showMoreFunctions = false
    
    var body: some View {
        if let user = authViewModel.currentUser {
            NavigationStack {
                VStack(spacing: 16) {
                    // User Profile Info Section
                    VStack {
                        HStack(spacing: 16) {
                            Text(user.initials)
                                .font(.largeTitle)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .frame(width: 80, height: 80)
                                .background(LinearGradient(colors: [.blue, .green], startPoint: .top, endPoint: .bottom))
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.fullName)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Text(user.email)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                
                                Text("Role: \(user.role.capitalized)")
                                    .font(.subheadline)
                                    .foregroundColor(user.role == "admin" ? .red : .blue)
                                    .padding(.top, 4)
                                    .fontWeight(.semibold)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 16)
                    
                    Divider()
                    
                    // Settings Section
                    List {
                        Section(header: Text("Account Actions").font(.headline)) {
                            // Sign Out Button
                            Button {
                                authViewModel.signOut()
                            } label: {
                                Label("Sign Out", systemImage: "arrow.right.circle.fill")
                                    .foregroundColor(.red)
                            }
                            
                            // More Functions Menu
                            Button {
                                showMoreFunctions.toggle()
                            } label: {
                                Label("More Functions", systemImage: "ellipsis.circle.fill")
                            }
                            .sheet(isPresented: $showMoreFunctions) {
                                MoreFunctionsView()
                            }
                        }
                        
                        Section(header: Text("Settings").font(.headline)) {
                            Button {
                                showSettings.toggle()
                            } label: {
                                Label("Settings", systemImage: "gearshape.fill")
                            }
                            .sheet(isPresented: $showSettings) {
                                SettingsView()
                            }
                        }
                    }
                }
                .navigationTitle("Profile")
            }
        } else {
            ProgressView("Loading profile...")
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
