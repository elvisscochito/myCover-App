import SwiftUI

struct EventCompleteView: View {
    var evento: EventModel
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
                        guard let product = storeKitManager.storeProducts.first(where: { $0.id == "com.cover.boleto.basico" }) else {
                            throw StoreError.failedVerification
                        }
                        let transaction = try await storeKitManager.purchase(product)
                        
                        if transaction != nil {
                            // Compra exitosa
                            alertMessage = "Compra exitosa. Ahora puedes guardar el boleto en Wallet."
                            isPurchased = true

                            // Inicializar userFullName como opcional
                            var userFullName: String?

                            if let name = UserDefaults.standard.object(forKey: "userFullName") as? String {
                                userFullName = name
                                print("User Full Name: \(userFullName ?? "Unknown")")
                            } else {
                                print("No user full name found or it is not a String.")
                            }

                            // Usar un String específico de `evento` para el parámetro `label`
                            let eventLabel = evento.headline // Cambia esto por la propiedad correcta de evento que sea un String

                            ticketsVM.postData(description: evento.headline, label: eventLabel, us: userFullName ?? "Unknown User")
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
        .onChange(of: ticketsVM.isPassURLNil) { _, newValue in
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
