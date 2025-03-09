//
//  AdminDashboardView.swift
//  Washo
//
//  Created by Amaan Amaan on 05/01/25.
//

import SwiftUI

struct AdminDashboardView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack(spacing: 20) {
            // User Info Section
            if let user = authViewModel.currentUser {
                VStack(spacing: 8) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 70, height: 70)
                        .overlay(
                            Text(user.initials)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        )
                    
                    Text("Welcome, \(user.fullName)!")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("Role: Admin")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 20)
            }

            // Dashboard Cards
            HStack(spacing: 16) {
                DashboardCard(title: "Total Workers", count: 24, color: .blue)
                DashboardCard(title: "Total Jobs", count: 350, color: .green)
            }
            
            HStack(spacing: 16) {
                DashboardCard(title: "Pending Approvals", count: 15, color: .orange)
                DashboardCard(title: "Feedbacks", count: 12, color: .purple)
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    AdminDashboardView()
        .environmentObject(AuthViewModel())
}
