//
//  BookFactory.swift
//  myLibrary
//
//  Created by Andrade Torquato, Jonathas on 01/06/22.
//

import Foundation

class BookFactory : AbstractBookFactory {
    func createBook(name: String, author: String, knowledgeArea: String?) -> AbstractBook {
        let book = Book(name: name, author: author, knowledgeArea: knowledgeArea)
        return book
    }
    
    
}
