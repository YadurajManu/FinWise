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
    @Published var currentUser: User?
    
    private var authStateListener: AuthStateDidChangeListenerHandle?
    private let firestoreService = FirestoreService()
    
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
                    
                    // Load user data from Firestore
                    Task {
                        await self?.loadUserData(uid: user.uid)
                    }
                } else {
                    self?.isAuthenticated = false
                    self?.userEmail = ""
                    self?.userName = ""
                    self?.currentUser = nil
                }
            }
        }
    }
    
    private func loadUserData(uid: String) async {
        do {
            let user = try await firestoreService.getUser(uid: uid)
            DispatchQueue.main.async {
                self.currentUser = user
                if let user = user {
                    self.userName = user.fullName
                    self.userEmail = user.email
                }
            }
        } catch {
            print("Error loading user data: \(error.localizedDescription)")
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
    
    func signUpWithEmail(fullName: String, email: String, password: String, confirmPassword: String, mobileNumber: String = "", dateOfBirth: String = "", completion: @escaping (Bool) -> Void) {
        isLoading = true
        errorMessage = ""
        
        // Validate inputs
        guard !fullName.isEmpty else {
            errorMessage = "Please enter your full name"
            isLoading = false
            completion(false)
            return
        }
        
        guard !email.isEmpty && email.contains("@") else {
            errorMessage = "Please enter a valid email"
            isLoading = false
            completion(false)
            return
        }
        
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters"
            isLoading = false
            completion(false)
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            isLoading = false
            completion(false)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    self?.isLoading = false
                    print("Sign up error: \(error.localizedDescription)")
                    completion(false)
                } else if let authResult = result {
                    let user = authResult.user
                    print("✅ Firebase Auth user created successfully: \(user.uid)")
                    
                    // Update Firebase Auth profile
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = fullName
                    changeRequest.commitChanges { error in
                        if let error = error {
                            print("Error updating Firebase Auth profile: \(error.localizedDescription)")
                        } else {
                            print("✅ Firebase Auth profile updated successfully")
                        }
                    }
                    
                    // Create user document in Firestore
                    let newUser = User(
                        uid: user.uid,
                        fullName: fullName,
                        email: email,
                        mobileNumber: mobileNumber.isEmpty ? nil : mobileNumber,
                        dateOfBirth: dateOfBirth.isEmpty ? nil : dateOfBirth
                    )
                    
                    Task {
                        do {
                            try await self?.firestoreService.createUser(newUser)
                            DispatchQueue.main.async {
                                self?.isLoading = false
                                self?.currentUser = newUser
                                print("✅ Successfully created user account and Firestore profile")
                                completion(true)
                            }
                        } catch {
                            DispatchQueue.main.async {
                                self?.errorMessage = "Account created but failed to save profile: \(error.localizedDescription)"
                                self?.isLoading = false
                                completion(false)
                            }
                            print("❌ Error creating user profile: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Google Sign-In
    
    func signInWithGoogle(completion: @escaping (Bool, Bool) -> Void) {
        isLoading = true
        errorMessage = ""
        
        guard let presentingViewController = UIApplication.shared.windows.first?.rootViewController else {
            errorMessage = "Could not get presenting view controller"
            isLoading = false
            completion(false, false)
            return
        }
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            errorMessage = "Could not get Firebase client ID"
            isLoading = false
            completion(false, false)
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
                    completion(false, false)
                    return
                }
                
                guard let user = result?.user,
                      let idToken = user.idToken?.tokenString else {
                    self?.errorMessage = "Failed to get Google ID token"
                    self?.isLoading = false
                    completion(false, false)
                    return
                }
                
                let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                              accessToken: user.accessToken.tokenString)
                
                // Sign in to Firebase with Google credentials
                Auth.auth().signIn(with: credential) { authResult, error in
                    DispatchQueue.main.async {
                        if let error = error {
                            self?.errorMessage = error.localizedDescription
                            self?.isLoading = false
                            print("Firebase Google Sign-In error: \(error.localizedDescription)")
                            completion(false, false)
                        } else if let authResult = authResult {
                            // Check if this is a new user
                            let isNewUser = authResult.additionalUserInfo?.isNewUser ?? false
                            
                            if isNewUser {
                                print("New Google user signed up")
                                
                                // Create user profile in Firestore for new Google users
                                let firebaseUser = authResult.user
                                let newUser = User(
                                    uid: firebaseUser.uid,
                                    fullName: firebaseUser.displayName ?? "Google User",
                                    email: firebaseUser.email ?? ""
                                )
                                
                                Task {
                                    do {
                                        try await self?.firestoreService.createUser(newUser)
                                        DispatchQueue.main.async {
                                            self?.isLoading = false
                                            self?.currentUser = newUser
                                            print("Google user profile created successfully")
                                            completion(true, true)
                                        }
                                    } catch {
                                        DispatchQueue.main.async {
                                            self?.isLoading = false
                                            completion(false, false)
                                        }
                                        print("Error creating Google user profile: \(error.localizedDescription)")
                                    }
                                }
                            } else {
                                self?.isLoading = false
                                print("Existing Google user signed in")
                                completion(true, false)
                            }
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
            currentUser = nil
            print("Successfully signed out")
        } catch {
            errorMessage = "Error signing out: \(error.localizedDescription)"
            print("Sign out error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - User Profile Updates
    
    func updateBiometricSettings(enabled: Bool, hasCompletedOnboarding: Bool) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        do {
            try await firestoreService.updateBiometricSettings(
                uid: uid,
                enabled: enabled,
                hasCompletedOnboarding: hasCompletedOnboarding
            )
            
            // Update local user object
            DispatchQueue.main.async {
                self.currentUser?.biometricEnabled = enabled
                self.currentUser?.hasCompletedOnboarding = hasCompletedOnboarding
            }
        } catch {
            print("Error updating biometric settings: \(error.localizedDescription)")
        }
    }
} 