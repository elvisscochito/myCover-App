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

struct EventCompleteView: View {
    let evento: EventModel
    @EnvironmentObject var ticketsVM: TicketViewModel // Acceso a TicketViewModel
    
    var body: some View {
        VStack {
            VStack {
                Text(evento.title)
                    .font(.title)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                
                Text(evento.headline)
                    .font(.headline)
                    .foregroundColor(.gray)
                    .fontWeight(.semibold)
            }
            .padding()
            
            // Botón para crear el token
            Button(action: {
                
                
                
                 // Crea el token y lo agrega a arrTokens
                print("buy ticket")
            }) {
                Text("Buy Ticket")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 10)
        }
        .navigationTitle(evento.title)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    EventCompleteView(evento: EventModel(title: "Evento", headline: "Descripcion"))
}
