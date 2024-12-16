//
//  TicketViewModel.swift
//  mycover-app
//
//  Created by Alumno on 06/11/24.
//

import Foundation
import SwiftUI
import MapKit

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
    

    
    
    
    
    func postTicket(description: String, staffName: String) {
        guard let url = URL(string: "http://127.0.0.1:5001/mycover-6f7ff/us-central1/app/api/postTicket") else {
            print("Error: invalid URL")
            self.isRequestSuccessful = false
            return
        }
        
        let parameters: [String: Any] = [
            "description" : description,
            "primaryFields" : [
                [
                    "key" : "staffName",
                    "label" : "Usuario",
                    "value" : staffName
                ]
            ]
        ]
        
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
                DispatchQueue.main.async {
                    self?.isRequestSuccessful = (200...299).contains(response.statusCode)
                    
                    if self?.isRequestSuccessful == true {
                        let newTicket = EventModel(title: description, headline: staffName)
                        self?.arrEvents.append(newTicket)
                           
                        let alert = UIAlertController(title: "Ticket creado", message: "El ticket se ha creado correctamente", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                           
                        // present UIAlertController using active screen
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let rootViewController = windowScene.windows.first?.rootViewController {
                            rootViewController.present(alert, animated: true, completion: nil)
                        } else {
                            print("No se pudo obtener la ventana activa para presentar la alerta.")
                        }
                    }
                }
            }
            
            if let data = data {
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response: \(responseString)")
                }
            }
        }.resume()
    }
}
