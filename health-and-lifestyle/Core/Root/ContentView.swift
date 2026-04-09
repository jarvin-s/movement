
import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @EnvironmentObject private var onboardingViewModel: OnboardingViewModel

    var body: some View {
        Group {
            if !onboardingViewModel.hasCompletedOnboarding {
                OnboardingView()
            } else {
                NavigationStack {
                    Group {
                        if authViewModel.userSession != nil {
                            Navbar()
                        } else {
                            LoginView()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
        .environmentObject(OnboardingViewModel())
}
