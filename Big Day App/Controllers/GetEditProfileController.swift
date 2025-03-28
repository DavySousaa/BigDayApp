
//  GetPhotoViewController.swift
//  Big Day App
//
//  Created by Davy Sousa on 15/03/25.
//

import UIKit
import TOCropViewController

class GetEditProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate {
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nickNameTextFi: UITextField!
    
    var loginViewController: LoginViewController = LoginViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        if let savedImageData = UserDefaults.standard.data(forKey: "profileImageView"),
           let savedImage = UIImage(data: savedImageData) {
            profileImageView.image = savedImage
        }
        
        profileImageView.layer.cornerRadius = 100 / 2
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        placeholderOne()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        placeholderTwo()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = 100 / 2
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Método para abrir a galeria
    func loadPhoto(for imageView: UIImageView) {
        self.profileImageView = imageView // Guarda a referência da imagem que será atualizada
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    // Quando o usuário seleciona a imagem
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            dismiss(animated: true) {
                self.showCropViewController(image: selectedImage)
            }
        }
    }
    
    // Se o usuário cancelar
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Abrindo a tela de recorte
    func showCropViewController(image: UIImage) {
        let cropViewController = TOCropViewController(croppingStyle: .circular, image: image)
        cropViewController.delegate = self
        present(cropViewController, animated: true, completion: nil)
    }
    
    // Quando o usuário termina de recortar a imagem
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        profileImageView?.image = image // Atualiza a imagem corretamente
        cropViewController.dismiss(animated: true, completion: nil)
    }
    
    // Se o usuário cancelar o recorte
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editPhoto(_ sender: UIButton) {
        loadPhoto(for: profileImageView)
    }
    
    @IBAction func getChanges(_ sender: UIButton) {
        if let vc = self.navigationController?.viewControllers.first(where: { $0 is TaskViewController }) as? TaskViewController {
            let newNickname = nickNameTextFi.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                    
            if let previousNickname = UserDefaults.standard.string(forKey: "nickname"), newNickname?.isEmpty ?? true {
                nickNameTextFi.text = previousNickname
            }
            
            let finalNickname = nickNameTextFi.text ?? ""
            let newPhotoProfile = profileImageView?.image
            
            vc.nickname = finalNickname
            vc.nameUserLabel.text = newNickname
            vc.profileImageView.image = newPhotoProfile
            
            if let newPhotoProfile = profileImageView?.image,
               let imageData = newPhotoProfile.jpegData(compressionQuality: 0.8) {
                UserDefaults.standard.set(imageData, forKey: "profileImageView")
                UserDefaults.standard.synchronize()
            }
            
            UserDefaults.standard.set(finalNickname, forKey: "nickname")
            UserDefaults.standard.synchronize()
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelEdit(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    func placeholderOne() {
        if let vc = self.navigationController?.viewControllers.first(where: { $0 is LoginViewController }) as? LoginViewController {
            nickNameTextFi.placeholder = vc.apelidoTextField.text
        }
    }
    
    func placeholderTwo() {
        if let vc = self.navigationController?.viewControllers.first(where: { $0 is TaskViewController }) as? TaskViewController {
            nickNameTextFi.placeholder = vc.nickname
        }
    }
}
