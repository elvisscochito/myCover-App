import SwiftUI

struct PostTicketView: View {
    @StateObject private var ticketsVM = TicketViewModel()
    
    @State private var description: String = ""
    @State private var staffName: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {
        VStack(spacing: 20) {
            TextField("Descripción del ticket", text: $description)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Nombre del staff", text: $staffName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
//                if description.isEmpty || staffName.isEmpty {
//                    // Mostrar alerta si los campos están vacíos
//                    alertMessage = "Por favor, llena todos los campos."
//                    showAlert = true
//                } else {
                    // Llamar al método para crear el ticket y guardar el pase en Wallet
                    ticketsVM.postTicketreturnable(description: "d", value: "sssss")
//                }
            }) {
                Text("Crear Ticket y Guardar en Wallet")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Información"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

