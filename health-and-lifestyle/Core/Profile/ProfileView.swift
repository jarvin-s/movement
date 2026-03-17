import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedTab: Int

    private let accentOrange = Color(red: 232 / 255, green: 98 / 255, blue: 61 / 255)
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
