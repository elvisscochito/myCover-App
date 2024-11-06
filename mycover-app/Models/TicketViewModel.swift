//
//  TicketViewModel.swift
//  mycover-app
//
//  Created by Alumno on 06/11/24.
//

import Foundation
import SwiftUI

class TicketViewModel: ObservableObject {
    @Published var arrTickets = [TicketModel]()
    
    init(){
        getTickets()
    }
    
    func getTickets() {
        var ticket : TicketModel
        
        ticket = TicketModel(title: "Apple Event", headline: "Swift student challenge 2024")
        arrTickets.append(ticket)
        ticket = TicketModel(title: "Tec de Monterrey", headline: "Business Weeekend")
        arrTickets.append(ticket)
        ticket = TicketModel(title: "Enterprise Event", headline: "Business meeting at the restaurant")
        arrTickets.append(ticket)
        ticket = TicketModel(title: "Social Event", headline: "Party in the club")
        arrTickets.append(ticket)
    }
    
    func createTicket(title: String, headline: String) {
        let newTicket = TicketModel(title: title, headline: headline)
        // append created ticket to previous list
        arrTickets.append(newTicket)
    }
}
