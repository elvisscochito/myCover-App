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
        PageModel(title: "Who I am?", headline: "I'm Elviss, a Computer Science student at Tecnologico de Monterrey University and this is my app called 'myTickets'", pageNumber: 0),
        PageModel(title: "Easily save your tickets", headline: " Forget about It's an utility app to easily save your entry passes from any work, school or social event directly to your Apple Wallet app using PassKit technology. You can also can crate new ones and share them with everyone", pageNumber: 1),
        PageModel(title: "Search. Get. Done.", headline: "I decided to built this app so that people can avoid using physical tickets at events that are made of paper and contaminate the environment", pageNumber: 2),
    ]
    
}
