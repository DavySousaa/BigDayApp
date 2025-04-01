import UIKit
import TOCropViewController

class TaskViewController: UIViewController, UINavigationControllerDelegate {
    
    //MARK - @IBOutlet
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameUserLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var nameUser: UILabel!
    @IBOutlet weak var tableView: UITableView!

    //MARK - Var and Lets
    var tasks: [Task] = []
    var nickname = ""
    var prepoDoDa = ""
    
    //MARK - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabelDate()
        
        navigationItem.hidesBackButton = true
        
        tableView.dataSource = self
        tableView.delegate = self
        
        nickname = UserDefaults.standard.string(forKey: "nickname") ?? "Usuário"
        if let savedImageData = UserDefaults.standard.data(forKey: "profileImageView"),
            let savedImage = UIImage(data: savedImageData) {
            profileImageView.image = savedImage
        }
        
        nameUserLabel.font = UIFont(name: "Montserrat-ExtraBold", size: 24)
        nameUser.font = UIFont(name: "Montserrat-ExtraBold", size: 24)
        
        updatePrepo()
        nicknameAttributedString()
        prepoAttributedString()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let savedImageData = UserDefaults.standard.data(forKey: "profileImageView"),
            let savedImage = UIImage(data: savedImageData) {
            profileImageView.image = savedImage
        }
        self.loadTasks()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
            profileImageView.layer.cornerRadius = 77 / 2
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? EditViewController {
            controller.delegate = self
        }
    }
    
    //MARK - Funcions
    func nicknameAttributedString() {
        nameUser.text = nickname
        let attributedString = NSMutableAttributedString(string: nickname)
        let nameUserColor = UIColor(hex: "#77D36A")
        let range = NSRange(location: 0, length: nickname.count)
        attributedString.addAttribute(.foregroundColor, value: nameUserColor, range: range)
        nameUser.attributedText = attributedString
    }
    
    func prepoAttributedString() {
        var firstText = "Big Day do"
        if firstText.contains("do") {
            firstText = firstText.replacingOccurrences(of: "do", with: prepoDoDa)
        }
        let attributedString = NSMutableAttributedString(string: firstText)
        nameUserLabel.attributedText = attributedString
    }
    
    func loadTasks() {
        self.tasks = TaskSuportHelper().getTask()
        self.tableView?.reloadData()
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
    
    
    func saveTasks() {
        TaskSuportHelper().addTask(lista: tasks)
    }
    
    func updatePrepo() {
        if let vc = self.navigationController?.viewControllers.first(where: { $0 is LoginViewController }) as? LoginViewController {
            if vc.genderDropDown.text == "Feminino" {
                prepoDoDa = "da"
            } else {
                prepoDoDa = "do"
            }
        }

    }
    
    func switchEditBtn() {
        let storyboard = UIStoryboard(name: "EditMenu", bundle: nil)
        if let editVC = storyboard.instantiateViewController(withIdentifier: "EditViewController") as? EditViewController {
            editVC.delegate = self
            present(editVC, animated: true, completion: nil)
        }
    }
   
    //MARK - @IBAction
    @IBAction func cleanTasks(_ sender: UIButton) {
        tasks.removeAll()  // Remove as tarefas da lista
        saveTasks()  // Salva as tarefas no UserDefaults
        tableView.reloadData()  // Atualiza a tableView
    }
    
    @IBAction func newTaskButton(_ sender: Any) {
    }
    
}

//MARK - Extensions

extension TaskViewController: editTaskProtocol {
    func saveEdit(nameEdited: String, timeEdited: String?) {
        
    }
}

extension TaskViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        
        let task = tasks[indexPath.row]
        cell.taskText?.text = task.title
        cell.timeTask?.text = task.time
                
        if task.isCompleted {
            cell.imageFill?.image = UIImage(systemName: "checkmark.circle.fill")
        } else {
            cell.imageFill?.image = UIImage(systemName: "circle")
        }
                
        return cell
    }
}

extension TaskViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TaskCell {
            tasks[indexPath.row].isCompleted.toggle()
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            self.tasks.remove(at: indexPath.row)
            TaskSuportHelper().addTask(lista: self.tasks)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Editar") { (action, view, completionHandler) in
            self.switchEditBtn()
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .red
        editAction.image = UIImage(systemName: "square.and.pencil")
        editAction.backgroundColor = .black
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])

    }
}
