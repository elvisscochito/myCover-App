//
//  TicketModel.swift
//  mycover-app
//
//  Created by Joel Vargas on 24/10/24.
//


//
//  TicketModel.swift
//  myTickets
//
//  Created by Elviro Dominguez Soriano on 25/02/24.
//

//@State private var title = ""
//@State private var headline = ""
//@State private var date = Date.now
//@State private var backgroundColor = Color.black
//@State private var textColor = Color.white

import Foundation

func CreateTicket(lista: [TicketModel] ,title: String, headline: String/*,date,backgroundColor,textColor*/) ->  [TicketModel] {
    var updatedList = lista
    
    let newTicket = TicketModel(title: title, headline: headline)
    
    updatedList.append(newTicket)
    
    return updatedList
}

struct TicketModel: Identifiable {
    let id = UUID()
    var title: String
    var headline: String
    
    static var defaultTicket = TicketModel(title: "Title", headline: "Headline")
    
    static var sampleTickets: [TicketModel] = [
        TicketModel(title: "Apple Event", headline: "Swift student challenge 2024"),
        TicketModel(title: "Tec de Monterrey", headline: "Business Weeekend"),
        TicketModel(title: "Enterprise Event", headline: "Business meeting at the restaurant"),
        TicketModel(title: "Social Event", headline: "Party in the club")
    ]
}
