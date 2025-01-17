//
//  TicketCardView.swift
//  mycover-app
//
//  Created by Joel Vargas on 24/10/24.
//


//
//  TicketCardView.swift
//  myTickets
//
//  Created by Elviro Dominguez Soriano on 25/02/24.
//

import SwiftUI

struct TicketDetailsView: View {
    var ticket: TicketModel
    var body: some View {
        VStack {
            Text(ticket.title)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .foregroundColor(.white)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            Text(ticket.headline)
                .font(.headline)
                .foregroundColor(.gray)
                .fontWeight(.semibold)
        }
        .padding()
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}


