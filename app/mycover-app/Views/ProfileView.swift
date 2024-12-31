import SwiftUI
import StripePaymentSheet

struct ProfileView: View {
    @EnvironmentObject var ticketsVM: TicketViewModel
    @State private var paymentSheet: PaymentSheet?
    @State private var isPaymentPresented = false

    var body: some View {
        VStack {
            Spacer()

            // Botón de pago
            Button(action: {
                print("Botón presionado")
                didTapPayButton()
            }) {
                Text("Pagar ahora")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
            }

            Spacer()
        }
        .navigationTitle("Profile") // Título de navegación
        .onAppear {
            print("Vista cargada, configurando Stripe")
            configureStripe() // Configura Stripe al cargar la vista
        }
        .sheet(isPresented: $isPaymentPresented) {
            if let paymentSheet = paymentSheet {
                PaymentSheetWrapper(paymentSheet: paymentSheet)
            } else {
                Text("Error al configurar el PaymentSheet")
            }
        }
    }

    private func didTapPayButton() {
        print("Iniciando flujo de pago")
        createPaymentIntent { clientSecret in
            print("PaymentIntent recibido: \(clientSecret)")
            configurePaymentSheet(clientSecret: clientSecret)
            DispatchQueue.main.async {
                if paymentSheet != nil {
                    print("PaymentSheet configurado correctamente. Presentando ahora.")
                    isPaymentPresented = true
                } else {
                    print("Error: PaymentSheet no se configuró correctamente")
                }
            }
        }
    }

    private func createPaymentIntent(completion: @escaping (String) -> Void) {
        print("Creando PaymentIntent")
        let url = URL(string: "http://localhost:3000/create-intent")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = ["amount": 1099] // Monto en centavos (10.99 USD)
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error al crear PaymentIntent: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No se recibió respuesta del servidor")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let clientSecret = json["clientSecret"] as? String {
                    print("clientSecret recibido del servidor: \(clientSecret)")
                    completion(clientSecret)
                } else {
                    print("Error: No se encontró el clientSecret en la respuesta")
                }
            } catch {
                print("Error procesando JSON: \(error.localizedDescription)")
            }
        }.resume()
    }

    private func configurePaymentSheet(clientSecret: String) {
        print("Configurando PaymentSheet")
        var configuration = PaymentSheet.Configuration()
        configuration.merchantDisplayName = "Mi Negocio"
        configuration.returnURL = "mi-app://stripe-redirect" // Configura esto en tu Info.plist

        paymentSheet = PaymentSheet(
            paymentIntentClientSecret: clientSecret,
            configuration: configuration
        )
        if paymentSheet != nil {
            print("PaymentSheet configurado correctamente")
        } else {
            print("Error: PaymentSheet no se pudo configurar")
        }
    }

    private func configureStripe() {
        print("Configurando Stripe con la clave publicable")
        STPAPIClient.shared.publishableKey = "pk_test_51QaX3sIRGpN5HrMKKEFn9DQAxrhStncQHbz7kCRwzJZTe1DAXguhM5fPm7SJtXDt0QJQr4BxSlpOZdrj29fXKYQD00QlbjHW7l" // Tu publishable key
    }
}

struct PaymentSheetWrapper: UIViewControllerRepresentable {
    let paymentSheet: PaymentSheet

    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        DispatchQueue.main.async {
            paymentSheet.present(from: controller) { paymentResult in
                switch paymentResult {
                case .completed:
                    print("¡Pago completado!")
                case .failed(let error):
                    print("Error al procesar el pago: \(error.localizedDescription)")
                case .canceled:
                    print("El usuario canceló el pago.")
                }
            }
        }
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
