//
//  RegisteBookViewModel.swift
//  myLibrary
//
//  Created by Andrade Torquato, Jonathas on 23/05/22.
//

import Foundation
import RxSwift

class RegisterBookViewModel {
    
    let books = Books.book
    let book : BehaviorSubject<Book> = BehaviorSubject(value: Book(name: "", author: ""))
    fileprivate let bookFactory = BookFactory()
    
    init(){}
    
    func saveBook (bookName: String, authorName: String, knowledgeArea: String? = nil) -> Result<String, Books.BookError>{
        
        let correctBook = bookFactory.createBook(name: bookName, author: authorName, knowledgeArea: knowledgeArea) as! Book
        
        while correctBook.name.last == " " {
            correctBook.name.removeLast()
        }
        while correctBook.author.last == " " {
            correctBook.author.removeLast()
        }
        if correctBook.name == "" {return .failure(Books.BookError.invalidName)}
        if correctBook.author == "" {return .failure(Books.BookError.invalidAuthor)}
        
        switch books.saveNewBook(correctBook){
        case .success(let string):
            do{
                if try (self.book.value().name != "") {
                    _ = self.deleteBook(try self.book.value())
                    self.book.onNext(correctBook)
                }
                return .success(string)
            } catch {
                return .failure(Books.BookError.internalError)
            }
        case .failure(let error):
            return .failure(error)
        }
        
        
    }
    
    func deleteBook (_ book : Book) -> Result<String, Books.BookError>{
        return books.deleteBook(book)
    }
    
}
