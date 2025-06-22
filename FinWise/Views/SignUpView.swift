//
//  SignUpView.swift
//  FinWise
//
//  Created by Yaduraj Singh on 22/06/25.
//

import SwiftUI

struct SignUpView: View {
    @State private var fullName = ""
    @State private var email = ""
    @State private var mobileNumber = ""
    @State private var dateOfBirth = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false
    @EnvironmentObject var firebaseAuth: FirebaseAuthService
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color.finWiseGreen
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Top Green Section
                    VStack {
                        Spacer()
                        
                        Text("Create Account")
                            .font(.poppins(size: 36, weight: .semibold))
                            .foregroundColor(Color(red: 0.05, green: 0.24, blue: 0.24))
                        
                        Spacer()
                    }
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    
                    // Bottom Light Section with rounded top corners
                    VStack(spacing: 0) {
                        ScrollView {
                            VStack(spacing: 20) {
                                Spacer()
                                    .frame(height: 30)
                                
                                // Full Name Field
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Full Name")
                                        .font(.poppins(size: 16, weight: .medium))
                                        .foregroundColor(.black)
                                    
                                    TextField("John Doe", text: $fullName)
                                        .font(.poppins(size: 14, weight: .regular))
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 16)
                                        .frame(height: 41)
                                        .background(Color(red: 0.87, green: 0.97, blue: 0.89))
                                        .cornerRadius(18)
                                }
                                .padding(.horizontal, 40)
                                
                                // Email Field
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Email")
                                        .font(.poppins(size: 16, weight: .medium))
                                        .foregroundColor(.black)
                                    
                                    TextField("example@example.com", text: $email)
                                        .font(.poppins(size: 14, weight: .regular))
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 16)
                                        .frame(height: 41)
                                        .background(Color(red: 0.87, green: 0.97, blue: 0.89))
                                        .cornerRadius(18)
                                        .keyboardType(.emailAddress)
                                        .autocapitalization(.none)
                                }
                                .padding(.horizontal, 40)
                                
                                // Mobile Number Field
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Mobile Number")
                                        .font(.poppins(size: 16, weight: .medium))
                                        .foregroundColor(.black)
                                    
                                    TextField("+ 123 456 789", text: $mobileNumber)
                                        .font(.poppins(size: 14, weight: .regular))
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 16)
                                        .frame(height: 41)
                                        .background(Color(red: 0.87, green: 0.97, blue: 0.89))
                                        .cornerRadius(18)
                                        .keyboardType(.phonePad)
                                }
                                .padding(.horizontal, 40)
                                
                                // Date of Birth Field
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Date Of Birth")
                                        .font(.poppins(size: 16, weight: .medium))
                                        .foregroundColor(.black)
                                    
                                    TextField("DD / MM / YYYY", text: $dateOfBirth)
                                        .font(.poppins(size: 14, weight: .regular))
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 16)
                                        .frame(height: 41)
                                        .background(Color(red: 0.87, green: 0.97, blue: 0.89))
                                        .cornerRadius(18)
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
                                                .frame(width: 24, height: 24)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                    .frame(height: 41)
                                    .background(Color(red: 0.87, green: 0.97, blue: 0.89))
                                    .cornerRadius(18)
                                }
                                .padding(.horizontal, 40)
                                
                                // Confirm Password Field
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Confirm Password")
                                        .font(.poppins(size: 16, weight: .medium))
                                        .foregroundColor(.black)
                                    
                                    HStack {
                                        if isConfirmPasswordVisible {
                                            TextField("Confirm Password", text: $confirmPassword)
                                                .font(.poppins(size: 14, weight: .regular))
                                                .foregroundColor(.gray)
                                        } else {
                                            SecureField("••••••••", text: $confirmPassword)
                                                .font(.poppins(size: 14, weight: .regular))
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Button(action: {
                                            isConfirmPasswordVisible.toggle()
                                        }) {
                                            Image("Eye")
                                                .frame(width: 24, height: 24)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                    .frame(height: 41)
                                    .background(Color(red: 0.87, green: 0.97, blue: 0.89))
                                    .cornerRadius(18)
                                }
                                .padding(.horizontal, 40)
                                
                                // Error Message
                                if !firebaseAuth.errorMessage.isEmpty {
                                    Text(firebaseAuth.errorMessage)
                                        .font(.poppins(size: 14, weight: .regular))
                                        .foregroundColor(.red)
                                        .padding(.horizontal, 40)
                                }
                                
                                // Terms and Privacy
                                VStack(spacing: 8) {
                                    Text("By continuing, you agree to")
                                        .font(.poppins(size: 12, weight: .regular))
                                        .foregroundColor(.black)
                                    
                                    HStack {
                                        Text("Terms of Use")
                                            .font(.poppins(size: 12, weight: .regular))
                                            .foregroundColor(.blue)
                                        Text(" and ")
                                            .font(.poppins(size: 12, weight: .regular))
                                            .foregroundColor(.black)
                                        Text("Privacy Policy.")
                                            .font(.poppins(size: 12, weight: .regular))
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding(.top, 10)
                                
                                // Sign Up Button
                                Button(action: {
                                    firebaseAuth.signUpWithEmail(fullName: fullName, email: email, password: password, confirmPassword: confirmPassword)
                                }) {
                                    if firebaseAuth.isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                    } else {
                                        Text("Sign Up")
                                            .font(.poppins(size: 18, weight: .semibold))
                                            .foregroundColor(.black)
                                    }
                                }
                                .frame(maxWidth: .infinity, minHeight: 45)
                                .background(Color.finWiseGreen)
                                .cornerRadius(22.5)
                                .disabled(firebaseAuth.isLoading)
                                .padding(.horizontal, 40)
                                .padding(.top, 20)
                                
                                // Google Sign Up Section
                                VStack(spacing: 15) {
                                    Text("or sign up with")
                                        .font(.poppins(size: 12, weight: .regular))
                                        .foregroundColor(.gray)
                                    
                                    // Google Sign Up Button
                                    Button(action: {
                                        firebaseAuth.signInWithGoogle()
                                    }) {
                                        HStack {
                                            Image("Google")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                            
                                            Text("Sign up with Google")
                                                .font(.poppins(size: 16, weight: .medium))
                                                .foregroundColor(.black)
                                        }
                                        .frame(maxWidth: .infinity, minHeight: 45)
                                        .background(Color.white)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 22.5)
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                        )
                                        .cornerRadius(22.5)
                                    }
                                    .disabled(firebaseAuth.isLoading)
                                    .padding(.horizontal, 40)
                                }
                                .padding(.top, 10)
                                
                                // Bottom Login Text
                                HStack {
                                    Text("Already have an account? ")
                                        .font(.poppins(size: 14, weight: .regular))
                                        .foregroundColor(.black)
                                    
                                    NavigationLink(destination: LoginView().environmentObject(firebaseAuth)) {
                                        Text("Log In")
                                            .font(.poppins(size: 14, weight: .regular))
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding(.bottom, 40)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(red: 0.95, green: 1, blue: 0.95))
                    .cornerRadius(60)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    SignUpView()
        .environmentObject(FirebaseAuthService())
} 