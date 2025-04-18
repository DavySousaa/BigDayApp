//
//  ThemeAppViewController.swift
//  Big Day App
//
//  Created by Davy Sousa on 16/04/25.
//

import UIKit

class ThemeAppViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveBtn: UIButton!
    
    var selectedIndex: IndexPath?
    var themeApp: [Theme] = [
        Theme(colorOne: UIColor(hex: "#111111"), colorTwo: UIColor(hex: "#77D36A"), titleColor: "Padrão"),
        Theme(colorOne: UIColor(hex: "#4A1A00"), colorTwo: UIColor(hex: "#FF5733"), titleColor: "Energia"),
        Theme(colorOne: UIColor(hex: "#1E3A5F"), colorTwo: UIColor(hex: "#3B82F6"), titleColor: "Foco"),
        Theme(colorOne: UIColor(hex: "#5A1442"), colorTwo: UIColor(hex: "#E6399B"), titleColor: "Criatividade"),
        Theme(colorOne: UIColor(hex: "#2D4037"), colorTwo: UIColor(hex: "#2ECC71"), titleColor: "Equilíbrio"),
        Theme(colorOne: UIColor(hex: "#5A4500"), colorTwo: UIColor(hex: "#FFD700"), titleColor: "Determinação")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = "Voltar"
        navigationController?.navigationBar.tintColor = .black
        tableView.delegate = self
        tableView.dataSource = self
    }
   
    @IBAction func saveBtn(_ sender: UIButton) {
    }

}

extension ThemeAppViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themeApp.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "themeCell", for: indexPath) as! TemaAppCell
        let itemTheme = themeApp[indexPath.row]
        
        cell.labelText.text = itemTheme.titleColor
        cell.colorOne.backgroundColor = itemTheme.colorOne
        cell.colorTwo.backgroundColor = itemTheme.colorTwo
    
        cell.colorOne.layer.cornerRadius = 100
        cell.colorTwo.layer.cornerRadius = 100
        cell.colorOne.layer.masksToBounds = true
        cell.colorTwo.layer.masksToBounds = true
        
        if selectedIndex == indexPath {
            cell.checkImage?.image = UIImage(systemName: "checkmark")
        } else {
            cell.checkImage?.image = .none
        }
        cell.setNeedsLayout()
        cell.layoutIfNeeded()

        return cell
    }
}

extension ThemeAppViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TemaAppCell {
            selectedIndex = indexPath
            tableView.reloadData()
        }
    }
}
