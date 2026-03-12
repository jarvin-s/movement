import SwiftUI

struct Navbar: View {

    @EnvironmentObject var viewModel: AuthViewModel
    @State private var selectedTab: Int = 0

    private let accentOrange = Color(red: 232/255, green: 98/255, blue: 61/255)

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Health", systemImage: "heart.fill", value: 0) {
                HealthView()
            }
            Tab("Profile", systemImage: "person.fill", value: 1) {
                ProfileView(selectedTab: $selectedTab)
            }
        }
        .tint(accentOrange)
    }
}

struct Navbar_Previews: PreviewProvider {
    static var previews: some View {
        Navbar()
            .environmentObject(AuthViewModel())
    }
}
