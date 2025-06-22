//
//  OnboardingView.swift
//  FinWise
//
//  Created by Yaduraj Singh on 22/06/25.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentTab = 0
    @Binding var showAuthentication: Bool
    
    var body: some View {
        TabView(selection: $currentTab) {
            // First Onboarding Screen
            OnboardingScreen1()
                .tag(0)
            
            // Second Onboarding Screen
            OnboardingScreen2(showAuthentication: $showAuthentication)
                .tag(1)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .animation(.easeInOut(duration: 0.8), value: currentTab)
        .ignoresSafeArea()
    }
}

struct OnboardingScreen1: View {
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Top Green Section
                VStack {
                    Spacer()
                    
                    Text("Welcome To\nFinWise")
                        .font(.poppins(size: 32, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.05, green: 0.24, blue: 0.24))
                        .padding(.horizontal, 40)
                    
                    Spacer()
                }
                .frame(height: 300)
                .frame(maxWidth: .infinity)
                .background(Color.finWiseGreen)
                
                // Bottom Light Section with rounded top corners
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Illustration with background circle
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.87, green: 0.97, blue: 0.89))
                            .frame(width: 280, height: 280)
                        
                        Image("OB1")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 240, height: 240)
                    }
                    .padding(.top, 40)
                    
                    Spacer()
                    
                    // Next Button
                    Text("Next")
                        .font(.poppins(size: 28, weight: .semibold))
                        .foregroundColor(Color(red: 0.05, green: 0.24, blue: 0.24))
                        .padding(.bottom, 30)
                    
                    // Page Indicator
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.finWiseGreen)
                            .frame(width: 12, height: 12)
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 12, height: 12)
                    }
                    .padding(.bottom, 90)
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
        .background(Color(red: 0, green: 0.82, blue: 0.62))
        .cornerRadius(60)
        .ignoresSafeArea()
    }
}

struct OnboardingScreen2: View {
    @Binding var showAuthentication: Bool
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Top Green Section
                VStack {
                    Spacer()
                    
                    Text("Are You Ready To\nTake Control Of\nYour Finances?")
                        .font(.poppins(size: 32, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.05, green: 0.24, blue: 0.24))
                        .padding(.horizontal, 40)
                    
                    Spacer()
                }
                .frame(height: 300)
                .frame(maxWidth: .infinity)
                .background(Color.finWiseGreen)
                
                // Bottom Light Section with rounded top corners
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Illustration with background circle
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.87, green: 0.97, blue: 0.89))
                            .frame(width: 280, height: 280)
                        
                        Image("OB2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 240, height: 240)
                    }
                    .padding(.top, 40)
                    
                    Spacer()
                    
                    // Next Button
                    Button(action: {
                        showAuthentication = true
                    }) {
                        Text("Next")
                            .font(.poppins(size: 28, weight: .semibold))
                            .foregroundColor(Color(red: 0.05, green: 0.24, blue: 0.24))
                    }
                    .padding(.bottom, 30)
                    
                    // Page Indicator
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 12, height: 12)
                        Circle()
                            .fill(Color.finWiseGreen)
                            .frame(width: 12, height: 12)
                    }
                    .padding(.bottom, 90)
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
        .background(Color(red: 0, green: 0.82, blue: 0.62))
        .cornerRadius(60)
        .ignoresSafeArea()
    }
}

#Preview {
    OnboardingView(showAuthentication: .constant(false))
} 