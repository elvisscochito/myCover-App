//
//  TokenModel.swift
//  mycover-app
//
//  Created by Joel Vargas on 06/11/24.
//

import Foundation
import MapKit

struct TicketModel: Identifiable {
    let id = UUID()
    let eventID: UUID
    let title: String
    let headline: String
    let name: String
//    let direction: String
//    let coordinates: CLLocationCoordinate2D
//    let acquisitionDate: Date
    
    
}


/*Direction: \(direction)
Coordinates: \(coordinates.latitude), \(coordinates.longitude)
Date Acquired: \(dateStr)*/
