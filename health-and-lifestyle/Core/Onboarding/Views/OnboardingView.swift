import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var onboardingViewModel: OnboardingViewModel

    @State private var page = 0

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

    private let pages: [(symbol: String?, title: String, detail: String)] = [
        (nil, "Welcome to Movement", "Build habits and watch your progress grow across the solar system."),
        ("heart.text.square.fill", "Health in one place", "Connect Apple Health to see activity and heart data alongside your goals."),
        ("person.crop.circle.badge.checkmark", "Your account, synced", "Sign in to save progress and pick up where you left off on any device."),
    ]

    var body: some View {
        ZStack {
            onboardingBackground

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button("Skip") {
                        onboardingViewModel.completeOnboarding()
                    }
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white.opacity(0.65))
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)

                TabView(selection: $page) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, item in
                        onboardingPage(
                            symbol: item.symbol,
                            title: item.title,
                            detail: item.detail
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .tint(accentOrange)

                Button {
                    if page < pages.count - 1 {
                        withAnimation { page += 1 }
                    } else {
                        onboardingViewModel.completeOnboarding()
                    }
                } label: {
                    Text(page < pages.count - 1 ? "Next" : "Get started")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(accentOrange)
                        .clipShape(RoundedRectangle(cornerRadius: 26))
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 28)
                .padding(.top, 8)
            }
        }
    }

    private var onboardingBackground: some View {
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
        }
    }

    private func onboardingPage(symbol: String?, title: String, detail: String) -> some View {
        VStack(spacing: 24) {
            Spacer(minLength: 24)

            Group {
                if let symbol {
                    Image(systemName: symbol)
                        .font(.system(size: 56))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(accentOrange, .white.opacity(0.85))
                } else {
                    Image("movement-logo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 120)
                        .padding(.vertical, 32)
                }
            }

            Text(title)
                .font(.title2.weight(.bold))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 28)

            Text(detail)
                .font(.body)
                .foregroundStyle(.white.opacity(0.78))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Spacer()
            Spacer(minLength: 120)
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(OnboardingViewModel())
}
