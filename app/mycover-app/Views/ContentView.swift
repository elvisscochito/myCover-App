import SwiftUI

struct ContentView: View {
    @StateObject private var ticketsVM = TicketViewModel()
    @State private var navigateToHome = false
    @AppStorage("username") var username: String = "Invitado"
    
    var body: some View {
        NavigationStack {
            ZStack {
                if navigateToHome {
                    if ticketsVM.isLoggedIn {
                        TabBarView()
                            .environmentObject(ticketsVM) // Proveer el ViewModel
                    } else {
                        OnBoardingView()
                            .environmentObject(ticketsVM) // Proveer el ViewModel
                    }
                } else {
                    ZStack {
                        Color.black
                            .ignoresSafeArea()
                        Image("Icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 160, height: 160)
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            navigateToHome = true
                        }
                    }
                }
            }
        }
        .environmentObject(ticketsVM) // Proveer el ViewModel globalmente
    }
}

#Preview {
    ContentView()
}
