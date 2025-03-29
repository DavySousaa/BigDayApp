//
//  newTasksViewController.swift
//  Big Day App
//
//  Created by Davy Sousa on 15/03/25.
//

import UIKit

class NewTasksViewController: UIViewController {
    
    
    @IBOutlet var timePicker: UIDatePicker!
    @IBOutlet var hourLabel: UILabel!
    @IBOutlet var newTaskField: UITextField!
    @IBOutlet var newTextLabel: UILabel!
    @IBOutlet var timeSwitch: UISwitch!
    @IBOutlet var textUP: UILabel!
    
    var taskController: TaskViewController = TaskViewController()
    
    var tasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true

        textUP.font = UIFont(name: "Montserrat-ExtraBold", size: 30)
        let fullText = "Nova tarefa para \nseu Big Day!"
        let attributedString = NSMutableAttributedString(string: fullText)
        
        textUP.numberOfLines = 2
        textUP.textAlignment = .center
        textUP.lineBreakMode = .byWordWrapping
        
        let bigDayColor = UIColor(hex: "#77D36A")
        
        let range = (fullText as NSString).range(of: "seu Big Day!")
        attributedString.addAttribute(.foregroundColor, value: bigDayColor, range: range)
        
        textUP.attributedText = attributedString
        newTaskField.delegate = self
        
        timePicker.isHidden = !timeSwitch.isOn
        
    }
    
    @IBAction func addTask(_ sender: UIButton) {
        createTask()
        self.performSegue(withIdentifier: "unwindToTaskView", sender: self)
    }
    
    private func createTask() {
        var list:[Task] = TaskSuportHelper().getTask()
        let selectedTime = getTime()
        var task: Task = Task(id: list.count+1, title: newTaskField.text ?? "Nova tarefa", time: selectedTime ?? "", isCompleted: false)
        
        list.append(task)
        TaskSuportHelper().addTask(lista: list)
        
        self.tasks = list
        self.taskController.tasks = self.tasks
        self.taskController.tableView?.reloadData()
        
        self.dismiss(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func getTime() -> String {
        
        if !timeSwitch.isOn {
            return ""
        }
        
        let selectedTime = timePicker.date
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let timeString = formatter.string(from: selectedTime)
        return timeString
    }
    
    @IBAction func choseTime(_ sender: UISwitch) {
        timePicker.isHidden = !sender.isOn
    }
    
    @IBAction func cancelAddTask(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
}
extension NewTasksViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
