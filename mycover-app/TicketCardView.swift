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
    
    var body: some View {
        VStack {
            VStack () {
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
            
            Image("Add_to_Apple_Wallet_badge")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 275)

        }
        .navigationTitle(ticket.title)
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    TicketCardView(ticket: TicketModel.defaultTicket)
}
