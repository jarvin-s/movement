import SwiftUI
import FirebaseAuth

struct Navbar: View {

    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject private var healthViewModel = HealthViewModel()
    @StateObject private var solarProgressViewModel = SolarProgressViewModel()
    @State private var selectedTab: Int = 0

    private let accentOrange = Color(red: 232/255, green: 98/255, blue: 61/255)

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Health", systemImage: "heart.fill", value: 0) {
                HealthView()
            }
            Tab("Profile", systemImage: "person.fill", value: 1) {
                ProfileView()
            }
        }
        .tint(accentOrange)
        .environmentObject(healthViewModel)
        .environmentObject(solarProgressViewModel)
        .onAppear {
            healthViewModel.requestAccessAndStartObserving()
            if let uid = viewModel.userSession?.uid {
                solarProgressViewModel.configure(userId: uid, healthViewModel: healthViewModel)
            }
        }
        .onChange(of: viewModel.userSession?.uid) { _, uid in
            if let uid {
                solarProgressViewModel.configure(userId: uid, healthViewModel: healthViewModel)
            } else {
                solarProgressViewModel.reset()
            }
        }
    }
}

struct Navbar_Previews: PreviewProvider {
    static var previews: some View {
        Navbar()
            .environmentObject(AuthViewModel())
    }
}
