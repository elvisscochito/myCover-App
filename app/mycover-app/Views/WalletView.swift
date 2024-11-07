import SwiftUI

struct WalletView: View {
    @EnvironmentObject var ticketViewModel: TicketViewModel // Acceso al ViewModel
    
    var body: some View {
        VStack {
            
            List(ticketViewModel.arrTokens) { token in
                VStack(alignment: .leading) {
                    Text(token.title)
                        .font(.headline)
                    Text(token.headline)
                        .font(.subheadline)
                    Text("Acquired on: \(token.acquisitionDate, formatter: dateFormatter)")
                        .font(.caption)
                }
                .padding(.vertical, 5)
            }
            .navigationTitle("My Tickets")
        }
    }
}

// Formato de fecha
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()

#Preview {
    WalletView()
        .environmentObject(TicketViewModel()) // Agregar el environment para la vista de preview
}
