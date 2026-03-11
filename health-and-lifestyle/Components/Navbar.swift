import SwiftUI

struct Navbar: View {

    @EnvironmentObject var viewModel: AuthViewModel
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Health", systemImage: "heart.fill", value: 0) {
                HealthView()
            }
            Tab("Profile", systemImage: "person.fill", value: 1) {
                ProfileView(selectedTab: $selectedTab)
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
