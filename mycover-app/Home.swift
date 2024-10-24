//
//  Home.swift
//  mycover-app
//
//  Created by Alumno on 22/10/24.
//

import SwiftUI

struct Home: View {
    
    @State private var isShowingSheet = false
    @State private var searchTerm = ""
    
    private let tickets: [TicketModel] = TicketModel.sampleTickets
    //    var filteredTickets: [TicketModel] {
    //        guard !searchTerm.isEmpty else {return self.filteredTickets}
    //        return filteredTickets.filter{_ in localizedCaseInsensitiveContains(searchTerm)}
    //    }
    
    var body: some View {
        NavigationView {
            // Sección de saldo y botón interactivo con Maya
            VStack {
                
                NavigationStack{
                    
                    ScrollView {
                        ForEach(tickets) { ticket in
                            NavigationLink(destination: TicketCardView(ticket: ticket)) {
                                TicketDetailsView(ticket: ticket)
                            }
                        }
                    }
                    
                    //                VStack {
                    //                    NavigationLink(destination: TicketView()) {
                    //                        Text("Navigate")
                    //                    }
                    //                }
                    
                    .navigationBarItems(trailing: Button(action: {
                        isShowingSheet.toggle()
                    }, label: {
                        Image(systemName: "plus")
                    })
                        .fontWeight(.bold)
                        .foregroundStyle(.white))
                    .navigationTitle("Parties")
                }
                
                // This should be avalible only in admin mode
                .sheet(isPresented: $isShowingSheet, content: {
                    (NewTicketSheetView())
                })
                
            }
            .searchable(text: $searchTerm, prompt: "Search for ticket name or code")
        }
    }
}

#Preview {
    Home()
}
