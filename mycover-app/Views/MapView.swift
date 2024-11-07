import SwiftUI
import MapKit

struct MapView: View {
    
    // Coordenadas de las ubicaciones en Monterrey
    let mainLocation = CLLocationCoordinate2D(
        latitude: 25.650694,
        longitude: -100.291868) // Av. Eugenio Garza Sada Sur, Monterrey
    
    let referencePoint1 = CLLocationCoordinate2D(
        latitude: 25.652000,
        longitude: -100.289000) // Punto de referencia cercano
    
    let referencePoint2 = CLLocationCoordinate2D(
        latitude: 25.653500,
        longitude: -100.292500) // Otro punto de referencia cercano
    
    @State private var camera: MapCameraPosition = .automatic
    
    var body: some View {
        Map(position: $camera) {
            
            Marker("Tecnológico", systemImage: "building", coordinate: mainLocation)
                .tint(.blue)
            
            Annotation("Punto de referencia 1", coordinate: referencePoint1) {
                Image(systemName: "person.crop.artframe")
                    .foregroundStyle(.white)
                    .padding()
                    .background(.red)
                    .clipShape(Circle())
            }
            
            Marker("Punto de referencia 2", systemImage: "building.columns", coordinate: referencePoint2)
                .tint(.orange)
        }
        .mapStyle(.standard(elevation: .realistic)) // Vista de manejo con elevación
    }
}

#Preview {
    MapView()
}
