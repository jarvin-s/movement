
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.userSession != nil {
                    Navbar()
                } else {
                    LoginView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
