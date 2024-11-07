//
//  TokenModel.swift
//  mycover-app
//
//  Created by Joel Vargas on 06/11/24.
//

import Foundation
import MapKit

struct TokenModel: Identifiable {
    let id = UUID()
    let ticketID: UUID
    let title: String
    let headline: String
    let direction: String
    let coordinates: CLLocationCoordinate2D
    let acquisitionDate: Date
    
    // Genera el token en formato de cadena
    func generateTokenString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let dateStr = formatter.string(from: acquisitionDate)
        
        // Formato mejorado con todos los detalles y coordenadas desglosadas
        return """
        Title: \(title)
        Headline: \(headline)
        Direction: \(direction)
        Coordinates: \(coordinates.latitude), \(coordinates.longitude)
        Date Acquired: \(dateStr)
        """
    }
}
