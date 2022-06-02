//
//  Books.swift
//  myLibrary
//
//  Created by Andrade Torquato, Jonathas on 23/05/22.
//

import Foundation
import RxSwift
import RxRelay

class Books {
    
    static var book : Books = {
        let book = Books()
        book.retrievePlist()
        return book
    }()
    let dataPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Books.plist")
    
    var books : BehaviorRelay <[Book]> = BehaviorRelay(value: [])
    
    fileprivate init(){
        //Para completar a abstração de Singleton, a utilização de um inicializador privado para que quem for utilizar a classe não crie uma nova instancia sem querer
    }
    
    
    fileprivate func savePlist(_ booksArray : [Book]) ->  Result<String, BookError> {
        guard let dataPath = self.dataPath else {return .failure(BookError.internalError)}
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(booksArray)
            try data.write(to: dataPath)
            self.books.accept(booksArray)
            return .success("Lista de livros salva com suceso!")
        }catch {
            return .failure(.internalError)
        }
    }
    
    fileprivate func containBook(_ book : Book) -> Bool {
        return self.books.value.contains (where: {
            return $0.name.lowercased() == book.name.lowercased() && $0.author.lowercased() == book.author.lowercased() && ($0.knowledgeArea ?? "").lowercased() == (book.knowledgeArea  ?? "").lowercased()
        })
    }

    fileprivate func retrievePlist(){
        if let dataPath = self.dataPath {
            let decoder = PropertyListDecoder()
            do {
                let data = try Data(contentsOf: dataPath)
                let decoded = try decoder.decode([Book].self, from: data)
                self.books.accept(decoded)
            } catch let error {
                print(error)
                self.books.accept([])
            }
        }
        else {
            self.books.accept([])
        }
    }
    
    func saveNewBook(_ book : Book) -> Result<String,BookError> {
        if self.containBook(book) {
            return .failure(BookError.repeatedName)
        }
        var newArray = self.books.value
        newArray.append(book)
        newArray.sort { return $0.name.lowercased() < $1.name.lowercased() && $0.author.lowercased() < $1.author.lowercased()}
        return self.savePlist(newArray)
    }
    
    func deleteBook(_ book : Book) -> Result<String,BookError> {
        if self.containBook(book) {
            var newArray = self.books.value
            
            newArray.removeAll { return $0.name.lowercased() == book.name.lowercased() && book.author.lowercased() == $0.author.lowercased() && ($0.knowledgeArea?.lowercased() ?? "") == (book.knowledgeArea?.lowercased() ?? "") }
            return self.savePlist(newArray)
        }
        return .failure(BookError.bookNotFound)
    }
    
    enum BookError : String, LocalizedError {
        case repeatedName = "Nome do livro com o mesmo autor já cadastrado"
        case invalidName = "Nome do livro inválido"
        case invalidAuthor = "Nome do autor inválido"
        case internalError = "Erro ao encontrar arquivo para salvar"
        case bookNotFound = "Livro não cadastrado"
    }
    
}
