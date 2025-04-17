import Foundation
import UIKit

protocol editTaskProtocol {
    func saveEdit (nameEdited: String, timeEdited: String?)
        
}

class EditViewController: UIViewController {
    
    //MARK - @IBOutlet
    @IBOutlet var saveEdit: UIButton!
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var switchTime: UISwitch!
    @IBOutlet var editTime: UIDatePicker!
    @IBOutlet var editNameTextField: UITextField!
    @IBOutlet weak var myView: UIView!
    @IBOutlet var cancelBtn: UIButton!
    
    //MARK - Var and Let
    var delegate: editTaskProtocol?
    var taskController: TaskViewController = TaskViewController()
    var tasks: [Task] = []
    var taskToEdit: Task?
    
    //MARK - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        editTime.isHidden = !switchTime.isOn
        configMyView()
        if let task = taskToEdit {
            editNameTextField.text = task.title
            if !task.time!.isEmpty {
                switchTime.isOn = true
                editTime.isHidden = false
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                if let date = formatter.date(from: task.time!) {
                    editTime.date = date
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK - Functions
    @objc func getTime() -> String {
        
        if !switchTime.isOn {
            return ""
        }
        
        let selectedTime = editTime.date
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let timeString = formatter.string(from: selectedTime)
        return timeString
    }
    
    //MARK - @IBAction
    private func configMyView() {
        myView.layer.cornerRadius = 16
        myView.layer.shadowColor = UIColor.black.cgColor
        myView.layer.shadowOpacity = 0.2
        myView.layer.shadowOffset = CGSize(width: 0, height: 4)
        myView.layer.shadowRadius = 10
        myView.layer.masksToBounds = false

    }
    
    @IBAction func closeWindow(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func saveEdit(_ sender: UIButton) {
        guard let name = editNameTextField.text, !name.isEmpty else { return }
        let time = getTime()
            
        delegate?.saveEdit(nameEdited: name, timeEdited: time.isEmpty ? nil : time)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func choseTime(_ sender: UISwitch) {
        editTime.isHidden = !sender.isOn
    }
    
}

