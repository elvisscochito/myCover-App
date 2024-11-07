import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var ticketsVM: TicketViewModel
    
    @State private var camera: MapCameraPosition = .automatic
    
    var body: some View {
        Map(position: $camera) {
            // Agrega un marcador para cada ticket en arrTickets
            ForEach(ticketsVM.arrTickets) { ticket in
                let ticketLocation = ticket.coordinates
                Marker(ticket.title, coordinate: ticketLocation)
                    .tag(ticket.title)
                    .tint(.red) // Puedes personalizar el color
            }
        }
        .mapStyle(.standard(elevation: .realistic)) // Vista de manejo con elevación
    }
}

#Preview {
    MapView()
        .environmentObject(TicketViewModel()) // Asegura que el ViewModel esté presente en las vistas previas
}
