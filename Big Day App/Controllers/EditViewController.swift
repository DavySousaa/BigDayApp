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
    @IBOutlet var cancelBtn: UIButton!
    
    //MARK - Var and Let
    var delegate: editTaskProtocol?
    var taskController: TaskViewController = TaskViewController()
    var tasks: [Task] = []
    
    //MARK - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        editTime.isHidden = !switchTime.isOn
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
    @IBAction func closeWindow(_ sender: UIButton) {
        if sender == cancelBtn {
            self.dismiss(animated: true) {
                guard self.delegate != nil else { return }
            }
        } else {
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func choseTime(_ sender: UISwitch) {
        editTime.isHidden = !sender.isOn
    }
    
}

