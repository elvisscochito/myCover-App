import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var storeKitManager: StoreKitManager
    @State private var logs: [String] = [] // Lista reactiva de logs

    var body: some View {
        VStack {
            Text("Logs de Compra")
                .font(.headline)
                .padding(.top)

            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(logs, id: \.self) { log in
                        Text(log)
                            .font(.body)
                            .padding(8)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
                .padding()
            }

            Spacer()

            Button(action: {
                logs.removeAll() // Limpia los logs
            }) {
                Text("Limpiar Logs")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
        }
        .onAppear {
            logs.append("[ProfileView] ProfileView cargado.") // Log inicial

            // Configurar el logHandler
            storeKitManager.logHandler = { logMessage in
                DispatchQueue.main.async {
                    logs.append(logMessage) // Agregar el mensaje a los logs visibles
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
