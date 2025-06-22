//
//  ContentView.swift
//  FinWise
//
//  Created by Yaduraj Singh on 22/06/25.
//

import SwiftUI
import AuthenticationServices

struct ContentView: View {
    @StateObject private var launchViewModel = LaunchViewModel()
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    @StateObject private var firebaseAuth = FirebaseAuthService()
    @State private var showOnboarding = true
    @State private var showAuthentication = false
    
    var body: some View {
        ZStack {
            if !launchViewModel.isLaunchFinished {
                // Show launch screen
                LaunchView()
                    .transition(.opacity)
            } else if showOnboarding && !showAuthentication && !firebaseAuth.isAuthenticated {
                // Show onboarding screens
                OnboardingView(showAuthentication: $showAuthentication)
                    .transition(.opacity)
            } else if !firebaseAuth.isAuthenticated {
                // Show authentication flow
                NavigationView {
                    AuthenticationView()
                        .environmentObject(firebaseAuth)
                        .navigationBarHidden(true)
                }
                .transition(.opacity)
            } else {
                // Show main app content
                NavigationView {
                    mainContent
                        .navigationBarHidden(true)
                }
                .transition(.opacity)
            }
        }
        .onChange(of: showAuthentication) { newValue in
            if newValue {
                showOnboarding = false
            }
        }
    }
    
    @ViewBuilder
    private var mainContent: some View {
        // Signed in view - Main App Dashboard
        VStack {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text("Welcome to FinWise!")
                .font(.title)
                .fontWeight(.bold)
            
            if !firebaseAuth.userName.isEmpty {
                Text("Hello, \(firebaseAuth.userName)")
                    .font(.headline)
            }
            
            Button("Sign Out") {
                firebaseAuth.signOut()
            }
            .foregroundColor(.red)
        }
        .padding()
    }
    
    private func handleSignInResult(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                // Handle successful sign in
                let userID = appleIDCredential.user
                let email = appleIDCredential.email
                let fullName = appleIDCredential.fullName
                
                // Store user info in Firebase auth service
                firebaseAuth.isAuthenticated = true
                firebaseAuth.userEmail = email ?? "apple.user@icloud.com"
                firebaseAuth.userName = fullName?.givenName ?? "Apple User"
                
                print("User ID: \(userID)")
                print("Email: \(email ?? "Not provided")")
                print("Name: \(fullName?.givenName ?? "Not provided")")
            }
        case .failure(let error):
            print("Sign in failed: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ContentView()
}
