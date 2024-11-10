import SwiftUI

struct ContentView: View {
    // neds to improved for the first call
    // @StateObject private var ticketsVM = TicketViewModel() // Inicializa aquí el ViewModel
    @State private var navigateToHome = false

    var body: some View {
        NavigationStack {
            ZStack {
                if navigateToHome {
                    OnBoardingView() // Vista a la que se navega después de 2 segundos
                        //.environmentObject(ticketsVM) // Pasa el ViewModel
                } else {
                    ZStack {
                        
                        Color.black // Establece el fondo negro
                                                    .ignoresSafeArea()
                        Image("Icon") // Asegúrate de que "AppIconImage" sea el nombre correcto en los assets
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 100, height: 100)
                
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
