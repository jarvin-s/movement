import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var emailError: String?
    @State private var passwordError: String?
    @State private var loginError: String?
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        VStack {
            Image("movement-logo")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 120)
                .padding(.vertical, 32)

            HStack {
                Text("Movement")
                    .font(.system(size: 40))
                    .fontWeight(.bold)
            }

            VStack(spacing: 24) {
                InputView(text: $email,
                          title: "Email address",
                          placeholder: "name@example.com")
                .autocapitalization(.none)
                
                if let emailError = emailError {
                    HStack{
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundStyle(Color.red)
                        Text(emailError)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                InputView(text: $password,
                          title: "Password",
                          placeholder: "Enter your password",
                          isSecureField: true)

                Button {
                } label: {
                    Text("Forgot your password?")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 232/255, green: 98/255, blue: 61/255))
                }
                .frame(maxWidth: .infinity, alignment: .trailing)

                if let passwordError = passwordError {
                    HStack {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundStyle(Color.red)
                        Text(passwordError)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                if viewModel.showWrongPasswordError {
                    HStack {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundStyle(Color.red)
                        Text("Password is incorrect.")
                            .foregroundColor(Color.red)
                            .cornerRadius(4)
                            .font(.footnote)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 12)

            Button {
                loginError = nil
                if validateFields() {
                    viewModel.signIn(withEmail: email, password: password)
                }
            } label: {
                HStack {
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Sign in")
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
            
            if let loginError = loginError {
                HStack {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundStyle(Color.red)
                    Text(loginError)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.top, 8)
            }

            Spacer()

            NavigationLink {
                RegistrationView()
                    .navigationBarBackButtonHidden(true)
            } label: {
                HStack(spacing: 3) {
                    Text("Don't have an account?")
                    Text("Sign up")
                        .fontWeight(.bold)
                }
                .foregroundColor(Color(red: 232/255, green: 98/255, blue: 61/255))
                .font(.system(size: 16))
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = #"^\S+@\S+\.\S+$"#
        return email.range(of: emailRegEx, options: .regularExpression) != nil
    }
    
    private func validateFields() -> Bool {
        emailError = nil
        passwordError = nil
        
        var valid = true
        
        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            emailError = "Email address is required."
            valid = false
        } else if !isValidEmail(email) {
            emailError = "Please enter a valid email address."
            valid = false
        }
        
        if password.isEmpty {
            passwordError = "Password is required."
            valid = false
        }
        
        return valid
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LoginView()
        }
        .environmentObject(AuthViewModel())
    }
}
