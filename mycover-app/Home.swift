import SwiftUI

struct Home: View {
    
    @State private var tickets: [TicketModel] = TicketModel.sampleTickets
    @State private var isShowingSheet = false
    @State private var searchTerm = ""
    
    var filterTicketsCardsView: [TicketModel] {
        if searchTerm.isEmpty {
            return tickets
        } else {
            return tickets.filter { $0.title.localizedCaseInsensitiveContains(searchTerm) || $0.headline.localizedCaseInsensitiveContains(searchTerm)
            }
        }
    }
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(filterTicketsCardsView) { ticket in
                    NavigationLink(destination: TicketCardView(ticket: ticket)) {
                        TicketDetailsView(ticket: ticket)
                    }
                }
            }
            .navigationBarItems(trailing: Button(action: {
                isShowingSheet.toggle()
            }, label: {
                Image(systemName: "plus")
            })
                .fontWeight(.bold)
                .foregroundStyle(.white))
            .navigationTitle("Home")
            .searchable(text: $searchTerm, prompt: "Search for ticket name or code")
            .sheet(isPresented: $isShowingSheet, content: {
                // Pass bindling of tickets and isShowigSheet
                NewTicketSheetView(tickets: $tickets, isShowingSheet: $isShowingSheet)
            })
        }
    }
}

#Preview {
    Home()
}
