//
//  ContentView.swift
//  FinWise
//
//  Created by Yaduraj Singh on 22/06/25.
//

import SwiftUI
import AuthenticationServices
import LocalAuthentication

struct ContentView: View {
    @StateObject private var launchViewModel = LaunchViewModel()
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    @StateObject private var authViewModel = AuthenticationViewModel()
    @StateObject private var firebaseAuth = FirebaseAuthService()
    @State private var showOnboarding = true
    @State private var showAuthentication = false
    @State private var needsBiometricAuth = false
    @State private var hasCheckedBiometric = false
    
    var body: some View {
        ZStack {
            if !launchViewModel.isLaunchFinished {
                // Show launch screen
                LaunchView()
                    .transition(.opacity)
            } else if needsBiometricAuth && !authViewModel.isAuthenticated {
                // Show biometric authentication screen
                BiometricAuthView()
                    .environmentObject(authViewModel)
                    .transition(.opacity)
            } else if showOnboarding && !showAuthentication && !authViewModel.isAuthenticated {
                // Show onboarding screens
                OnboardingView(showAuthentication: $showAuthentication)
                    .transition(.opacity)
            } else if !authViewModel.isAuthenticated {
                // Show authentication flow
                NavigationView {
                    AuthenticationView()
                        .environmentObject(firebaseAuth)
                        .environmentObject(authViewModel)
                        .navigationBarHidden(true)
                }
                .transition(.opacity)
            } else if authViewModel.showBiometricSetup {
                // Show biometric setup for new users
                BiometricSetupView()
                    .environmentObject(authViewModel)
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
        .onChange(of: launchViewModel.isLaunchFinished) { isFinished in
            if isFinished && !hasCheckedBiometric {
                checkBiometricAuth()
            }
        }
        .onChange(of: authViewModel.isAuthenticated) { isAuthenticated in
            print("🔐 ContentView: Authentication state changed to: \(isAuthenticated)")
            if !isAuthenticated {
                // Reset all states when user signs out
                resetAuthenticationStates()
            }
        }
    }
    
    private func checkBiometricAuth() {
        hasCheckedBiometric = true
        
        // Check if user has biometric enabled and stored credentials
        if authViewModel.isBiometricEnabled() && 
           UserDefaults.standard.string(forKey: "biometricUserEmail") != nil {
            print("🔐 User has biometric enabled, showing biometric auth")
            needsBiometricAuth = true
            showOnboarding = false
        } else {
            print("🔐 No biometric auth needed, proceeding normally")
            needsBiometricAuth = false
        }
    }
    
    private func resetAuthenticationStates() {
        print("🔐 Resetting authentication states")
        needsBiometricAuth = false
        hasCheckedBiometric = false
        showOnboarding = true
        showAuthentication = false
    }
    
    @ViewBuilder
    private var mainContent: some View {
        // Signed in view - Main App Dashboard
        VStack(spacing: 20) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text("Welcome to FinWise!")
                .font(.title)
                .fontWeight(.bold)
            
            if !authViewModel.userName.isEmpty {
                Text("Hello, \(authViewModel.userName)")
                    .font(.headline)
            }
            
            // Show biometric status
            if authViewModel.isBiometricEnabled() {
                HStack {
                    Image(systemName: "checkmark.shield")
                        .foregroundColor(.green)
                    Text("\(authViewModel.getBiometricType()) is enabled")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            
            Button("Sign Out") {
                print("🔐 Sign out button tapped")
                authViewModel.signOut()
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(Color.red)
            .cornerRadius(10)
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

// MARK: - Biometric Authentication View for Returning Users
struct BiometricAuthView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Green background
                Color.finWiseGreen
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Status bar area
                    HStack {
                        Text("16:04")
                            .font(.custom("Poppins-SemiBold", size: 17))
                            .foregroundColor(.black)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Title
                    Text("Welcome Back")
                        .font(.custom("Poppins-Bold", size: 28))
                        .foregroundColor(.black)
                        .padding(.top, 40)
                    
                    Spacer()
                    
                    // Main content card
                    VStack(spacing: 0) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 60)
                                .fill(Color.white.opacity(0.9))
                                .frame(maxWidth: .infinity)
                                .frame(height: geometry.size.height * 0.65)
                            
                            VStack(spacing: 30) {
                                Spacer()
                                
                                // Biometric icon
                                ZStack {
                                    Circle()
                                        .fill(Color.finWiseGreen)
                                        .frame(width: 120, height: 120)
                                    
                                    Image(systemName: getBiometricIcon())
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.white)
                                }
                                
                                VStack(spacing: 15) {
                                    Text("Use \(authViewModel.getBiometricType()) to Access")
                                        .font(.custom("Poppins-Bold", size: 22))
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                    
                                    Text("Authenticate with \(authViewModel.getBiometricType()) to securely access your FinWise account.")
                                        .font(.custom("Poppins-Regular", size: 14))
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.center)
                                        .lineSpacing(2)
                                }
                                
                                if !errorMessage.isEmpty {
                                    Text(errorMessage)
                                        .font(.custom("Poppins-Regular", size: 14))
                                        .foregroundColor(.red)
                                        .multilineTextAlignment(.center)
                                }
                                
                                Spacer()
                                
                                VStack(spacing: 15) {
                                    // Authenticate button
                                    Button(action: {
                                        authenticateWithBiometrics()
                                    }) {
                                        Text("Authenticate with \(authViewModel.getBiometricType())")
                                            .font(.custom("Poppins-SemiBold", size: 16))
                                            .foregroundColor(.black)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 50)
                                            .background(Color.finWiseGreen.opacity(0.3))
                                            .cornerRadius(25)
                                    }
                                    .padding(.horizontal, 30)
                                    
                                    // Use different method button
                                    Button(action: {
                                        useAlternativeLogin()
                                    }) {
                                        Text("Use Email & Password")
                                            .font(.custom("Poppins-Regular", size: 14))
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                                Spacer()
                            }
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            // Automatically trigger biometric authentication when view appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                authenticateWithBiometrics()
            }
        }
    }
    
    private func getBiometricIcon() -> String {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            switch context.biometryType {
            case .faceID:
                return "faceid"
            case .touchID:
                return "touchid"
            default:
                return "person.fill.questionmark"
            }
        }
        return "person.fill.questionmark"
    }
    
    private func authenticateWithBiometrics() {
        errorMessage = ""
        authViewModel.authenticateWithBiometrics { success in
            if !success {
                errorMessage = "Authentication failed. Please try again."
            }
        }
    }
    
    private func useAlternativeLogin() {
        print("🔐 User chose alternative login, clearing biometric data")
        // Clear biometric credentials and show login screen
        authViewModel.clearBiometricData()
    }
}

#Preview {
    ContentView()
}
