import SwiftUI

struct Navbar: View {

    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        HStack {
            Button(action: {
                viewModel.signOut()
            }) {
                Image(systemName: "arrow.left.circle.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(Color.black)
            }

            NavigationLink {
                ProfileView()
                    .navigationBarBackButtonHidden(true)
            } label: {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(Color.black)
            }
        }
        .padding()
        .frame(alignment: .bottom)
    }
}

struct Navbar_Previews: PreviewProvider {
    static var previews: some View {
        Navbar()
    }
}
