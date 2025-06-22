//
//  AuthenticationView.swift
//  FinWise
//
//  Created by Yaduraj Singh on 22/06/25.
//

import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var firebaseAuth: FirebaseAuthService
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 40) {
                Spacer()
                
                // Logo
                Image("FinWise2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 140, height: 140)
                
                // App Name
                Text("FinWise")
                    .font(.poppins(size: 40, weight: .bold))
                    .foregroundColor(Color.finWiseGreen)
                
                // Description
                Text("Take control of your finances with smart budgeting, expense tracking, and personalized insights.")
                    .font(.poppins(size: 16, weight: .regular))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 50)
                    .lineLimit(nil)
                
                Spacer()
                
                // Buttons Section
                VStack(spacing: 20) {
                    // Log In Button
                    NavigationLink(destination: LoginView().environmentObject(firebaseAuth)) {
                        Text("Log In")
                            .font(.poppins(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(width: 207, height: 45)
                            .background(Color.finWiseGreen)
                            .cornerRadius(22.5)
                    }
                    
                    // Sign Up Button
                    NavigationLink(destination: SignUpView().environmentObject(firebaseAuth)) {
                        Text("Sign Up")
                            .font(.poppins(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(width: 207, height: 45)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 22.5)
                                    .stroke(Color.finWiseGreen, lineWidth: 2)
                            )
                            .cornerRadius(22.5)
                    }
                    
                    // Forgot Password
                    Button(action: {
                        // Handle forgot password
                    }) {
                        Text("Forgot Password?")
                            .font(
                                Font.custom("League Spartan", size: 14)
                                    .weight(.semibold)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.04, green: 0.19, blue: 0.19))
                            .frame(width: 127, alignment: .center)
                    }
                    .padding(.top, 15)
                }
                
                Spacer()
            }
            .padding(.horizontal, 40)
        }
        .frame(width: 430, height: 932)
        .background(Color(red: 0.95, green: 1, blue: 0.95))
        .cornerRadius(40)
        .ignoresSafeArea()

    }
}

#Preview {
    AuthenticationView()
} 