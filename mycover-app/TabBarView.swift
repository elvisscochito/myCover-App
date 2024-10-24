//
//  TabBarView.swift
//  mycover-app
//
//  Created by Joel Vargas on 24/10/24.
//


//
//  TabBarView.swift
//  myTickets
//
//  Created by Elviro Dominguez Soriano on 25/02/24.
//

import SwiftUI

struct TabBarView: View {
    
    var body: some View {
        TabView(selection: /*@START_MENU_TOKEN@*/.constant(1)/*@END_MENU_TOKEN@*/,
                content:  {
            (Home())
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                 
        })
        .accentColor(.white)
    }
}

#Preview {
    TabBarView()
}
