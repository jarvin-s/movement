import SwiftUI

struct Navbar: View {

    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        TabView {
            Tab("Health", systemImage: "heart.fill") {
                HealthView()
            }
            Tab("Profile", systemImage: "person.fill") {
                ProfileView()
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
