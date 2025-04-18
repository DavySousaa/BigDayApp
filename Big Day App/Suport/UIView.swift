//
//  UIView.swift
//  Big Day App
//
//  Created by Davy Sousa on 18/04/25.
//

import UIKit

extension UIView {
    public func showMessage(view: UIViewController, message: String, title: String? = "Atenção", btnTitle: String? = "Confirmar") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: btnTitle, style: .default, handler: nil))
        view.present(alert, animated: true)
    }
    

}
