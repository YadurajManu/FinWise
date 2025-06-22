//
//  AuthenticationViewModel.swift
//  FinWise
//
//  Created by Yaduraj Singh on 22/06/25.
//

import Foundation
import SwiftUI

class AuthenticationViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var userEmail = ""
    @Published var userName = ""
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    func signInWithEmail(email: String, password: String) {
        isLoading = true
        errorMessage = ""
        
        // Simulate authentication delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Simple validation for demo
            if !email.isEmpty && !password.isEmpty && email.contains("@") {
                self.isAuthenticated = true
                self.userEmail = email
                self.userName = email.components(separatedBy: "@").first ?? "User"
            } else {
                self.errorMessage = "Please enter valid email and password"
            }
            self.isLoading = false
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
        
        // Simulate sign up delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isAuthenticated = true
            self.userEmail = email
            self.userName = fullName
            self.isLoading = false
        }
    }
    
    func signInWithGoogle() {
        isLoading = true
        errorMessage = ""
        
        // Simulate Google Sign-In delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // Simulate successful Google sign-in
            self.isAuthenticated = true
            self.userEmail = "user@gmail.com"
            self.userName = "Google User"
            self.isLoading = false
        }
    }
    
    func signOut() {
        isAuthenticated = false
        userEmail = ""
        userName = ""
        errorMessage = ""
    }
} 