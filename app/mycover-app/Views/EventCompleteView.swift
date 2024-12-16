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
    @ObservedObject var ticketsVM: TicketViewModel
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    
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
                ticketsVM.postTicketreturnable(description: "routes", value: "staffName")
                
                
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
            .alert(isPresented: $showAlert) {
                        Alert(title: Text("Información"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
        }
        .navigationTitle(evento.title)
        .preferredColorScheme(.dark)
        
    }
}


