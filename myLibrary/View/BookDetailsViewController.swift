//
//  BookDetailsViewController.swift
//  myLibrary
//
//  Created by Andrade Torquato, Jonathas on 26/05/22.
//

import UIKit
import RxSwift

class BookDetailsViewController: UIViewController {

    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var knowledgeAreaLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    let bag = DisposeBag()
    let books = Books.book
    let book : BehaviorSubject<Book> = BehaviorSubject(value: Book(name: "", author: ""))
    override func viewDidLoad() {
        super.viewDidLoad()
        book.subscribe(onNext:{ item in
            self.titleLabel.text = item.name
            self.knowledgeAreaLabel.text = item.knowledgeArea ?? ""
            self.authorLabel.text = item.author
        }).disposed(by: bag)
        editButton.layer.borderColor = UIColor(named: "BlueLogo")?.cgColor ?? UIColor.link.cgColor
        editButton.layer.borderWidth = 2
        editButton.clipsToBounds = true
        editButton.layer.cornerRadius = 5
        deleteButton.layer.cornerRadius = 5
        
        
    }
    
    fileprivate func presentAlert(title: String, message : String, buttonMessage : String, completion : (()->Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonMessage, style: .default) { alert  in
            if let completion = completion {completion()}
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

    
    @IBAction func didTapEdit(_ sender: UIButton) {
        
        let vc = RegisterViewController()
        vc.modalTransitionStyle = .partialCurl
        self.navigationController?.pushViewController(vc, animated: true)
        do{vc.book.onNext(try self.book.value())}
        catch{
            print(error)
        }
        vc.book.subscribe(onNext: { [weak self] item in
            self?.book.onNext(item)
            
        }).disposed(by: bag)
        
    }
    @IBAction func didTpDelete(_ sender: UIButton) {
        do {
            switch books.deleteBook(try book.value()) {
            case .success(let string) :
                self.presentAlert(title: "Sucesso!", message: string, buttonMessage: "OK") {
                    
                    self.navigationController?.popViewController(animated: true)
                }
                
            case .failure(let error) :
                self.presentAlert(title: "Erro!", message: error.rawValue, buttonMessage: "OK")
            }
        } catch {
            print(error)
        }
    }
    
}
