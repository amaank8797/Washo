//
//  CreateAccountView.swift
//  Don't Crash Out
//
//  Created by Amaan Amaan on 11/12/24.
//
import SwiftUI

struct CreateAccountView: View {
    let role: String // Add role parameter
    
    @State private var email: String = ""
    @State private var fullName: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Please complete all information to create an account.")
                .font(.headline)
                .fontWeight(.medium)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.vertical)
            
            InputView(
                placeholder: "Email or Phone number",
                text: $email
            )
            
            InputView(
                placeholder: "Full Name",
                text: $fullName
            )
            
            InputView(
                placeholder: "Password",
                isSecureField: true,
                text: $password
            )
            
            InputView(
                placeholder: "Confirm your password",
                isSecureField: true,
                text: $confirmPassword
            )
            
            Spacer()
            
            Button {
                Task {
                    await authViewModel.createUser(email: email, fullName: fullName, password: password, role: role)
                }
            } label: {
                Text("Create Account")
            }
            .buttonStyle(CapsuleButtonStyle(bgColor: .blue.opacity(0.6), textColor: .primary))
        }
        .navigationTitle("Set up your account")
        .padding()
    }
}

#Preview {
    CreateAccountView(role: "Worker")
        .environmentObject(AuthViewModel())
}
