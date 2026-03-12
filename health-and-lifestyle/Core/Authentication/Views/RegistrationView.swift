import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var fullName = ""
    @State private var confirmPassword = ""
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var emailError: String? = nil
    @State private var passwordError: String? = nil
    @State private var confirmPasswordError: String? = nil
    @State private var registrationError: String? = nil
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    private func validateFields() -> Bool {
        emailError = nil
        passwordError = nil
        confirmPasswordError = nil
        registrationError = nil
        
        var isValid = true
        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            emailError = "Email is required."
            isValid = false
        } else if !isValidEmail(email) {
            emailError = "Invalid email format."
            isValid = false
        }
        if password.isEmpty {
            passwordError = "Password is required."
            isValid = false
        }
        if confirmPassword != password {
            confirmPasswordError = "Passwords do not match."
            isValid = false
        }
        return isValid
    }

    private let bgColor = Color(red: 0x45/255, green: 0x42/255, blue: 0x42/255)

    var body: some View {
        ZStack {
            bgColor.ignoresSafeArea()

            VStack {
                Image("movement-logo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 120)
                    .padding(.vertical, 32)

                HStack {
                    Text("Movement")
                        .font(.system(size: 40))
                        .foregroundStyle(Color.white)
                        .fontWeight(.bold)
                }

                VStack(spacing: 24) {
                    InputView(text: $email,
                              title: "Email address",
                              placeholder: "name@example.com",
                              titleColor: .white.opacity(0.7),
                              textColor: .white,
                              borderColor: .white.opacity(0.3),
                              placeholderColor: .white.opacity(0.35))
                        .autocapitalization(.none)
                    if let emailError {
                        HStack {
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundStyle(Color.red)
                            Text(emailError)
                                .foregroundColor(.red)
                                .font(.footnote)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }

                    InputView(text: $fullName,
                              title: "Full name",
                              placeholder: "Enter your full name",
                              titleColor: .white.opacity(0.7),
                              textColor: .white,
                              borderColor: .white.opacity(0.3),
                              placeholderColor: .white.opacity(0.35))
                        .autocapitalization(.none)

                    InputView(text: $password,
                              title: "Password",
                              placeholder: "Enter your password",
                              isSecureField: true,
                              titleColor: .white.opacity(0.7),
                              textColor: .white,
                              borderColor: .white.opacity(0.3),
                              placeholderColor: .white.opacity(0.35))
                    if let passwordError {
                        HStack {
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundStyle(Color.red)
                            Text(passwordError)
                                .foregroundColor(.red)
                                .font(.footnote)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }

                    InputView(text: $confirmPassword,
                              title: "Confirm password",
                              placeholder: "Enter your password again",
                              isSecureField: true,
                              titleColor: .white.opacity(0.7),
                              textColor: .white,
                              borderColor: .white.opacity(0.3),
                              placeholderColor: .white.opacity(0.35))
                    if let confirmPasswordError {
                        HStack {
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundStyle(Color.red)
                            Text(confirmPasswordError)
                                .foregroundColor(.red)
                                .font(.footnote)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)

                if let registrationError {
                    HStack {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundStyle(Color.red)
                        Text(registrationError)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal)
                    .padding(.top, 4)
                }

                Button {
                    if validateFields() {
                        viewModel.createUser(withEmail: email, password: password, fullname: fullName) { errorMsg in
                            if let errorMsg {
                                registrationError = errorMsg
                            } else {
                                dismiss()
                            }
                        }
                    }
                } label: {
                    HStack {
                        if viewModel.isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Sign up")
                                .fontWeight(.semibold)
                            Image(systemName: "arrow.right")
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                }
                .background(viewModel.isLoading ? Color.gray : Color(red: 232/255, green: 98/255, blue: 61/255))
                .cornerRadius(24)
                .padding(.horizontal, 16)
                .padding(.top, 24)
                .disabled(viewModel.isLoading)
                .animation(.easeInOut(duration: 0.2), value: viewModel.isLoading)

                Spacer()

                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 3) {
                        Text("Already have an account?")
                            .foregroundColor(.white)
                        Text("Sign in")
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 232/255, green: 98/255, blue: 61/255))
                    }
                    .font(.system(size: 16))
                }
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
            .environmentObject(AuthViewModel())
    }
}
