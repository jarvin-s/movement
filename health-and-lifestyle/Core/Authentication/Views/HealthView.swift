import SwiftUI

struct HealthView: View {
    @State private var stepCount: Double = 0
    let healthStore = HealthStore()
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
//        if viewModel.userSession != nil {
//            Button(action: viewModel.signOut) {
//                Label("Sign out", systemImage: "arrow.left")
//            }
//        }
        
        VStack {
            Text("Today's step count:")
                .font(.title)
            Text("\(Int(stepCount))")
                .bold()
                .font(.largeTitle)
            
            Button("Fetch steps"){
                healthStore.fetchStepCount {
                    steps in
                    stepCount = steps
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(.black)
        }
        
        .padding()
        .onAppear() {
            requestHealthKitAccess()
        }
    }
    
    func requestHealthKitAccess(){
        healthStore.requestAuthorization {
            success, error in
            if let error = error {
                print("HealthKit authorization failed: \(error.localizedDescription)")
            } else {
                print ("HealthKit successfully authorized.")
            }
        }
    }

}

#Preview {
    HealthView()
        .environmentObject(AuthViewModel())
}
