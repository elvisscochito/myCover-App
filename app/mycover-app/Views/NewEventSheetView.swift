import SwiftUI
import MapKit
import Combine

struct NewEventSheetView: View {
    @ObservedObject var ticketsVM: TicketViewModel
    @Binding var isShowingSheet: Bool
    
    
    @State private var usertitle = ""
    @State private var userheadline = ""
    @State private var direction = ""
//    @State private var selectedCoordinate = CLLocationCoordinate2D(latitude: 25.650694, longitude: -100.291868)
//    @State private var region = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude: 25.650694, longitude: -100.291868),
//        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
//    )
    @State /*private*/ var keyboardHeight: CGFloat = 0
    /*private*/ var keyboardPublisher = NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)

    var body: some View {
        VStack {
            Spacer()
            Text("New Event")
                .font(.title)
                .fontWeight(.bold)
            
            Form {
                TextField("Title", text: $usertitle)
                TextField("Headline", text: $userheadline)
                //TextField("Direction", text: $direction)
                
//                Section(header: Text("Select Location")) {
//                    Map(coordinateRegion: $region) {_ in 
//                        // Anotaciones para tickets existentes
//                        ForEach(ticketsVM.arrTickets) { ticket in
//                            Annotation("Ticket", coordinate: ticket.coordinates) {
//                                Image(systemName: "mappin")
//                                    .foregroundColor(.blue)
//                                    .font(.title)
//                            }
//                        }
//                        
//                        // Anotación para la ubicación seleccionada
//                        Annotation("Selected Location", coordinate: selectedCoordinate) {
//                            Image(systemName: "mappin.circle.fill")
//                                .foregroundColor(.red)
//                                .font(.title)
//                        }
//                    }
//                    .frame(height: 200)
//                    .gesture(DragGesture(minimumDistance: 0)
//                        .onEnded { value in
//                            let mapView = MKMapView(frame: .zero)
//                            mapView.region = region
//                            let touchPoint = CGPoint(x: value.location.x, y: value.location.y)
//                            let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
//                            selectedCoordinate = touchCoordinate
//                        }
//                    )
//
//                    HStack {
//                        Text("Latitude: \(selectedCoordinate.latitude)")
//                        Spacer()
//                        Text("Longitude: \(selectedCoordinate.longitude)")
//                    }
//                }
            }
            //.padding(.bottom, keyboardHeight)
            
            Button(action: {
                ticketsVM.createEvent(title: usertitle, description: usertitle)
//                ticketsVM.postTicket(
//                    description: title,
//                    staffName: headline
//                    /*title: title,
//                    headline: headline*//*,
//                    direction: direction,s
//                    coordinates: selectedCoordinate*/
//                )
                isShowingSheet = false
            }) {
                Text("Create Event")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            if let isSuccessful = ticketsVM.isRequestSuccessful {
                Text(isSuccessful ? "Request was successful! 🎉" : "Request failed 😞")
                    .foregroundColor(isSuccessful ? .green : .red)
            }
        }
        .onReceive(keyboardPublisher) { notification in
            if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                keyboardHeight = frame.minY < UIScreen.main.bounds.height ? frame.height : 0
            }
        }
        .animation(.easeOut, value: keyboardHeight)
    }
}

#Preview {
    NewEventSheetView(
        ticketsVM: TicketViewModel(),
        isShowingSheet: .constant(false)
    )
}
