//
//  AbstractFactory.swift
//  myLibrary
//
//  Created by Andrade Torquato, Jonathas on 01/06/22.
//

import Foundation

protocol AbstractBookFactory{
    func createBook(name: String, author: String, knowledgeArea : String?) -> AbstractBook
}
