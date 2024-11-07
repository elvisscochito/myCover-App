//
//  TicketDetailsView.swift
//  mycover-app
//
//  Created by Joel Vargas on 24/10/24.
//


//
//  TicketDetailsView.swift
//  myTickets
//
//  Created by Elviro Dominguez Soriano on 25/02/24.
//

import SwiftUI

struct TicketCardView: View {
    let ticket: TicketModel
    @EnvironmentObject var ticketsVM: TicketViewModel // Acceso a TicketViewModel
    
    var body: some View {
        VStack {
            VStack {
                Text(ticket.title)
                    .font(.title)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                
                Text(ticket.headline)
                    .font(.headline)
                    .foregroundColor(.gray)
                    .fontWeight(.semibold)
            }
            .padding()
            
            // Botón para crear el token
            Button(action: {
                ticketsVM.createToken(for: ticket) // Crea el token y lo agrega a arrTokens
            }) {
                Text("Create Ticket")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 10)
        }
        .navigationTitle(ticket.title)
        .preferredColorScheme(.dark)
    }
}
