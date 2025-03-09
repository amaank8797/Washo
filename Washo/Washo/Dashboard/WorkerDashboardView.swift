//
//  WorkerDashboardView.swift
import SwiftUI

struct WorkerDashboardView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack(spacing: 20) {
            // User Info Section
            if let user = authViewModel.currentUser {
                VStack(spacing: 8) {
                    Circle()
                        .fill(Color.blue)
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
                    
                    Text("Role: Worker")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 20)
            }

            // Dashboard Cards
            HStack(spacing: 16) {
                DashboardCard(title: "Assigned Jobs", count: 12, color: .blue)
                DashboardCard(title: "Completed Jobs", count: 8, color: .green)
            }
            
            HStack(spacing: 16) {
                DashboardCard(title: "Pending Jobs", count: 4, color: .orange)
                DashboardCard(title: "Messages", count: 3, color: .purple)
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    WorkerDashboardView()
        .environmentObject(AuthViewModel())
}




struct DashboardCard: View {
    let title: String
    let count: Int
    let color: Color
    
    var body: some View {
        VStack {
            Text("\(count)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text(title)
                .font(.headline)
                .foregroundColor(.white.opacity(0.9))
        }
        .frame(width: 150, height: 100)
        .background(color)
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}


//  Washo
//
//  Created by Amaan Amaan on 05/01/25.
//

