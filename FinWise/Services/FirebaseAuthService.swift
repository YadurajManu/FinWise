//
//  FirebaseAuthService.swift
//  FinWise
//
//  Created by Yaduraj Singh on 22/06/25.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn
import SwiftUI

class FirebaseAuthService: ObservableObject {
    @Published var isAuthenticated = false
    @Published var userEmail = ""
    @Published var userName = ""
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    private var authStateListener: AuthStateDidChangeListenerHandle?
    
    init() {
        setupAuthStateListener()
    }
    
    deinit {
        if let listener = authStateListener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
    
    private func setupAuthStateListener() {
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                if let user = user {
                    self?.isAuthenticated = true
                    self?.userEmail = user.email ?? ""
                    self?.userName = user.displayName ?? user.email?.components(separatedBy: "@").first ?? "User"
                } else {
                    self?.isAuthenticated = false
                    self?.userEmail = ""
                    self?.userName = ""
                }
            }
        }
    }
    
    // MARK: - Email/Password Authentication
    
    func signInWithEmail(email: String, password: String) {
        isLoading = true
        errorMessage = ""
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    print("Sign in error: \(error.localizedDescription)")
                } else {
                    print("Successfully signed in with email")
                }
            }
        }
    }
    
    func signUpWithEmail(fullName: String, email: String, password: String, confirmPassword: String) {
        isLoading = true
        errorMessage = ""
        
        // Validate inputs
        guard !fullName.isEmpty else {
            errorMessage = "Please enter your full name"
            isLoading = false
            return
        }
        
        guard !email.isEmpty && email.contains("@") else {
            errorMessage = "Please enter a valid email"
            isLoading = false
            return
        }
        
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters"
            isLoading = false
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            isLoading = false
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    print("Sign up error: \(error.localizedDescription)")
                } else if let user = result?.user {
                    // Update user profile with display name
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = fullName
                    changeRequest.commitChanges { error in
                        if let error = error {
                            print("Error updating profile: \(error.localizedDescription)")
                        } else {
                            print("Successfully updated user profile")
                        }
                    }
                    print("Successfully created user account")
                }
            }
        }
    }
    
    // MARK: - Google Sign-In
    
    func signInWithGoogle() {
        isLoading = true
        errorMessage = ""
        
        guard let presentingViewController = UIApplication.shared.windows.first?.rootViewController else {
            errorMessage = "Could not get presenting view controller"
            isLoading = false
            return
        }
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            errorMessage = "Could not get Firebase client ID"
            isLoading = false
            return
        }
        
        // Create Google Sign In configuration object
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    self?.isLoading = false
                    print("Google Sign-In error: \(error.localizedDescription)")
                    return
                }
                
                guard let user = result?.user,
                      let idToken = user.idToken?.tokenString else {
                    self?.errorMessage = "Failed to get Google ID token"
                    self?.isLoading = false
                    return
                }
                
                let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                              accessToken: user.accessToken.tokenString)
                
                // Sign in to Firebase with Google credentials
                Auth.auth().signIn(with: credential) { authResult, error in
                    DispatchQueue.main.async {
                        self?.isLoading = false
                        
                        if let error = error {
                            self?.errorMessage = error.localizedDescription
                            print("Firebase Google Sign-In error: \(error.localizedDescription)")
                        } else {
                            print("Successfully signed in with Google")
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Sign Out
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            print("Successfully signed out")
        } catch {
            errorMessage = "Error signing out: \(error.localizedDescription)"
            print("Sign out error: \(error.localizedDescription)")
        }
    }
} 