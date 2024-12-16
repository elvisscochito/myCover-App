import SwiftUI

struct Home: View {
    
    @ObservedObject var ticketsVM  = TicketViewModel()
    // @State private var tickets: [TicketModel] = TicketModel.sampleTickets
    @State private var isShowingSheet = false
    @State private var searchTerm = ""
    
    var filterTicketsCardsView: [EventModel] {
        if searchTerm.isEmpty {
            return ticketsVM.arrEvents
        } else {
            return ticketsVM.arrEvents.filter { $0.title.localizedCaseInsensitiveContains(searchTerm) || $0.headline.localizedCaseInsensitiveContains(searchTerm)
            }
        }
    }
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(filterTicketsCardsView) { evento in
                    NavigationLink(destination: EventCompleteView(evento: evento, ticketsVM: ticketsVM)) { //destination es haciad donde va
                        EventDetailsView(evento: evento) //details es solo al preview del evento visible desde home
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
            .searchable(text: $searchTerm, prompt: "Search for ticket title, headline or code")
            .sheet(isPresented: $isShowingSheet, content: {
                // Pass bindling of tickets and isShowigSheet
                NewEventSheetView(ticketsVM: ticketsVM, isShowingSheet: $isShowingSheet)
            })
        }
    }
}

#Preview {
    Home()
}
