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

    var doDaPrepo: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem?.tintColor = .black
        navigationItem.backButtonTitle = "Voltar"
        self.configDropDown()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func startButtom(_ sender: UIButton) {
        if let vc = self.navigationController?.viewControllers.first(where: { $0 is TaskViewController }) as? TaskViewController {
            let nickNameLogin = apelidoTextField.text ?? ""
            
            vc.loadViewIfNeeded()
            vc.nickname = nickNameLogin
            vc.nameUser.text = nickNameLogin
            
            let attributedString = NSMutableAttributedString(string: nickNameLogin)
            let nameUserColor = UIColor(hex: "#77D36A")
            let range = NSRange(location: 0, length: nickNameLogin.count)
            attributedString.addAttribute(.foregroundColor, value: nameUserColor, range: range)
            vc.nameUser.attributedText = attributedString
            
            UserDefaults.standard.set(nickNameLogin, forKey: "nickname")
            UserDefaults.standard.synchronize()
        }
    }
    
    func configDropDown () {
        genderDropDown.optionArray = ["Masculino","Feminino"]
        self.genderDropDown.arrowSize = 5
        self.genderDropDown.selectedRowColor = .lightGray
        self.genderDropDown.text = "Masculino"
        
        if genderDropDown.text == "Masculino" {
            doDaPrepo = "Do"
        } else {
            doDaPrepo = "Da"
        }
    }
}
