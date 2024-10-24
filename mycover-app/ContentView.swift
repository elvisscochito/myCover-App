import SwiftUI

struct ContentView: View {
    @State private var navigateToHome = false

    var body: some View {
        ZStack {
            // Navegación
            if navigateToHome {
                OnBoardingView() // Vista a la que se navega después de 3 segundos
            } else {
                ZStack {
                    Text("Icono Logo")
                }
                .onAppear {
                    // Navegar a Home después de 3 segundos
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        navigateToHome = true
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
