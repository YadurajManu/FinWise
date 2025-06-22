//
//  LoginView.swift
//  FinWise
//
//  Created by Yaduraj Singh on 22/06/25.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @EnvironmentObject var firebaseAuth: FirebaseAuthService
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Top Green Section
                VStack {
                    Spacer()
                    
                    Text("Welcome")
                        .font(.poppins(size: 36, weight: .semibold))
                        .foregroundColor(Color(red: 0.05, green: 0.24, blue: 0.24))
                    
                    Spacer()
                }
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .background(Color.finWiseGreen)
                
                // Bottom Light Section with rounded top corners
                VStack(spacing: 30) {
                    Spacer()
                    
                    // Email Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Username Or Email")
                            .font(.poppins(size: 16, weight: .medium))
                            .foregroundColor(.black)
                        
                                                 TextField("example@example.com", text: $email)
                             .font(.poppins(size: 14, weight: .regular))
                             .foregroundColor(.blue)
                            .padding(.horizontal, 16)
                            .frame(height: 41)
                            .background(
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .background(Color(red: 0.87, green: 0.97, blue: 0.89))
                                    .cornerRadius(18)
                            )
                    }
                    .padding(.horizontal, 40)
                    
                    // Password Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.poppins(size: 16, weight: .medium))
                            .foregroundColor(.black)
                        
                        HStack {
                            if isPasswordVisible {
                                TextField("Password", text: $password)
                                    .font(.poppins(size: 14, weight: .regular))
                                    .foregroundColor(.gray)
                            } else {
                                SecureField("••••••••", text: $password)
                                    .font(.poppins(size: 14, weight: .regular))
                                    .foregroundColor(.gray)
                            }
                            
                            Button(action: {
                                isPasswordVisible.toggle()
                            }) {
                                Image("Eye")
                                    .frame(width: 24.13636, height: 9)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 41)
                        .background(
                            Rectangle()
                                .foregroundColor(.clear)
                                .background(Color(red: 0.87, green: 0.97, blue: 0.89))
                                .cornerRadius(18)
                        )
                    }
                    .padding(.horizontal, 40)
                    
                    // Error Message
                    if !firebaseAuth.errorMessage.isEmpty {
                        Text(firebaseAuth.errorMessage)
                            .font(.poppins(size: 14, weight: .regular))
                            .foregroundColor(.red)
                            .padding(.horizontal, 40)
                    }
                    
                    // Log In Button
                    Button(action: {
                        firebaseAuth.signInWithEmail(email: email, password: password)
                                        }) {
                        if firebaseAuth.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        } else {
                            Text("Log In")
                                .font(.poppins(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: 45)
                    .background(Color.finWiseGreen)
                    .cornerRadius(22.5)
                    .disabled(firebaseAuth.isLoading)
                    .padding(.horizontal, 40)
                    
                    // Forgot Password
                    NavigationLink(destination: ForgotPasswordView()) {
                        Text("Forgot Password?")
                            .font(.leagueSpartan(size: 14, weight: .semibold))
                            .foregroundColor(Color(red: 0.04, green: 0.19, blue: 0.19))
                    }
                    
                    // Sign Up Link
                    Button(action: {
                        // Handle sign up
                    }) {
                        Text("Sign Up")
                            .font(.poppins(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                    }
                    
                    // Fingerprint Section
                    VStack(spacing: 8) {
                        HStack {
                            Text("Use ")
                                .font(.poppins(size: 14, weight: .regular))
                                .foregroundColor(.black)
                            Text("Fingerprint")
                                .font(.poppins(size: 14, weight: .regular))
                                .foregroundColor(.blue)
                            Text(" To Access")
                                .font(.poppins(size: 14, weight: .regular))
                                .foregroundColor(.black)
                        }
                        
                        Text("or sign up with")
                            .font(.poppins(size: 12, weight: .regular))
                            .foregroundColor(.gray)
                    }
                    
                    // Social Login Buttons
                    HStack {
                        Spacer()
                        
                        // Google Button
                        Button(action: {
                            firebaseAuth.signInWithGoogle()
                        }) {
                            Image("Google")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                        
                        Spacer()
                    }
                    
                    // Bottom Sign Up Text
                    HStack {
                        Text("Don't have an account? ")
                            .font(.poppins(size: 14, weight: .regular))
                            .foregroundColor(.black)
                        
                        NavigationLink(destination: SignUpView().environmentObject(firebaseAuth)) {
                            Text("Sign Up")
                                .font(.poppins(size: 14, weight: .regular))
                                .foregroundColor(.blue)
                        }
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .background(
                    Color(red: 0.95, green: 1, blue: 0.95)
                        .clipShape(
                            .rect(
                                topLeadingRadius: 60,
                                topTrailingRadius: 60
                            )
                        )
                )
            }
        }
        .frame(width: 430, height: 932)
        .background(Color.finWiseGreen)
        .cornerRadius(60)
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }
}

#Preview {
    LoginView()
} 
