import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var fullName = ""
    @State private var confirmPassword = ""
    @State private var showEmailForm = false
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var emailError: String? = nil
    @State private var passwordError: String? = nil
    @State private var confirmPasswordError: String? = nil
    @State private var registrationError: String? = nil

    private let accentOrange = Color(red: 232/255, green: 98/255, blue: 61/255)
    
    private let stars: [Star] = (0..<100).map { _ in
        Star(
            x: CGFloat.random(in: 0...1),
            y: CGFloat.random(in: 0...1),
            size: CGFloat.random(in: 0.8...2.8),
            opacity: Double.random(in: 0.4...1.0),
            twinkleDuration: Double.random(in: 1.5...4.5)
        )
    }

    var body: some View {
        ZStack {
             LinearGradient(
                colors: [
                    Color(red: 0.02, green: 0.03, blue: 0.10),
                    Color(red: 0.04, green: 0.06, blue: 0.18),
                    Color(red: 0.07, green: 0.04, blue: 0.14),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ZStack {
                Ellipse()
                    .fill(Color(red: 0.3, green: 0.1, blue: 0.6).opacity(0.12))
                    .frame(width: 280, height: 180)
                    .blur(radius: 60)
                    .offset(x: -80, y: -200)

                Ellipse()
                    .fill(Color(red: 0.1, green: 0.3, blue: 0.7).opacity(0.10))
                    .frame(width: 220, height: 150)
                    .blur(radius: 50)
                    .offset(x: 100, y: 180)
            }
            .ignoresSafeArea()

            StarfieldView(stars: stars)
                .ignoresSafeArea()

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

                if showEmailForm {
                    emailFormView
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                } else {
                    buttonPickerView
                        .transition(.opacity)
                }

                Spacer()

                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 3) {
                        Text("Already have an account?")
                            .foregroundColor(.white)
                        Text("Sign in")
                            .fontWeight(.bold)
                            .foregroundColor(accentOrange)
                    }
                    .font(.system(size: 16))
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showEmailForm)
    }

    private var buttonPickerView: some View {
        VStack(spacing: 12) {
            Button {
                showEmailForm = true
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "envelope.fill")
                        .font(.system(size: 16))
                    Text("Sign up with Email")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
            }
            .background(accentOrange)
            .cornerRadius(24)

            HStack {
                Rectangle()
                    .fill(.white.opacity(0.25))
                    .frame(height: 1)
                Text("OR")
                    .font(.footnote)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.5))
                Rectangle()
                    .fill(.white.opacity(0.25))
                    .frame(height: 1)
            }
            .padding(.vertical, 4)

            Button {
                viewModel.signInWithGoogle()
            } label: {
                HStack(spacing: 10) {
                    GoogleLogoView(size: 20)
                    Text("Sign up with Google")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
            }
            .background(Color.white.opacity(0.08))
            .cornerRadius(24)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(.white.opacity(0.2), lineWidth: 1)
            )
        }
        .padding(.horizontal, 16)
        .padding(.top, 32)
    }

    private var emailFormView: some View {
        VStack(spacing: 0) {
            Button {
                showEmailForm = false
                emailError = nil
                passwordError = nil
                confirmPasswordError = nil
                registrationError = nil
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .semibold))
                    Text("All sign up options")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .foregroundColor(.white.opacity(0.7))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.top, 16)

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
            .background(viewModel.isLoading ? Color.gray : accentOrange)
            .cornerRadius(24)
            .padding(.horizontal, 16)
            .padding(.top, 24)
            .disabled(viewModel.isLoading)
            .animation(.easeInOut(duration: 0.2), value: viewModel.isLoading)
        }
    }

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
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
            .environmentObject(AuthViewModel())
    }
}
