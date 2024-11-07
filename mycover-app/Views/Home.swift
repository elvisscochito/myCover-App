import SwiftUI

struct Home: View {
    
    @ObservedObject var ticketsVM  = TicketViewModel()
    // @State private var tickets: [TicketModel] = TicketModel.sampleTickets
    @State private var isShowingSheet = false
    @State private var searchTerm = ""
    
    var filterTicketsCardsView: [TicketModel] {
        if searchTerm.isEmpty {
            return ticketsVM.arrTickets
        } else {
            return ticketsVM.arrTickets.filter { $0.title.localizedCaseInsensitiveContains(searchTerm) || $0.headline.localizedCaseInsensitiveContains(searchTerm)
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
            .searchable(text: $searchTerm, prompt: "Search for ticket name, headline or code")
            .sheet(isPresented: $isShowingSheet, content: {
                // Pass bindling of tickets and isShowigSheet
                NewTicketSheetView(ticketsVM: ticketsVM, isShowingSheet: $isShowingSheet)
            })
        }
    }
}

#Preview {
    Home()
}
