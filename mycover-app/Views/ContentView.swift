import SwiftUI

struct ContentView: View {
    @StateObject private var ticketsVM = TicketViewModel() // Inicializa aquí el ViewModel
    @State private var navigateToHome = false

    var body: some View {
        NavigationStack {
            ZStack {
                if navigateToHome {
                    OnBoardingView() // Vista a la que se navega después de 2 segundos
                        .environmentObject(ticketsVM) // Pasa el ViewModel
                } else {
                    ZStack {
                       Text("Icono Logo")
                    }
                    .onAppear {
                        // Navegar a OnBoardingView después de 2 segundos
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            navigateToHome = true
                        }
                    }
                }
            }
        }
    }
}
