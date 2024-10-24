import SwiftUI

struct Home: View {
    
    @State private var isShowingSheet = false
    @State private var searchTerm = ""
    
    private let tickets: [TicketModel] = TicketModel.sampleTickets
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(tickets) { ticket in
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
                NewTicketSheetView()
            })
        }
    }
}

#Preview {
    Home()
}
