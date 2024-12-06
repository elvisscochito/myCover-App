import SwiftUI

struct ContentView: View {
    // init ViewModel
    @StateObject private var ticketsVM = TicketViewModel()
    @State private var navigateToHome = false

    var body: some View {
        NavigationStack {
            ZStack {
                if navigateToHome {
                    // view thats got to after 2 seconds
                    OnBoardingView() // Vista a la que se navega después de 2 segundos
                        // pass the ViewModel
                        .environmentObject(ticketsVM)
                } else {
                    ZStack {
                        // set the background to black
                        Color.black
                                                    .ignoresSafeArea()
                        // make sure that the "AppIconImage" is the right name of the asset
                        Image("Icon")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 100, height: 100)
                
                    }
                    .onAppear {
                        // navigate to OnBoardingView after 2 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            navigateToHome = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
