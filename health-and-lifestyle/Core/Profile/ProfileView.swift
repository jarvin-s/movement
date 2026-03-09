import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
            if let user = viewModel.currentUser {
                Section {
                    HStack {
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray3))
                            .clipShape(Circle())

                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.fullname)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.top, 4)

                            Text(user.email)
                                .font(.footnote)
                                .foregroundStyle(.gray)
                        }
                    }
                }
            }

            Section("General") {
                HStack {
                    SettingsRowView(
                        imageName: "gear",
                        title: "Version",
                        tintColor: Color(.systemGray)
                    )

                    Spacer()

                    Text("1.0")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }

            Section("Account") {
                Button {
                    dismiss()
                } label: {
                    SettingsRowView(
                        imageName: "house.fill",
                        title: "Back to home",
                        tintColor: Color.black
                    )
                }
                Button {
                    viewModel.signOut()
                } label: {
                    SettingsRowView(
                        imageName: "arrow.left.circle.fill",
                        title: "Sign out",
                        tintColor: Color(.systemRed)
                    )
                }
                Button {
                    print("Delete account...")

                } label: {
                    SettingsRowView(
                        imageName: "xmark.circle.fill",
                        title: "Delete account",
                        tintColor: Color(.systemRed)
                    )
                }
            }
        }
        .onChange(of: viewModel.userSession) {
            if viewModel.userSession == nil {
                dismiss()
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
