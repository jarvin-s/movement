import SwiftUI

struct HealthView: View {
    @StateObject private var healthViewModel = HealthViewModel()
    @EnvironmentObject var viewModel: AuthViewModel

    private let accentOrange = Color(red: 232/255, green: 98/255, blue: 61/255)
    private let bgColor = Color(red: 0x45/255, green: 0x42/255, blue: 0x42/255)
    private let stepGoal: Double = 10_000

    private var firstName: String {
        viewModel.currentUser?.fullname.components(separatedBy: " ").first ?? ""
    }

    private var stepProgress: Double {
        min(healthViewModel.stepCount / stepGoal, 1.0)
    }

    var body: some View {
        ZStack {
            bgColor.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    headerBar
                        .padding(.horizontal, 20)
                        .padding(.top, 8)

                    stepsCard
                        .padding(.top, 28)

                    challengesSection
                        .padding(.top, 32)
                        .padding(.horizontal, 20)

                    Spacer(minLength: 40)
                }
            }
        }
        .onAppear {
            healthViewModel.requestAccessAndStartObserving()
        }
        .onDisappear {
            healthViewModel.stopObserving()
        }
    }

    private var headerBar: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(greeting)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
                Text(firstName)
                    .font(.headline)
                    .foregroundStyle(accentOrange)
            }

            Spacer()

            HStack(spacing: 4) {
                Image(systemName: "flame.fill")
                    .foregroundStyle(.orange)
                Text("\(Int(healthViewModel.stepCount / 200))")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
            }
            .font(.subheadline)
        }
    }

    private var stepsCard: some View {
        VStack(spacing: 16) {
            Text("Today's steps")
                .font(.system(size: 28, weight: .bold))
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(accentOrange)
                .foregroundStyle(.white)
                .cornerRadius(6)

            Text(currentDateString)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.6))

            ZStack {
                Circle()
                    .stroke(.white.opacity(0.1), lineWidth: 10)

                Circle()
                    .trim(from: 0, to: stepProgress)
                    .stroke(accentOrange, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.6), value: stepProgress)

                VStack(spacing: 4) {
                    Text("\(Int(healthViewModel.stepCount))")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    Text("/ \(Int(stepGoal).formatted()) steps")
                        .font(.footnote)
                        .foregroundStyle(.white.opacity(0.5))
                }
            }
            .frame(width: 180, height: 180)
            .padding(.top, 8)
        }
    }

    private var challengesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Challenges")
                .font(.title3.weight(.bold))
                .foregroundStyle(.white)

            challengeRow(
                icon: "figure.walk",
                title: "Daily walker",
                description: "Walk 10,000 steps today",
                current: healthViewModel.stepCount,
                goal: 10_000
            )

            challengeRow(
                icon: "flame.fill",
                title: "Getting warmed up",
                description: "Reach 5,000 steps",
                current: healthViewModel.stepCount,
                goal: 5_000
            )

            challengeRow(
                icon: "star.fill",
                title: "First steps",
                description: "Walk at least 1,000 steps",
                current: healthViewModel.stepCount,
                goal: 1_000
            )
        }
    }

    private func challengeRow(icon: String, title: String, description: String, current: Double, goal: Double) -> some View {
        let progress = min(current / goal, 1.0)
        let completed = current >= goal

        return HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(completed ? accentOrange : .white.opacity(0.08))
                    .frame(width: 42, height: 42)

                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(completed ? .white : accentOrange)
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)

                    Spacer()

                    if completed {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                            .font(.subheadline)
                    } else {
                        Text("\(Int(current))/\(Int(goal))")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.5))
                    }
                }

                Text(description)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.5))

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(.white.opacity(0.1))
                            .frame(height: 5)

                        Capsule()
                            .fill(completed ? .green : accentOrange)
                            .frame(width: geometry.size.width * progress, height: 5)
                            .animation(.easeInOut(duration: 0.4), value: progress)
                    }
                }
                .frame(height: 5)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.white.opacity(0.05))
        )
    }

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        case 17..<21: return "Good evening"
        default: return "Good night"
        }
    }

    private var currentDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: Date())
    }
}

#Preview {
    HealthView()
        .environmentObject(AuthViewModel())
}
