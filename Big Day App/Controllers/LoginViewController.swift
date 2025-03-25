//
//  loginViewController.swift
//  Big Day App
//
//  Created by Davy Sousa on 05/03/25.
//

import Foundation
import UIKit
import iOSDropDown

class LoginViewController: UIViewController {
    
    @IBOutlet var apelidoTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var genderDropDown: DropDown!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem?.tintColor = .black
        navigationItem.backButtonTitle = "Voltar"
        self.configDropDown()
        
    }
    
    @IBAction func startButtom(_ sender: UIButton) {
        
    }
    func configDropDown () {
        genderDropDown.optionArray = ["Masculino","Feminino"]
        self.genderDropDown.arrowSize = 5
        self.genderDropDown.selectedRowColor = .lightGray
    }
    
}
