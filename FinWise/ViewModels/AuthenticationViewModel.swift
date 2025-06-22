//
//  AuthenticationViewModel.swift
//  FinWise
//
//  Created by Yaduraj Singh on 22/06/25.
//

import Foundation
import SwiftUI
import LocalAuthentication
import Combine

class AuthenticationViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var userEmail = ""
    @Published var userName = ""
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var showBiometricSetup = false
    
    private let firebaseAuth = FirebaseAuthService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupFirebaseObserver()
    }
    
    private func setupFirebaseObserver() {
        // Observe Firebase auth state changes
        firebaseAuth.$isAuthenticated
            .sink { [weak self] isAuthenticated in
                print("🔐 Authentication state changed: \(isAuthenticated)")
                self?.isAuthenticated = isAuthenticated
            }
            .store(in: &cancellables)
        
        firebaseAuth.$userEmail
            .assign(to: \.userEmail, on: self)
            .store(in: &cancellables)
        
        firebaseAuth.$userName
            .assign(to: \.userName, on: self)
            .store(in: &cancellables)
        
        firebaseAuth.$isLoading
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)
        
        firebaseAuth.$errorMessage
            .assign(to: \.errorMessage, on: self)
            .store(in: &cancellables)
    }
    
    func signInWithEmail(email: String, password: String) {
        print("🔐 Sign in with email initiated")
        firebaseAuth.signInWithEmail(email: email, password: password)
    }
    
    func signUpWithEmail(fullName: String, email: String, password: String, confirmPassword: String, mobileNumber: String = "", dateOfBirth: String = "") {
        print("🔐 Sign up with email initiated")
        firebaseAuth.signUpWithEmail(
            fullName: fullName, 
            email: email, 
            password: password, 
            confirmPassword: confirmPassword, 
            mobileNumber: mobileNumber, 
            dateOfBirth: dateOfBirth
        ) { [weak self] success in
            if success {
                print("🔐 Signup successful, triggering biometric setup")
                print("🔐 Current showBiometricSetup state: \(self?.showBiometricSetup ?? false)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    print("🔐 Setting showBiometricSetup to true")
                    self?.showBiometricSetup = true
                    print("🔐 showBiometricSetup is now: \(self?.showBiometricSetup ?? false)")
                }
            } else {
                print("🔐 Signup failed")
            }
        }
    }
    
    func signInWithGoogle() {
        print("🔐 Sign in with Google initiated")
        firebaseAuth.signInWithGoogle { [weak self] success, isNewUser in
            if success && isNewUser {
                print("🔐 Google signup successful, triggering biometric setup")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self?.showBiometricSetup = true
                }
            }
        }
    }
    
    func signOut() {
        print("🔐 Sign out initiated")
        firebaseAuth.signOut()
        showBiometricSetup = false
        // Note: We don't clear biometric settings on normal sign out
        // They should persist for the user's next login
    }
    
    func clearBiometricData() {
        // Only call this when user explicitly wants to disable biometrics
        UserDefaults.standard.removeObject(forKey: "biometricUserEmail")
        UserDefaults.standard.removeObject(forKey: "biometricUserName")
        UserDefaults.standard.removeObject(forKey: "biometricEnabled")
        UserDefaults.standard.removeObject(forKey: "hasCompletedOnboarding")
    }
    
    // MARK: - Biometric Authentication
    func authenticateWithBiometrics(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        // Check if biometric authentication is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Use Face ID or Touch ID to access FinWise"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        // Load stored user data
                        if let email = UserDefaults.standard.string(forKey: "biometricUserEmail"),
                           let name = UserDefaults.standard.string(forKey: "biometricUserName") {
                            self.isAuthenticated = true
                            self.userEmail = email
                            self.userName = name
                        }
                        completion(true)
                    } else {
                        self.errorMessage = "Biometric authentication failed"
                        completion(false)
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.errorMessage = "Biometric authentication not available"
                completion(false)
            }
        }
    }
    
    func completeBiometricSetup() {
        print("🔐 Biometric setup completed for user: \(userName)")
        // Store user data for biometric login
        UserDefaults.standard.set(userEmail, forKey: "biometricUserEmail")
        UserDefaults.standard.set(userName, forKey: "biometricUserName")
        UserDefaults.standard.set(true, forKey: "biometricEnabled")
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        
        // Update Firestore
        Task {
            await firebaseAuth.updateBiometricSettings(enabled: true, hasCompletedOnboarding: true)
        }
        
        showBiometricSetup = false
    }
    
    func skipBiometricSetup() {
        print("🔐 Biometric setup skipped for user: \(userName)")
        UserDefaults.standard.set(false, forKey: "biometricEnabled")
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        
        // Update Firestore
        Task {
            await firebaseAuth.updateBiometricSettings(enabled: false, hasCompletedOnboarding: true)
        }
        
        showBiometricSetup = false
    }
    
    func isBiometricEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: "biometricEnabled")
    }
    
    func getBiometricType() -> String {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            switch context.biometryType {
            case .faceID:
                return "Face ID"
            case .touchID:
                return "Touch ID"
            default:
                return "Biometric"
            }
        }
        return "Biometric"
    }
} 