//
//  ShareTasksViewController.swift
//  Big Day App
//
//  Created by Davy Sousa on 18/04/25.
//

import UIKit

class ShareTasksViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var copyBtn: UIButton!
    @IBOutlet weak var viewShare: UIView!
    @IBOutlet weak var storyBtn: UIButton!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameUserLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var nameUser: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var tasks: [Task] = []
    var nickname = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        nickname = UserDefaults.standard.string(forKey: "nickname") ?? "Usuário"
        if let savedImageData = UserDefaults.standard.data(forKey: "profileImageView"),
           let savedImage = UIImage(data: savedImageData) {
            profileImageView.image = savedImage
        }
        updateLabelDate()
        backgroundImage()
        configNameUser()
        tableViewConfig()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
            profileImageView.layer.cornerRadius = 40 / 2
    }
    
    func tableViewConfig() {
        tableView.isScrollEnabled = false
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.isUserInteractionEnabled = false
    }
    
    func configNameUser() {
        nameUser.text = nickname
        nameUser.textColor = UIColor.white
        nameUser.font = UIFont(name: "Montserrat-ExtraBold", size: 12)
        nameUserLabel.textColor = UIColor.white
        nameUserLabel.font = UIFont(name: "Montserrat-ExtraBold", size: 12)
        
    }
    
    func updateLabelDate() {
        let currentDate = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: "pt_BR")
        let day = formatter.string(from: currentDate)
        dayLabel.text = day.prefix(1).uppercased() + day.dropFirst()
        
        formatter.dateFormat = "dd 'de' MMMM"
        dateLabel.text = formatter.string(from: currentDate)
    }
    
    func backgroundImage() {
        let backgroundImage = UIImageView(frame: viewShare.bounds)
        backgroundImage.image = UIImage(named: "FUNDOTRANSPARENTE")
        backgroundImage.contentMode = .scaleAspectFill
        viewShare.insertSubview(backgroundImage, at: 0)
    }
    
    
    @IBAction func cancelShare(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func copyBtn(_ sender: UIButton) {
        guard let image = createShareImage() else { return }
        UIPasteboard.general.image = image
    }
    
    @IBAction func saveBtn(_ sender: UIButton) {
        guard let image = createShareImage() else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    @IBAction func storyBtn(_ sender: UIButton) {
        guard let image = createShareImage(),
                  let urlScheme = URL(string: "instagram-stories://share"),
                  UIApplication.shared.canOpenURL(urlScheme) else {
                print("Instagram não disponível.")
                return
            }

            let pasteboardItems: [String: Any] = [
                "com.instagram.sharedSticker.backgroundImage": image
            ]
            let pasteboardOptions = [
                UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300)
            ]

            UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
            UIApplication.shared.open(urlScheme, options: [:], completionHandler: nil)
    }
    
    func renderViewAsImage(view: UIView) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        return renderer.image { _ in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
    }
    
    
    func createShareImage() -> UIImage? {
        let backgroundImage = viewShare.subviews.first(where: { $0 is UIImageView })
        backgroundImage?.isHidden = true
        let image = renderViewAsImage(view: viewShare)
        backgroundImage?.isHidden = false
        
        return image
    }

}
extension ShareTasksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return tasks.count
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("Criando célula para linha \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        
        let task = tasks[indexPath.row]
        cell.taskText?.text = task.title
        cell.timeTask?.text = task.time
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        if task.isCompleted {
            cell.imageFill?.image = UIImage(systemName: "checkmark.circle.fill")

            let attributedText = NSAttributedString(
                string: task.title,
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.white
                ]
            )
            cell.taskText?.attributedText = attributedText
        } else {
            cell.imageFill?.image = UIImage(systemName: "circle")

            let attributedText = NSAttributedString(
                string: task.title,
                attributes: [
                    .strikethroughStyle: 0,
                    .foregroundColor: UIColor.white
                ]
            )
            cell.taskText?.attributedText = attributedText
        }
        return cell
    }
}
