//
//  RegisterViewController.swift
//  myLibrary
//
//  Created by Andrade Torquato, Jonathas on 20/05/22.
//

import UIKit
import RxCocoa
import RxSwift

class RegisterViewController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var knowledgeTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    let bag = DisposeBag()
    let book : BehaviorSubject<Book> = BehaviorSubject(value: Book(name: "", author: ""))
    
    let viewModel = RegisterBookViewModel()
    var textFields : [UITextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.knowledgeTextField.delegate = self
        self.nameTextField.delegate = self
        self.authorTextField.delegate = self
        
        Observable.combineLatest(self.authorTextField.rx.text, self.nameTextField.rx.text).subscribe(onNext:{ aText, nText in
            self.saveButton.isEnabled = (aText != nil && aText! != "" && nText != nil && nText! != "")
        }).disposed(by: bag)
        
        book.subscribe(onNext: { item in
            self.knowledgeTextField.text = item.knowledgeArea
            self.nameTextField.text = item.name
            self.authorTextField.text = item.author
            
        }).disposed(by: bag)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor(named: "BlueLogo") ?? .black
        textFields = [knowledgeTextField!, nameTextField!, authorTextField!]
        for textField in textFields {
            textField.layer.cornerRadius = 0
            textField.clipsToBounds = true
            textField.layer.borderColor = UIColor(named: "BrownLogo")?.cgColor ?? UIColor.black.cgColor
            textField.layer.borderWidth = 2
            textField.backgroundColor = .systemBackground
            
        }
        
    }
    
    fileprivate func presentAlert(title: String, message : String, buttonMessage : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonMessage, style: .default)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func didTapSave(_ sender: UIButton) {
        do {
            if let name = self.nameTextField.text, let author = self.authorTextField.text, self.authorTextField.hasText && self.nameTextField.hasText{
                let book = Book(name: name, author: author, knowledgeArea: self.knowledgeTextField.text)
                switch viewModel.saveBook(book){
                case .success(let string):
                    if try self.book.value().name != ""{
                        _ = viewModel.deleteBook(try self.book.value())
                        self.book.onNext(book)
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        self.presentAlert(title: "Sucesso!", message: string, buttonMessage: "OK")
                        for textField in textFields {
                            textField.text = ""
                        }
                    }
                case .failure(let error):
                    self.presentAlert(title: "Erro!", message: error.rawValue , buttonMessage: "OK")
                }
                    
                    
            }
            else {
                
                var remainingFields = "Os campos "
                for textField in textFields {
                    if (!textField.hasText || (textField.text ?? "" == "")) && !textField.accessibilityIdentifier!.contains("Área do conhecimento")
                    {
                        remainingFields += textField.accessibilityIdentifier! + ", "
                    }
                }
                remainingFields += "faltam ser preenchidos."
                
                self.presentAlert(title: "Campos faltantes", message: remainingFields, buttonMessage: "OK")
            }
        }
        catch {
            print(error)
        }
        
    }
}
extension RegisterViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}
