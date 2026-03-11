import SwiftUI

struct HealthView: View {
    @StateObject private var healthViewModel = HealthViewModel()
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Text("Today's step count:")
                .font(.title)
            Text("\(Int(healthViewModel.stepCount))")
                .bold()
                .font(.largeTitle)
        }
        .padding()
        .onAppear {
            healthViewModel.requestAccessAndStartObserving()
        }
        .onDisappear {
            healthViewModel.stopObserving()
        }
    }
}

#Preview {
    HealthView()
        .environmentObject(AuthViewModel())
}
