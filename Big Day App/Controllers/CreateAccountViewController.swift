//
//  loginViewController.swift
//  Big Day App
//
//  Created by Davy Sousa on 05/03/25.
//

import Foundation
import UIKit
import iOSDropDown
import FirebaseAuth
import FirebaseFirestore


class CreateAccountViewController: UIViewController {
    
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
        configEyePassword()
        blockType()
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

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    private func validedField() -> String {
        var error: String = String.empty()
        
        if self.apelidoTextField.text == String.empty() {
            error = "Informe o seu apelido."
        } else if self.genderDropDown.text == String.empty() {
            error = "Informe um gênero."
        } else  if self.emailTextField.text == String.empty() {
            error = "Informe o seu e-mail."
        } else  if self.passwordTextField.text == String.empty() {
            error = "Informe a sua senha."
        }
        return error
    }
    
    @objc func configDropDown() {
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
    func blockType() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(configDropDown))
        genderDropDown.addGestureRecognizer(tapGesture)
        genderDropDown.isUserInteractionEnabled = true
        genderDropDown.inputView = UIView() // evita teclado
        genderDropDown.tintColor = .clear // remove cursor piscando
    }
    
    @IBAction func startBtn(_ sender: UIButton) {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let apelido = apelidoTextField.text ?? ""
        let gender = genderDropDown.text ?? "Masculino"

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
                "gender": gender,
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

