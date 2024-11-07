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
    
    init(){
        getTickets()
    }
    
    func getTickets() {
        var ticket: TicketModel
        
        ticket = TicketModel(title: "Apple Event", headline: "Swift student challenge 2024", direction: "EXPEDITION", coordinates: CLLocationCoordinate2D(latitude: 25.652145, longitude: -100.292265))
        arrTickets.append(ticket)
        ticket = TicketModel(title: "TecWeek", headline: "Business Weekend", direction: "ITESM", coordinates: CLLocationCoordinate2D(latitude: 25.652145, longitude: -100.292265))
        arrTickets.append(ticket)
        ticket = TicketModel(title: "Enterprise Event", headline: "Business meeting at the restaurant", direction: "San Pedro", coordinates: CLLocationCoordinate2D(latitude: 25.662273, longitude: -100.394187))
        arrTickets.append(ticket)
        ticket = TicketModel(title: "Social Event", headline: "Party in the club", direction: "Garcia", coordinates: CLLocationCoordinate2D(latitude: 25.734434, longitude: -100.280716))
        arrTickets.append(ticket)
    }
    
    func createToken(for ticket: TicketModel) -> TokenModel {
        let newToken = TokenModel(
            ticketID: ticket.id,
            title: ticket.title,
            headline: ticket.headline,
            direction: ticket.direction,
            coordinates: CLLocationCoordinate2D(latitude: ticket.coordinates.latitude, longitude: ticket.coordinates.longitude),
            acquisitionDate: Date()
        )
        arrTokens.append(newToken)
        return newToken
    }
    
    func createTicket(title: String, headline: String, direction: String, coordinates: CLLocationCoordinate2D) {
        let newTicket = TicketModel(title: title, headline: headline, direction: direction, coordinates: coordinates)
        arrTickets.append(newTicket)
    }
}
