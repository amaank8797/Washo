//
//  AuthViewModel.swift
//  Don't Crash Out
//
//  Created by Amaan Amaan on 11/12/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
final class AuthViewModel: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User? // Firebase user
    @Published var currentUser: User? // Custom user model
    @Published var isError: Bool = false
    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()
    
    init() {
        Task {
            await loadCurrentUser()
        }
    }
    
    /// Loads the currently authenticated user and fetches their details.
    func loadCurrentUser() async {
        guard let user = auth.currentUser else { return }
        userSession = user
        await fetchUser(by: user.uid)
    }
    
    /// Logs in a user with the provided credentials and role validation.
    func login(email: String, password: String, role: String) async {
        do {
            let authResult = try await auth.signIn(withEmail: email, password: password)
            userSession = authResult.user
            await fetchUser(by: authResult.user.uid, expectedRole: role)
        } catch {
            handleError(error)
        }
    }
    
    /// Creates a new user and stores their details in Firestore.
    func createUser(email: String, fullName: String, password: String, role: String) async {
        do {
            let authResult = try await auth.createUser(withEmail: email, password: password)
            await storeUserInFirestore(uid: authResult.user.uid, email: email, fullName: fullName, role: role)
        } catch {
            isError = true
        }
    }

    
    /// Stores a new user in Firestore.
    private func storeUserInFirestore(uid: String, email: String, fullName: String, role: String) async {
        let user = User(uid: uid, email: email, fullName: fullName, role: role)
        do {
            try firestore.collection("users").document(uid).setData(from: user)
        } catch {
            handleError(error)
        }
    }
    
    /// Fetches a user's details by their UID and optionally validates their role.
    func fetchUser(by uid: String, expectedRole: String? = nil) async {
        do {
            let document = try await firestore.collection("users").document(uid).getDocument()
            let user = try document.data(as: User.self)
            
            if let role = expectedRole, user.role != role {
                throw AuthError.invalidRole
            }
            
            currentUser = user
        } catch {
            handleError(error)
        }
    }
    
    /// Signs out the currently authenticated user.
    func signOut() {
        do {
            userSession = nil
            currentUser = nil
            try auth.signOut()
        } catch {
            handleError(error)
        }
    }
    
    /// Deletes the currently authenticated user's account.
    func deleteAccount() async {
        do {
            guard let uid = auth.currentUser?.uid else { return }
            userSession = nil
            currentUser = nil
            deleteUserFromFirestore(uid: uid)
            try await auth.currentUser?.delete()
        } catch {
            handleError(error)
        }
    }
    
    /// Deletes a user's data from Firestore.
    private func deleteUserFromFirestore(uid: String) {
        firestore.collection("users").document(uid).delete { error in
            if let error = error {
                print("Error deleting user: \(error.localizedDescription)")
            }
        }
    }
    
    /// Sends a password reset email to the specified email address.
    func resetPassword(by email: String) async {
        do {
            try await auth.sendPasswordReset(withEmail: email)
        } catch {
            handleError(error)
        }
    }
    
    /// Handles errors and updates the `isError` property.
    private func handleError(_ error: Error) {
        print("Auth error: \(error.localizedDescription)")
        isError = true
    }
    
    /// Custom authentication error types.
    enum AuthError: Error {
        case invalidRole
    }
}
