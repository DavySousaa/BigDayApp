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
        
        
        textMainLabel.font = UIFont(name: "Montserrat-ExtraBold", size: 28)
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

