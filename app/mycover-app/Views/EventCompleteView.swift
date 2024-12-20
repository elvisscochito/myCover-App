import SwiftUI

struct EventCompleteView: View {
    let evento: EventModel
    @EnvironmentObject var ticketsVM: TicketViewModel
    @EnvironmentObject var storeKitManager: StoreKitManager
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var buyed: Bool = false
    @State private var isLoading: Bool = false
    @State private var isPurchased: Bool = false
    
    var body: some View {
        VStack {
            VStack {
                Text(evento.title)
                    .font(.title)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                
                Text(evento.headline)
                    .font(.headline)
                    .foregroundColor(.gray)
                    .fontWeight(.semibold)
            }
            .padding()
            
            if isLoading {
                ProgressView("Procesando...")
                    .padding()
            }
            
            // Botón para comprar el boleto
            Button(action: {
                Task {
                    isLoading = true
                    do {
                        // Intentar comprar el boleto
                        guard let product = storeKitManager.storeProducts.first(where: { $0.id == "com.cover.boleto.vip" }) else {
                            throw StoreError.failedVerification
                        }
                        let transaction = try await storeKitManager.purchase(product)
                        
                        if transaction != nil {
                            // Compra exitosa
                            alertMessage = "Compra exitosa. Ahora puedes guardar el boleto en Wallet."
                            isPurchased = true
                            ticketsVM.postData(description: evento.headline, label: evento.title)
                            ticketsVM.createTicket(for: evento)
                        }
                    } catch {
                        // Mostrar mensaje de error
                        alertMessage = "Error: \(error.localizedDescription)"
                    }
                    showAlert = true
                }
            }) {
                Text("Comprar Boleto")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(8)
            }
            .disabled(isLoading) // Desactiva el botón si está cargando
            
            // Botón para guardar en Wallet
            if isPurchased || isLoading || (ticketsVM.isPassURLNil == false) {
                Button(action: {
                    ticketsVM.addPassToWallet()
                }) {
                    Text("Guardar en Wallet")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(ticketsVM.isPassURLNil ? Color.gray : Color.blue)
                        .cornerRadius(8)
                }
                .disabled(ticketsVM.isPassURLNil)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Atención"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
        }
        .onChange(of: ticketsVM.isPassURLNil) { newValue in
            if !newValue {
                isLoading = false // Actualiza isLoading cuando isPassURLNil cambia a false
            }
        }
        .navigationTitle(evento.title)
        .preferredColorScheme(.dark)
    }
    
    // Función para guardar en la billetera
    func saveToWallet() {
        alertMessage = "¡Boleto guardado en Wallet exitosamente!"
        showAlert = true
    }
}
