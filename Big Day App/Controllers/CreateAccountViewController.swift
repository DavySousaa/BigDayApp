//
//  loginViewController.swift
//  Big Day App
//
//  Created by Davy Sousa on 05/03/25.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore


class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var textUp: UILabel!
    @IBOutlet var apelidoTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
      
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem?.tintColor = .black
        navigationItem.backButtonTitle = "Voltar"

        configEyePassword()
        configTextUp()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTasksSegue",
           let destinationVC = segue.destination as? TaskViewController,
           let nickNameLogin = sender as? String {
            
            destinationVC.nickname = nickNameLogin
            
            // Se quiser já aplicar o estilo aqui:
            let attributedString = NSMutableAttributedString(string: nickNameLogin)
            let nameUserColor = UIColor(hex: "#77D36A")
            let range = NSRange(location: 0, length: nickNameLogin.count)
            attributedString.addAttribute(.foregroundColor, value: nameUserColor, range: range)
            destinationVC.nameUser?.attributedText = attributedString
        }
    }
    
    func configTextUp() {
        textUp.font = UIFont(name: "Montserrat-ExtraBold", size: 30)
        let fullText = "Crie sua conta \ne comece hoje."
        let attributedString = NSMutableAttributedString(string: fullText)
        
        textUp.numberOfLines = 2
        textUp.textAlignment = .center
        textUp.lineBreakMode = .byWordWrapping
        
        let bigDayColor = UIColor(hex: "#77D36A")
        
        let range = (fullText as NSString).range(of: "e comece hoje.")
        attributedString.addAttribute(.foregroundColor, value: bigDayColor, range: range)
        
        textUp.attributedText = attributedString
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    private func validedField() -> String {
        var error: String = String.empty()
        
        if self.apelidoTextField.text == String.empty() {
            error = "Informe o seu apelido."
        } else  if self.emailTextField.text == String.empty() {
            error = "Informe o seu e-mail."
        } else  if self.passwordTextField.text == String.empty() {
            error = "Informe a sua senha."
        }
        return error
    }
    
    
    func configEyePassword() {
        let olhoButton = UIButton(type: .custom)
        olhoButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        olhoButton.tintColor = .gray
        olhoButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        olhoButton.addTarget(self, action: #selector(toggleSenha), for: .touchUpInside)
        
        passwordTextField.rightView = olhoButton
        passwordTextField.rightViewMode = .always
    }
    
    @objc func toggleSenha(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        
        // Atualiza o ícone
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    
    @IBAction func startBtn(_ sender: UIButton) {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let apelido = apelidoTextField.text ?? ""

                // Cria o usuário no Firebase Authentication
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.view.showMessage(view: self, message: error.localizedDescription)
                return
            }

            guard let user = authResult?.user else { return }

                    // Salva os dados no Firestore
            let db = Firestore.firestore()
            db.collection("users").document(user.uid).setData([
                "nickname": apelido,
                "email": email
            ]) { err in
                if let err = err {
                    self.view.showMessage(view: self, message: "Erro ao salvar dados: \(err.localizedDescription)")
                } else {
                            // Sucesso, segue para outra tela
                    self.performSegue(withIdentifier: "toTasksSegue", sender: apelido)
                }
            }
        }
    }
}

