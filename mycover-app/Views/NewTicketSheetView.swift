import SwiftUI
import MapKit

struct NewTicketSheetView: View {
    
    @ObservedObject var ticketsVM: TicketViewModel
    @Binding var isShowingSheet: Bool
    
    @State private var title = ""
    @State private var headline = ""
    @State private var direction = ""
    @State private var selectedCoordinate = CLLocationCoordinate2D(latitude: 25.650694, longitude: -100.291868) // Coordenadas iniciales
    
    @State private var camera: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 25.650694, longitude: -100.291868),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    )

    var body: some View {
        VStack {
            Spacer()
            Text("New Event")
                .font(.title)
                .fontWeight(.bold)
            
            Form {
                TextField("Title", text: $title)
                TextField("Headline", text: $headline)
                TextField("Direction", text: $direction)

                // Mapa para seleccionar coordenadas
                Section(header: Text("Select Location")) {
                    Map(position: $camera) {
                        // Marcador en la ubicación seleccionada, que se moverá cada vez que el usuario toque en el mapa
                        Marker("Selected Location", coordinate: selectedCoordinate)
                            .tint(.red)
                        
                        // Marcadores para otros tickets
                        ForEach(ticketsVM.arrTickets) { ticket in
                            let ticketLocation = ticket.coordinates
                            Marker(ticket.title, coordinate: ticketLocation)
                                .tag(ticket.title)
                                .tint(.blue) // Color diferente para diferenciar
                        }
                    }
                    .mapStyle(.standard(elevation: .realistic))
                    .frame(height: 200)
                    .onTapGesture { location in
                        // Convertir la ubicación del toque a coordenadas y actualizar el marcador seleccionado
                        let mapPoint = MKMapPoint(x: location.x, y: location.y)
                        let coordinate = mapPoint.coordinate
                        selectedCoordinate = coordinate
                    }

                    // Muestra las coordenadas seleccionadas
                    HStack {
                        Text("Latitude: \(selectedCoordinate.latitude)")
                        Spacer()
                        Text("Longitude: \(selectedCoordinate.longitude)")
                    }
                }
            }
            
            Button(action: {
                // Crear y agregar el nuevo ticket usando las coordenadas seleccionadas
                ticketsVM.createTicket(
                    title: title,
                    headline: headline,
                    direction: direction,
                    coordinates: selectedCoordinate
                )
                isShowingSheet = false
            }) {
                Text("Create Event")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}

#Preview {
    NewTicketSheetView(ticketsVM: TicketViewModel(), isShowingSheet: .constant(true))
}
