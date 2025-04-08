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
    
    //MARK - @IBOutlet
    @IBOutlet var apelidoTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var genderDropDown: DropDown!
    
    //MARK - Var and Lets
    var doDaPrepo: String = ""
    
    //MARK - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem?.tintColor = .black
        navigationItem.backButtonTitle = "Voltar"
        self.configDropDown()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK - Funcions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func configDropDown () {
        genderDropDown.isUserInteractionEnabled = true
        genderDropDown.inputView = UIView()
        genderDropDown.tintColor = .clear

        genderDropDown.optionArray = ["Masculino","Feminino"]
        self.genderDropDown.arrowSize = 5
        self.genderDropDown.selectedRowColor = .lightGray
        
        if genderDropDown.text == "Masculino" {
            doDaPrepo = "Do"
        } else {
            doDaPrepo = "Da"
        }
    }
    
    //MARK - @IBAction
    @IBAction func startButtom(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "TasksScreen", bundle: nil)
        if let LoginVC = storyboard.instantiateViewController(withIdentifier: "TasksScreen") as? TestViewController {
            navigationController?.pushViewController(LoginVC, animated: true)
        }
        
    }
    
}

//let nickNameLogin = apelidoTextField.text ?? ""

//vc.loadViewIfNeeded()
//vc.nickname = nickNameLogin
//vc.nameUser.text = nickNameLogin

//let attributedString = NSMutableAttributedString(string: nickNameLogin)
//let nameUserColor = UIColor(hex: "#77D36A")
//let range = NSRange(location: 0, length: nickNameLogin.count)
//attributedString.addAttribute(.foregroundColor, value: nameUserColor, range: range)
//vc.nameUser.attributedText = attributedString

//UserDefaults.standard.set(nickNameLogin, forKey: "nickname")
//UserDefaults.standard.synchronize()
