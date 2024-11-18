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
    
    func createTicket(title: String, headline: String) {
        let newTicket = TicketModel(title: title, headline: headline)
        arrTickets.append(newTicket)
    }
}
