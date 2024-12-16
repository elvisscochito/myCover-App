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
    @Published var arrEvents = [EventModel]()
    @Published var arrTickets = [TicketModel]()
    @Published var isRequestSuccessful: Bool? = nil
    @Published var isLoggedIn: Bool = false // Estado de login
    
    
    private let loginKey = "userLoggedIn"
    private let lastLoginDateKey = "lastLoginDate"
    private let loginValidityPeriod: TimeInterval = 30 * 24 * 60 * 60 // Un mes en segundos

    
    
    
    init(){
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
    
    func createTicket(for evento: EventModel) {
        let newTickets = TicketModel(
            eventID: evento.id,
            title: evento.title,
            headline: evento.headline
        )
        arrTickets.append(newTickets)
    }
    
    
    func createEvent(title: String, description: String) {
        let newEvent = EventModel(title: title, headline: description)
        arrEvents.append(newEvent)
    }
    
    func postTicketreturnable(description: String, value: String) {
        guard let url = URL(string: "https://app-o3i3ueqa6a-uc.a.run.app/api/postTicket") else {
            print("Error: invalid URL")
            self.isRequestSuccessful = false
            return
        }
        
        let parameters: [String: Any] = [
            "description": description,
            "primaryFields": [
                [
                    "key": "staffName",
                    "label": "Usuario",
                    "value": value
                ]
            ]
        ]
        
        print("Parameters: \(parameters)")
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("Error: invalid JSON data")
            self.isRequestSuccessful = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.isRequestSuccessful = false
                }
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Response status code: \(response.statusCode)")
            }
            
            if let data = data {
                let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("ticket.pkpass")
                do {
                    try data.write(to: fileURL)
                    print("Archivo .pkpass guardado en: \(fileURL)")
                } catch {
                    print("Error al guardar el archivo: \(error.localizedDescription)")
                }
                
                self?.savePKPass(data)
            }
        }.resume()
    }

    
    
    
    private func savePKPass(_ data: Data) {
        do {
            // Crea un objeto PKPass
            let pass = try PKPass(data: data)
            
            // Presenta el PKAddPassesViewController para agregar el pase a Wallet
            DispatchQueue.main.async {
                if let addPassesViewController = PKAddPassesViewController(pass: pass) {
                    // Asegúrate de que hay una ventana activa para presentar el controlador
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let rootViewController = windowScene.windows.first?.rootViewController {
                        rootViewController.present(addPassesViewController, animated: true)
                    } else {
                        print("No se pudo obtener la ventana activa para presentar el controlador.")
                    }
                } else {
                    print("No se pudo crear el controlador para agregar el pase.")
                }
            }
        } catch {
            // Maneja errores genéricos
            print("Error al procesar el archivo .pkpass: \(error.localizedDescription)")
        }
    }



    
    
    
    
    func postTicket(description: String, staffName: String) {
        guard !description.isEmpty, !staffName.isEmpty else {
            print("Error: Description y Staff Name no deben estar vacíos.")
            isRequestSuccessful = false
            return
        }
        
        guard let url = URL(string: "https://app-o3i3ueqa6a-uc.a.run.app/api/postTicket") else {
            print("Error: invalid URL")
            isRequestSuccessful = false
            return
        }
        
        let parameters: [String: Any] = [
            "description": description,
            "primaryFields": [
                [
                    "key": "staffName",
                    "label": "Usuario",
                    "value": staffName
                ]
            ]
        ]
        
        print("Parameters sent to server: \(parameters)")
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("Error: invalid JSON data")
            isRequestSuccessful = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.isRequestSuccessful = false
                }
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Response status code: \(response.statusCode)")
                DispatchQueue.main.async {
                    self?.isRequestSuccessful = (200...299).contains(response.statusCode)
                }
            }
            
            if let data = data {
                // Imprime la respuesta del servidor para depuración
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response: \(responseString)")
                }
            }
        }.resume()
    }

}
