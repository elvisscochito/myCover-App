//
//  PageModel.swift
//  myTickets
//
//  Created by Elviro Dominguez Soriano on 25/02/24.
//

import Foundation

struct PageModel: Identifiable, Equatable {
    let id = UUID()
    var title: String
    var headline: String
    var pageNumber: Int
    
    
    static var defaultPage = PageModel(title: "Title", headline: "Aa", pageNumber: 0)
    
    static var samplePages: [PageModel] = [
        PageModel(title: "What is?", headline: "Create, share and save unique and personalized digital tickets directly to the pre-installed Apple 'Wallet' app", pageNumber: 0),
        PageModel(title: "Easily save your tickets", headline: "Easily save your entry passes from any work, school or social event directly to your Apple Wallet app using PassKit technology. You can also can crate new ones and share them with everyone", pageNumber: 1),
        PageModel(title: "Search. Get. Done.", headline: "Just use Apple wallet to get in to your event. No need to worry about physical ticket, just tap and go (how cool is that?)", pageNumber: 2),
        PageModel(title: "Wanna join a party or want to start your party?", headline: "No matter what you want, you can join a party or start your own party using myCover app.", pageNumber: 2),
    ]
    
}
