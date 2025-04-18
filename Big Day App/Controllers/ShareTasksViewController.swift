//
//  ShareTasksViewController.swift
//  Big Day App
//
//  Created by Davy Sousa on 18/04/25.
//

import UIKit

class ShareTasksViewController: UIViewController {

    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var copyBtn: UIButton!
    @IBOutlet weak var storyBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
    }

    @IBAction func cancelShare(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func copyBtn(_ sender: UIButton) {
    }
    
    @IBAction func saveBtn(_ sender: UIButton) {
    }
    
    @IBAction func storyBtn(_ sender: UIButton) {
    }
    
}
