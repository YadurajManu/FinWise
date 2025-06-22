import SwiftUI
import LocalAuthentication

struct BiometricSetupView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var showingMainApp = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Green background
                Color.finWiseGreen
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Status bar area - simplified without icons
                    HStack {
                        Text("16:04")
                            .font(.custom("Poppins-SemiBold", size: 17))
                            .foregroundColor(.black)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Title - dynamic based on biometric type
                    Text("Security \(getBiometricTitle())")
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
                                
                                // Biometric icon - dynamic based on device
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
                                    Text("Use \(authViewModel.getBiometricType()) To Access")
                                        .font(.custom("Poppins-Bold", size: 22))
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                    
                                    Text("Secure your FinWise account with biometric authentication for quick and safe access to your financial data.")
                                        .font(.custom("Poppins-Regular", size: 14))
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.center)
                                        .lineSpacing(2)
                                }
                                
                                Spacer()
                                
                                VStack(spacing: 15) {
                                    // Use Biometric button - dynamic text
                                    Button(action: {
                                        setupBiometricAuthentication()
                                    }) {
                                        Text("Use \(authViewModel.getBiometricType())")
                                            .font(.custom("Poppins-SemiBold", size: 16))
                                            .foregroundColor(.black)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 50)
                                            .background(Color.finWiseGreen.opacity(0.3))
                                            .cornerRadius(25)
                                    }
                                    .padding(.horizontal, 30)
                                    
                                    // Skip button - simplified
                                    Button(action: {
                                        skipBiometricSetup()
                                    }) {
                                        Text("Skip for now")
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
        .fullScreenCover(isPresented: $showingMainApp) {
            // Navigate to main app
            Text("Main App") // Replace with your main app view
        }
    }
    
    private func getBiometricTitle() -> String {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            switch context.biometryType {
            case .faceID:
                return "Face ID"
            case .touchID:
                return "Fingerprint"
            default:
                return "Biometric"
            }
        }
        return "Biometric"
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
    
    private func setupBiometricAuthentication() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let biometricType = authViewModel.getBiometricType()
            let reason = "Set up \(biometricType) authentication for secure access to FinWise"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        // Store biometric preference and user data
                        self.authViewModel.completeBiometricSetup()
                        self.showingMainApp = true
                    } else {
                        // Handle error
                        print("Biometric authentication failed: \(authenticationError?.localizedDescription ?? "Unknown error")")
                    }
                }
            }
        } else {
            // Biometric not available
            print("Biometric authentication not available: \(error?.localizedDescription ?? "Unknown error")")
            skipBiometricSetup()
        }
    }
    
    private func skipBiometricSetup() {
        authViewModel.skipBiometricSetup()
        showingMainApp = true
    }
}

#Preview {
    BiometricSetupView()
        .environmentObject(AuthenticationViewModel())
} 