//
//  mycover_appApp.swift
//  mycover-app
//
//  Created by Alumno on 22/10/24.
//

import SwiftUI

@main
struct MyCoverApp: App {
    @StateObject private var ticketsVM = TicketViewModel()
    @StateObject private var storeKitManager = StoreKitManager()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ticketsVM) // Pasa el TicketViewModel a toda la aplicación
                .environmentObject(storeKitManager)
        }
    }
}

