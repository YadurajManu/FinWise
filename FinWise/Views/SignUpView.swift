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
    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false
    @EnvironmentObject var authViewModel: AuthenticationViewModel
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
                                    
                                    HStack {
                                        TextField("Enter your phone number", text: $mobileNumber)
                                            .font(.poppins(size: 14, weight: .regular))
                                            .foregroundColor(.black)
                                            .keyboardType(.phonePad)
                                            .onChange(of: mobileNumber) { newValue in
                                                mobileNumber = formatPhoneNumber(newValue)
                                            }
                                        
                                        Image(systemName: "phone")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 16))
                                    }
                                    .padding(.horizontal, 16)
                                    .frame(height: 41)
                                    .background(Color(red: 0.87, green: 0.97, blue: 0.89))
                                    .cornerRadius(18)
                                }
                                .padding(.horizontal, 40)
                                
                                // Date of Birth Field
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Date Of Birth")
                                        .font(.poppins(size: 16, weight: .medium))
                                        .foregroundColor(.black)
                                    
                                    Button(action: {
                                        showDatePicker = true
                                    }) {
                                        HStack {
                                            Text(dateOfBirth.isEmpty ? "Select your date of birth" : dateOfBirth)
                                                .font(.poppins(size: 14, weight: .regular))
                                                .foregroundColor(dateOfBirth.isEmpty ? .gray : .black)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "calendar")
                                                .foregroundColor(.gray)
                                                .font(.system(size: 16))
                                        }
                                        .padding(.horizontal, 16)
                                        .frame(height: 41)
                                        .background(Color(red: 0.87, green: 0.97, blue: 0.89))
                                        .cornerRadius(18)
                                    }
                                    .sheet(isPresented: $showDatePicker) {
                                        DatePickerSheet(
                                            selectedDate: $selectedDate,
                                            dateOfBirth: $dateOfBirth,
                                            isPresented: $showDatePicker
                                        )
                                    }
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
                                if !authViewModel.errorMessage.isEmpty {
                                    Text(authViewModel.errorMessage)
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
                                    authViewModel.signUpWithEmail(fullName: fullName, email: email, password: password, confirmPassword: confirmPassword, mobileNumber: mobileNumber, dateOfBirth: dateOfBirth)
                                }) {
                                    if authViewModel.isLoading {
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
                                .disabled(authViewModel.isLoading)
                                .padding(.horizontal, 40)
                                .padding(.top, 20)
                                
                                // Google Sign Up Section
                                VStack(spacing: 15) {
                                    Text("or sign up with")
                                        .font(.poppins(size: 12, weight: .regular))
                                        .foregroundColor(.gray)
                                    
                                    // Google Sign Up Button
                                    Button(action: {
                                        authViewModel.signInWithGoogle()
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
                                    .disabled(authViewModel.isLoading)
                                    .padding(.horizontal, 40)
                                }
                                .padding(.top, 10)
                                
                                // Bottom Login Text
                                HStack {
                                    Text("Already have an account? ")
                                        .font(.poppins(size: 14, weight: .regular))
                                        .foregroundColor(.black)
                                    
                                    NavigationLink(destination: LoginView().environmentObject(firebaseAuth).environmentObject(authViewModel)) {
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
        .fullScreenCover(isPresented: $authViewModel.showBiometricSetup) {
            BiometricSetupView()
                .environmentObject(authViewModel)
        }
        .onChange(of: authViewModel.showBiometricSetup) { newValue in
            print("🔐 SignUpView: showBiometricSetup changed to: \(newValue)")
        }
    }
    
    private func formatPhoneNumber(_ number: String) -> String {
        // Remove all non-numeric characters
        let cleanNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        // Limit to 15 digits (international standard)
        let limitedNumber = String(cleanNumber.prefix(15))
        
        // Format based on length
        switch limitedNumber.count {
        case 0:
            return ""
        case 1...3:
            return limitedNumber
        case 4...6:
            let firstPart = String(limitedNumber.prefix(3))
            let secondPart = String(limitedNumber.dropFirst(3))
            return "\(firstPart) \(secondPart)"
        case 7...10:
            let firstPart = String(limitedNumber.prefix(3))
            let secondPart = String(limitedNumber.dropFirst(3).prefix(3))
            let thirdPart = String(limitedNumber.dropFirst(6))
            return "\(firstPart) \(secondPart) \(thirdPart)"
        default:
            let firstPart = String(limitedNumber.prefix(3))
            let secondPart = String(limitedNumber.dropFirst(3).prefix(3))
            let thirdPart = String(limitedNumber.dropFirst(6).prefix(4))
            let fourthPart = String(limitedNumber.dropFirst(10))
            return "\(firstPart) \(secondPart) \(thirdPart) \(fourthPart)"
        }
    }
}

struct DatePickerSheet: View {
    @Binding var selectedDate: Date
    @Binding var dateOfBirth: String
    @Binding var isPresented: Bool
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    private let dateFormatterForStorage: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("Select Your Date of Birth")
                    .font(.poppins(size: 24, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.top, 20)
                
                DatePicker(
                    "Date of Birth",
                    selection: $selectedDate,
                    in: ...Date(),
                    displayedComponents: .date
                )
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .padding(.horizontal, 20)
                
                VStack(spacing: 8) {
                    Text("Selected Date:")
                        .font(.poppins(size: 16, weight: .medium))
                        .foregroundColor(.gray)
                    
                    Text(dateFormatter.string(from: selectedDate))
                        .font(.poppins(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                VStack(spacing: 15) {
                    Button("Confirm") {
                        dateOfBirth = dateFormatterForStorage.string(from: selectedDate)
                        isPresented = false
                    }
                    .font(.poppins(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.finWiseGreen)
                    .cornerRadius(25)
                    .padding(.horizontal, 40)
                    
                    Button("Cancel") {
                        isPresented = false
                    }
                    .font(.poppins(size: 16, weight: .regular))
                    .foregroundColor(.gray)
                }
                .padding(.bottom, 30)
            }
            .background(Color(red: 0.95, green: 1, blue: 0.95))
            .navigationBarHidden(true)
        }
        .onAppear {
            // Set initial date to 18 years ago for better UX
            let calendar = Calendar.current
            if let eighteenYearsAgo = calendar.date(byAdding: .year, value: -18, to: Date()) {
                selectedDate = eighteenYearsAgo
            }
        }
    }
}

#Preview {
    SignUpView()
        .environmentObject(FirebaseAuthService())
        .environmentObject(AuthenticationViewModel())
}