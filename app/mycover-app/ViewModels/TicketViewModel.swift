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
    @Published var arrTickets = [TicketModel]()
    @Published var arrTokens = [TokenModel]()
    @Published var isRequestSuccessful: Bool? = nil
    
    init(){
        getTickets()
    }
    
    func getTickets() {
        var ticket: TicketModel
        ticket = TicketModel(title: "Apple Event", headline: "Swift student challenge 2024")
        arrTickets.append(ticket)
        ticket = TicketModel(title: "TecWeek", headline: "Business Weekend")
        arrTickets.append(ticket)
        ticket = TicketModel(title: "Enterprise Event", headline: "Business meeting at the restaurant")
        arrTickets.append(ticket)
        ticket = TicketModel(title: "Social Event", headline: "Party in the club")
        arrTickets.append(ticket)
    }
    
    func createToken(for ticket: TicketModel) -> TokenModel {
        let newToken = TokenModel(
            ticketID: ticket.id,
            title: ticket.title,
            headline: ticket.headline
        )
        arrTokens.append(newToken)
        return newToken
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
                    "label" : "Invitado",
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
                        let newTicket = TicketModel(title: description, headline: staffName)
                        self?.arrTickets.append(newTicket)
                           
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
