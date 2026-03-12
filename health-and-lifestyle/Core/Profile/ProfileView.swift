import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedTab: Int

    private let accentOrange = Color(red: 232 / 255, green: 98 / 255, blue: 61 / 255)
    private let bgColor = Color(red: 0x45 / 255, green: 0x42 / 255, blue: 0x42 / 255)

    var body: some View {
        ZStack {
            bgColor.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    if let user = viewModel.currentUser {
                        profileHeader(user: user)
                    }

                    generalSection

                    accountSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 40)
            }
        }
        .onChange(of: viewModel.userSession) {
            if viewModel.userSession == nil {
                dismiss()
            }
        }
    }

    private func profileHeader(user: User) -> some View {
        VStack(spacing: 12) {
            Text(user.initials)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .frame(width: 80, height: 80)
                .background(accentOrange.opacity(0.85))
                .clipShape(Circle())

            VStack(spacing: 4) {
                Text(user.fullname)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.white)

                Text(user.email)
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white.opacity(0.06))
        )
    }

    private var generalSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("General")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white.opacity(0.4))
                .textCase(.uppercase)
                .padding(.leading, 4)

            HStack {
                SettingsRowView(
                    imageName: "gear",
                    title: "Version",
                    tintColor: .white.opacity(0.5)
                )

                Spacer()

                Text("1.0")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.4))
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(.white.opacity(0.05))
            )
        }
    }

    private var accountSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Account")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white.opacity(0.4))
                .textCase(.uppercase)
                .padding(.leading, 4)

            VStack(spacing: 0) {
                Button {
                    selectedTab = 0
                } label: {
                    HStack {
                        SettingsRowView(
                            imageName: "list.dash.header.rectangle.fill",
                            title: "Back to Health view",
                            tintColor: accentOrange
                        )
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.3))
                    }
                    .padding(14)
                }

                Divider().background(.white.opacity(0.1))

                Button {
                    viewModel.signOut()
                } label: {
                    HStack {
                        SettingsRowView(
                            imageName: "arrow.left.circle.fill",
                            title: "Sign out",
                            tintColor: Color(.systemRed)
                        )
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.3))
                    }
                    .padding(14)
                }

                Divider().background(.white.opacity(0.1))

                Button {
                    print("Delete account...")
                } label: {
                    HStack {
                        SettingsRowView(
                            imageName: "xmark.circle.fill",
                            title: "Delete account",
                            tintColor: Color(.systemRed)
                        )
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.3))
                    }
                    .padding(14)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(.white.opacity(0.05))
            )
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(selectedTab: .constant(1))
    }
}
