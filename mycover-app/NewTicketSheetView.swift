//
//  NewTicketSheetView.swift
//  mycover-app
//
//  Created by Joel Vargas on 24/10/24.
//


//
//  NewTicketSheetView.swift
//  myTickets
//
//  Created by Elviro Dominguez Soriano on 25/02/24.
//

import SwiftUI

struct NewTicketSheetView: View {
    
    @State private var title = ""
    @State private var headline = ""
    @State private var date = Date.now
    @State private var backgroundColor = Color.black
    @State private var textColor = Color.white
    
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            Text("New Ticket")
                .font(.title)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            Form {
                TextField("Title", text: $title)
                TextField("Headline", text: $headline)
//                DatePicker("Datetime", selection: $date)
//                ColorPicker("Background Color", selection: $backgroundColor)
//                ColorPicker("Text Color", selection: $textColor)
            }
            Image("Add_to_Apple_Wallet_badge")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 275)
            Button(action: {}) {
                Text("Create event")
            }

        }
        
    }
}

#Preview {
    NewTicketSheetView()
}
