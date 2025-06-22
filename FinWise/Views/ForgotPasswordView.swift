import SwiftUI
import FirebaseAuth

struct ForgotPasswordView: View {
    @State private var email = ""
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            // Background
            Color.finWiseGreen
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top section with title and back button
                VStack(spacing: 20) {
                    // Back button
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(Color(red: 5/255, green: 24/255, blue: 24/255))
                                
                                Text("Back")
                                    .font(.poppins(size: 16, weight: .medium))
                                    .foregroundColor(Color(red: 5/255, green: 24/255, blue: 24/255))
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    Text("Forgot Password")
                        .font(.poppins(size: 32, weight: .semibold))
                        .foregroundColor(Color(red: 5/255, green: 24/255, blue: 24/255))
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                }
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                
                // Bottom section with form
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 30) {
                            // Reset Password section
                            VStack(alignment: .leading, spacing: 20) {
                                Text("Reset Password?")
                                    .font(.poppins(size: 24, weight: .semibold))
                                    .foregroundColor(Color(red: 5/255, green: 24/255, blue: 24/255))
                                
                                Text("Don't worry! Enter your email address below and we'll send you instructions to reset your password and get back into your FinWise account.")
                                    .font(.poppins(size: 14, weight: .regular))
                                    .foregroundColor(Color(red: 5/255, green: 24/255, blue: 24/255))
                                    .lineLimit(nil)
                                    .multilineTextAlignment(.leading)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 30)
                            .padding(.top, 40)
                            
                            // Email input section
                            VStack(spacing: 20) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Enter Email Address")
                                        .font(.poppins(size: 16, weight: .medium))
                                        .foregroundColor(Color(red: 5/255, green: 24/255, blue: 24/255))
                                    
                                    TextField("example@example.com", text: $email)
                                        .font(.poppins(size: 16, weight: .regular))
                                        .foregroundColor(Color(red: 5/255, green: 24/255, blue: 24/255))
                                        .padding(.horizontal, 20)
                                        .frame(height: 41)
                                        .background(Color(red: 135/255, green: 247/255, blue: 217/255))
                                        .cornerRadius(18)
                                        .keyboardType(.emailAddress)
                                        .autocapitalization(.none)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 30)
                                
                                // Next Step Button
                                Button(action: {
                                    resetPassword()
                                }) {
                                    HStack {
                                        if isLoading {
                                            ProgressView()
                                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                                .scaleEffect(0.8)
                                        } else {
                                            Text("Next Step")
                                                .font(.poppins(size: 18, weight: .semibold))
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 45)
                                    .background(Color.finWiseGreen)
                                    .cornerRadius(22.5)
                                }
                                .disabled(isLoading || email.isEmpty)
                                .opacity(isLoading || email.isEmpty ? 0.7 : 1.0)
                                .padding(.horizontal, 30)
                                .padding(.top, 10)
                            }
                            
                            // Extra spacing at bottom
                            Spacer()
                                .frame(height: 100)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 248/255, green: 248/255, blue: 248/255))
                .cornerRadius(60)
            }
        }
        .navigationBarHidden(true)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alertTitle),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK")) {
                    if alertTitle == "Success" {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            )
        }
    }
    
    private func resetPassword() {
        guard !email.isEmpty else {
            showAlert(title: "Error", message: "Please enter your email address")
            return
        }
        
        guard isValidEmail(email) else {
            showAlert(title: "Error", message: "Please enter a valid email address")
            return
        }
        
        isLoading = true
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            DispatchQueue.main.async {
                isLoading = false
                
                if let error = error {
                    showAlert(title: "Error", message: error.localizedDescription)
                } else {
                    showAlert(title: "Success", message: "Password reset email sent! Please check your inbox and follow the instructions to reset your password.")
                }
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
} 