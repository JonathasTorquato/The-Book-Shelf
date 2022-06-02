//
//  Book.swift
//  myLibrary
//
//  Created by Andrade Torquato, Jonathas on 25/05/22.
//

import Foundation


class Book : AbstractBook {
    var author: String
    
    var name: String
    
    var knowledgeArea: String?
    init(name: String, author: String, knowledgeArea: String? = nil){
        self.name = name
        self.author = author
        self.knowledgeArea = knowledgeArea
    }
}
