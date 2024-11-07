//
//  TokenModel.swift
//  mycover-app
//
//  Created by Joel Vargas on 06/11/24.
//

import Foundation

struct TokenModel: Identifiable {
    let id = UUID() // Agregar conformidad a Identifiable
    let ticketID: UUID
    let title: String
    let headline: String
    let acquisitionDate: Date
    
    // Genera el token en formato de cadena
    func generateTokenString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let dateStr = formatter.string(from: acquisitionDate)
        
        return "Ticket: \(title), Headline: \(headline), Date Acquired: \(dateStr)"
    }
}


