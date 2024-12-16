import SwiftUI
import PassKit

struct Test: View {
    @State private var responseMessage: String = ""
    @State private var passURL: URL?

    var body: some View {
        VStack(spacing: 20) {
            Text("Realizar Petición POST")
                .font(.title)
            Button("Enviar Solicitud") {
                postData()
            }
            if passURL != nil {
                Button("Agregar a Wallet") {
                    addPassToWallet()
                }
            }
            Text(responseMessage)
                .padding()
        }
        .padding()
    }

    func postData() {
        guard let url = URL(string: "https://app-o3i3ueqa6a-uc.a.run.app/api/postTicket") else {
            print("URL inválida")
            return
        }
        
        let parameters: [String: Any] = [
            "organizationName": "neza",
            "description": "Prueba routes desde postman firebase",
            "primaryFields": [
                [
                    "key": "staffName",
                    "label": "Invitado",
                    "value": "Remote"
                ]
            ]
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
            print("Error al convertir parámetros a JSON")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    responseMessage = "Error: \(error.localizedDescription)"
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Código de estado HTTP: \(httpResponse.statusCode)")
            }
            
            if let data = data {
                let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("archivo.pkpass")
                do {
                    try data.write(to: fileURL)
                    print("Archivo guardado en: \(fileURL.path)")
                    DispatchQueue.main.async {
                        responseMessage = "Archivo listo para Wallet"
                        self.passURL = fileURL
                    }
                } catch {
                    print("Error al guardar el archivo: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        responseMessage = "Error al guardar el archivo"
                    }
                }
            }
        }.resume()
    }

    func addPassToWallet() {
        guard let url = passURL, let passData = try? Data(contentsOf: url) else {
            responseMessage = "No se pudo cargar el archivo"
            return
        }
        
        do {
            let pass = try PKPass(data: passData)
            
            // Aquí desempaquetamos el controlador opcional de forma segura
            if let addPassVC = PKAddPassesViewController(pass: pass) {
                // Presentar el controlador
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let rootViewController = windowScene.windows.first?.rootViewController {
                    rootViewController.present(addPassVC, animated: true)
                }
            } else {
                print("No se pudo crear el controlador de Wallet.")
                responseMessage = "No se pudo abrir Wallet"
            }
        } catch {
            print("Error al cargar el pase: \(error.localizedDescription)")
            responseMessage = "Error al agregar a Wallet"
        }
    }

}
