import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
            Section {
                HStack {
                    Text(User.MOCK_USER.initials)
                        .font(.title)
                        .fontWeight(.semibold)
                        .frame(width: 72, height: 72)

                        .background(Color(.systemGray3))
                        .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 4) {
                        Text(User.MOCK_USER.fullname)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.top, 4)

                        Text(User.MOCK_USER.email)
                            .font(.footnote)
                            .foregroundStyle(.gray)
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
                        imageName: "arrow.left.circle.fill",
                        title: "Steps overview",
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
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
