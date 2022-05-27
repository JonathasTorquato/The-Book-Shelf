//
//  RegisteBookViewModel.swift
//  myLibrary
//
//  Created by Andrade Torquato, Jonathas on 23/05/22.
//

import Foundation

class RegisterBookViewModel {
    
    let books = Books.book
    
    init(){}
    
    func saveBook (_ book : Book ) -> Result<String, Books.BookError>{
        
        var correctBook = book
        
        while correctBook.name.last == " " {
            correctBook.name.removeLast()
        }
        while correctBook.author.last == " " {
            correctBook.author.removeLast()
        }
        if correctBook.name == "" {return .failure(Books.BookError.invalidName)}
        if correctBook.author == "" {return .failure(Books.BookError.invalidAuthor)}
        
        return books.saveNewBook(correctBook)
        
    }
    
    func deleteBook (_ book : Book) -> Result<String, Books.BookError>{
        return books.deleteBook(book)
    }
    
}
