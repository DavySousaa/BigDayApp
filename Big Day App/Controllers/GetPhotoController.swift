
//  GetPhotoViewController.swift
//  Big Day App
//
//  Created by Davy Sousa on 15/03/25.
//

import UIKit
import TOCropViewController

class GetPhotoController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate {
    
    @IBOutlet var profileImageView: UIImageView!
    
    @IBOutlet var nickNameTextFi: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.layer.cornerRadius = 100 / 2
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
            profileImageView.layer.cornerRadius = 100 / 2
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
            let newNickname = nickNameTextFi.text ?? ""
                
            UserDefaults.standard.set(newNickname, forKey: "nickname") // Salva no UserDefaults
            UserDefaults.standard.synchronize() // Garante que o valor foi salvo imediatamente
                
            vc.nickname = newNickname
            self.navigationController?.popViewController(animated: true)
        }
    }

}
