//
//  WalletView.swift
//  mycover-app
//
//  Created by Joel Vargas on 15/12/24.
//

import SwiftUI

struct WalletView: View {
    @EnvironmentObject var ticketsVM: TicketViewModel
    
    var body: some View {
        VStack {
            Text("WalletView")
                .font(.title)
                .padding()
            Button("Obtener Tickets") {
                print(ticketsVM.getArrTickets())
            }
            
            if ticketsVM.getArrTickets().isEmpty {
                
                Text("No hay tickets disponibles.")
                    .foregroundColor(.gray)
            } else {
                List(ticketsVM.getArrTickets()) { ticket in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Nombre: \(ticket.name)")
                            .font(.headline)
                        Text("Título: \(ticket.title)")
                            .font(.subheadline)
                        Text("Descripción: \(ticket.headline)")
                            .font(.caption)
                        
                    }
                }
                .padding()
                .onAppear {
                    print(ticketsVM.getArrTickets())
                }
            }
        }}}

#Preview {
    WalletView()
        .environmentObject(TicketViewModel())
}






