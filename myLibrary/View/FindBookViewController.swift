//
//  FindBookViewController.swift
//  myLibrary
//
//  Created by Andrade Torquato, Jonathas on 24/05/22.
//

import UIKit
import RxSwift
import RxCocoa

class FindBookViewController: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var booksTableView: UITableView!
    let bag = DisposeBag()
    let viewModel = FindBookViewModel()
    let cellFont = UIFont(name: "Courier New Bold", size: 20)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.start()
        
        self.booksTableView.register(UINib(nibName: "FindBookTableViewCell", bundle: .main), forCellReuseIdentifier: "FindBookTableViewCell")
        self.viewModel.presentBooks.bind(to: booksTableView.rx.items(cellIdentifier: "FindBookTableViewCell")){ row, itemBook , cell in
            if let cell = cell as? FindBookTableViewCell {
                cell.authorLabel.text = itemBook.author
                cell.titleLabel.text = itemBook.name
            }
            else {
                cell.textLabel?.text = itemBook.name
                if let font = self.cellFont {
                    cell.textLabel?.font = font
                }
                
            }
        }.disposed(by: bag)
        self.booksTableView.rx.modelSelected(Book.self).subscribe(onNext: { book in
            self.booksTableView.deselectRow(at: self.booksTableView.indexPathForSelectedRow!, animated: true)
            let vc = BookDetailsViewController()
            vc.modalTransitionStyle = .coverVertical
            self.navigationController?.pushViewController(vc, animated: true)
            vc.book.onNext(book)
        }).disposed(by: bag)
        
        self.searchTextField.delegate = self
        self.searchTextField.layer.borderColor = UIColor(named: "BrownLogo")?.cgColor ?? UIColor.brown.cgColor
        
        self.searchTextField.layer.borderWidth = 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor(named: "BlueLogo") ?? .link
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.square.dashed"), style: .plain, target: self, action: #selector(didTapAdd))
    }
    @objc func didTapAdd(){
        let vc = RegisterViewController()
        vc.modalTransitionStyle = .flipHorizontal
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension FindBookViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        self.viewModel.filterBooks(by: textField.text ?? "")
        
        return false
    }
}
