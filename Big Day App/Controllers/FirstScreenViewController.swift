//
//  ViewController.swift
//  Big Day App
//
//  Created by Davy Sousa on 08/02/25.
//

import UIKit

class FirstScreenViewController: UIViewController {

    
    @IBOutlet var textMainLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backButtonTitle = "Voltar"
        navigationController?.navigationBar.tintColor = .black
        
        
        textMainLabel.font = UIFont(name: "Montserrat-ExtraBold", size: 30)
        let fullText = "Transformando\ndias comuns em\nBig Day"
        let attributedString = NSMutableAttributedString(string: fullText)
               
        textMainLabel.numberOfLines = 3
        textMainLabel.textAlignment = .center
        textMainLabel.lineBreakMode = .byWordWrapping
               
        let bigDayColor = UIColor(hex: "#77D36A")
               
        let range = (fullText as NSString).range(of: "Big Day")
        attributedString.addAttribute(.foregroundColor, value: bigDayColor, range: range)

        textMainLabel.attributedText = attributedString
    }
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
