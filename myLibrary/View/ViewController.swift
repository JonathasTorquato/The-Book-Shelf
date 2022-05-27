//
//  ViewController.swift
//  myLibrary
//
//  Created by Andrade Torquato, Jonathas on 20/05/22.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func didTapRegister(_ sender: UIButton) {
        
        let vc = RegisterViewController()
        vc.modalTransitionStyle = .flipHorizontal
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func didTapFindBook(_ sender: UIButton) {
        let vc = FindBookViewController()
        vc.modalTransitionStyle = .flipHorizontal
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}

