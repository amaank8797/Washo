//
//  LoginView.swift
//  Don't Crash Out
//
//  Created by Amaan Amaan on 10/12/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var selectedSegment = 0 // 0 for Worker, 1 for Admin
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var router: Router
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Logo
                logo
                
                // Role Picker
                Picker("Select View", selection: $selectedSegment) {
                    Text("Worker").tag(0)
                    Text("Admin").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Spacer().frame(height: 12)
                
                // Email & Password Fields
                InputView(placeholder: "Email", text: $email)
                InputView(placeholder: "Password", isSecureField: true, text: $password)
                
                // Forgot Password Button
                forgotButton
                
                // Login Button
                loginButton
                
                Spacer()
                
                // Bottom View
                if selectedSegment == 0 { // Only show sign-up for Worker
                    bottomView
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .ignoresSafeArea()
        .alert("Something went wrong", isPresented: $authViewModel.isError) {}
    }
    
    // MARK: - Components
    private var logo: some View {
        Image("logo")
            .resizable()
            .scaledToFit()
            
    }
    
    private var forgotButton: some View {
        HStack {
            Spacer()
            Button {
                router.navigate(to: .forgotPassword)
            } label: {
                Text("Forgot Password?")
                    .foregroundStyle(.blue)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
        }
    }
    
    private var loginButton: some View {
        Button {
            Task {
                await authViewModel.login(email: email, password: password, role: selectedSegment == 0 ? "worker" : "admin")
            }
        } label: {
            Text("Login")
        }
        .buttonStyle(CapsuleButtonStyle(bgColor: .blue.opacity(0.6), textColor: .primary))
    }
    
    private var bottomView: some View {
        VStack(spacing: 16) {
            lineOrView
            footerView
        }
    }
    
    private var lineOrView: some View {
        HStack(spacing: 16) {
            line
            Text("or")
                .fontWeight(.semibold)
            line
        }
        .foregroundStyle(.gray)
    }
    
    private var line: some View {
        Divider().frame(height: 1)
    }
    
    private var footerView: some View {
        Button {
            router.navigate(to: .createAccount(role: "worker")) // Pass role explicitly
        } label: {
            HStack {
                Text("Don't have an account?")
                    .foregroundStyle(.black)
                Text("Sign Up")
                    .foregroundStyle(.blue)
            }
            .fontWeight(.medium)
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}

struct CapsuleButtonStyle: ButtonStyle {
    var bgColor: Color = .teal
    var textColor: Color = .white
    var hasBorder: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(textColor)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Capsule().fill(bgColor))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .overlay {
                hasBorder ?
                Capsule()
                    .stroke(.gray, lineWidth: 1) :
                nil
            }
    }
}
