//
//  LoginViewController.swift
//  Big Day App
//
//  Created by Davy Sousa on 18/04/25.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configEyePassword()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func configEyePassword() {
        let olhoButton = UIButton(type: .custom)
        olhoButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        olhoButton.tintColor = .gray
        olhoButton.frame = CGRect(x: 0, y: 0, width: 35, height: 30)
        olhoButton.addTarget(self, action: #selector(toggleSenha), for: .touchUpInside)

            // Coloca no lado direito do campo
        passwordTextField.rightView = olhoButton
        passwordTextField.rightViewMode = .always
    }
    
    @objc func toggleSenha(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        
        // Atualiza o ícone
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    private func validedField() -> String {
        var error: String = String.empty()
        
        if self.emailTextField.text == String.empty() {
            error = "Informe o seu e-mail."
        } else  if self.passwordTextField.text == String.empty() {
            error = "Informe a sua senha."
        }
        return error
    }
    
    @IBAction func startButtom(_ sender: UIButton) {
        let erro: String = self.validedField()
        
        if erro != String.empty() {
            self.view.showMessage(view: self, message: erro)
        } else {
            // Pega os valores de email e senha
            let email = emailTextField.text ?? ""
            let password = passwordTextField.text ?? ""
            
            // Tenta fazer login no Firebase Authentication
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                if let error = error {
                    // Caso ocorra algum erro
                    self.view.showMessage(view: self, message: error.localizedDescription)
                } else {
                    // Se o login for bem-sucedido, navega para a próxima tela
                    self.performSegue(withIdentifier: "toTasksSegueTwo", sender: nil)
                }
            }
        }
    }
}
