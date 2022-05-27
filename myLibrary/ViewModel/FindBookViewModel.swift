//
//  FindBookViewModel.swift
//  myLibrary
//
//  Created by Andrade Torquato, Jonathas on 24/05/22.
//

import Foundation

import RxSwift

struct FindBookViewModel {
    let book = Books.book
    let presentBooks = BehaviorSubject<[Book]>(value: [])
    let bag = DisposeBag()
    
    func start()
    {
        self.book.books.subscribe(onNext:{ list in
            self.presentBooks.onNext(list)
        }).disposed(by: bag)
    }
    func filterBooks (by search : String) {
        if search != ""{
            var books : [Book] = []
            for book in book.books.value {
                if book.name.contains(search) {
                    books.append(book)
                }
            }
            self.presentBooks.onNext(books)
        }
        else{
            self.presentBooks.onNext(self.book.books.value)
        }
    }
    
}
