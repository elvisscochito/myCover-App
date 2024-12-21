//
//  TicketViewModel.swift
//  mycover-app
//
//  Created by Alumno on 06/11/24.
//

import Foundation
import SwiftUI
import MapKit
import PassKit


class TicketViewModel: ObservableObject {
    
    @Published var username: String {
            didSet {
                UserDefaults.standard.set(username, forKey: "userFullName")
            }
        }
    
    
    @Published var arrEvents = [EventModel]()
    @Published var arrTickets = [TicketModel]()
    @Published var isRequestSuccessful: Bool? = nil
    @Published var isLoggedIn: Bool = false // Estado de login
    @State private var responseMessage: String = ""
    @Published var passURL: URL?
    
    var isPassURLNil: Bool {
            passURL == nil
        }
    
    

    
    
    
    private let loginKey = "userLoggedIn"
    private let lastLoginDateKey = "lastLoginDate"
    private let loginValidityPeriod: TimeInterval = 30 * 24 * 60 * 60 // Un mes en segundos

    
    
    
    init(){
        
        
        
        
        self.username = UserDefaults.standard.string(forKey: "userFullName") ?? "Invitado"
        checkLoginStatus()
            if isLoggedIn {
                getEvents()
            }
    }
    
    
    // Verificar estado de login
    func checkLoginStatus() {
        let defaults = UserDefaults.standard
        let lastLoginDate = defaults.object(forKey: lastLoginDateKey) as? Date

        if let lastLoginDate = lastLoginDate {
            let timeSinceLastLogin = Date().timeIntervalSince(lastLoginDate)
            if timeSinceLastLogin < loginValidityPeriod {
                isLoggedIn = true
            } else {
                isLoggedIn = false // El periodo ha expirado
            }
        } else {
            isLoggedIn = false // No hay registro previo
        }
    }
    
    
    // Registrar login
    func registerLogin() {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: loginKey)
        defaults.set(Date(), forKey: lastLoginDateKey)
        isLoggedIn = true
    }

    // Función de logout (opcional)
    func logout() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: loginKey)
        defaults.removeObject(forKey: lastLoginDateKey)
        isLoggedIn = false
    }
    
    func getEvents() {
        let eventsData = [
            ("Apple Event", "Swift student challenge 2024"),
            ("TecWeek", "Business Weekend"),
            ("Enterprise Event", "Business meeting at the restaurant"),
            ("Social Event", "Party in the club")
        ]
        
        arrEvents = eventsData.map { EventModel(title: $0.0, headline: $0.1) }
    }
    
    
    func getArrTickets() -> [TicketModel] {
        return self.arrTickets
        }
    
    func createTicket(for evento: EventModel) {
        let newTickets = TicketModel(
            eventID: evento.id,
            title: evento.title,
            headline: evento.headline,
            name: username
        )
        arrTickets.append(newTickets)
    }
    
    
    func createEvent(title: String, description: String) {
        let newEvent = EventModel(title: title, headline: description)
        arrEvents.append(newEvent)
    }
    
   

    
    func postData(description: String, label: String, us: String) {
        guard let url = URL(string: "https://app-o3i3ueqa6a-uc.a.run.app/api/postTicket") else {
            print("URL inválida")
            return
        }
        
        let parameters: [String: Any] = [
            "organizationName": "neza",
            "description": description ,
            "primaryFields": [
                [
                    "key": "staffName",
                    "label": label ,
                    "value": us
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
                    self.responseMessage = "Error: \(error.localizedDescription)"
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
                        self.responseMessage = "Archivo listo para Wallet"
                        self.passURL = fileURL
                    }
                } catch {
                    print("Error al guardar el archivo: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.responseMessage = "Error al guardar el archivo"
                    }
                }
            }
        }.resume()
    }

    func addPassToWallet() {
        guard let url = passURL, let passData = try? Data(contentsOf: url) else {
            self.responseMessage = "No se pudo cargar el archivo"
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
                self.responseMessage = "No se pudo abrir Wallet"
            }
        } catch {
            print("Error al cargar el pase: \(error.localizedDescription)")
            self.responseMessage = "Error al agregar a Wallet"
        }
    }

}
