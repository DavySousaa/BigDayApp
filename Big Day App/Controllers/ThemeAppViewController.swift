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
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = "Voltar"
        navigationController?.navigationBar.tintColor = .black
    }
   
    @IBAction func saveBtn(_ sender: UIButton) {
    }

}

extension ThemeAppViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "themeCell", for: indexPath) as! TemaAppCell
        return cell
    }
}

extension ThemeAppViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
    }
    
}
