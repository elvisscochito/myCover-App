//
//  PageView.swift
//  mycover-app
//
//  Created by Joel Vargas on 23/10/24.
//


//
//  PageView.swift
//  myTickets
//
//  Created by Elviro Dominguez Soriano on 25/02/24.
//

import SwiftUI

struct PageView: View {
    var page: PageModel
    var body: some View {
        VStack {
            Spacer()
            Text(page.title)
                .font(.largeTitle)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .padding()
            Text(page.headline)
                .font(.title3)
                .foregroundColor(.gray)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
        }
    }
}

#Preview {
    PageView(page: PageModel.defaultPage)
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}
