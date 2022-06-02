//
//  AbstractBook.swift
//  myLibrary
//
//  Created by Andrade Torquato, Jonathas on 01/06/22.
//

import Foundation

protocol AbstractBook : Codable{
    var author : String {get set}
    var name : String {get set}
    var knowledgeArea : String? {get set}
}
