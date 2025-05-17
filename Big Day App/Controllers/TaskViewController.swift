import UIKit
import TOCropViewController

class TaskViewController: UIViewController, UINavigationControllerDelegate, UITableViewDropDelegate, UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: any UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let task = tasks[indexPath.row]
            let itemProvider = NSItemProvider(object: task.title as NSString)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = task
            return [dragItem]
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: any UITableViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }

        coordinator.items.forEach { dropItem in
            if let sourceIndexPath = dropItem.sourceIndexPath,
                let task = dropItem.dragItem.localObject as? Task {

                tableView.performBatchUpdates({
                    tasks.remove(at: sourceIndexPath.row)
                    tasks.insert(task, at: destinationIndexPath.row)

                    tableView.deleteRows(at: [sourceIndexPath], with: .automatic)
                    tableView.insertRows(at: [destinationIndexPath], with: .automatic)
                }, completion: { _ in
                    self.saveTasks()
                })

                coordinator.drop(dropItem.dragItem, toRowAt: destinationIndexPath)
            }
        }
    }
    
    
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
    var selectedTaskID: UUID?

    //MARK - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabelDate()
        
        navigationItem.hidesBackButton = true
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self

        nickname = UserDefaults.standard.string(forKey: "nickname") ?? "Usuário"
        if let savedImageData = UserDefaults.standard.data(forKey: "profileImageView"),
            let savedImage = UIImage(data: savedImageData) {
            profileImageView.image = savedImage
        }
        
        nameUserLabel.font = UIFont(name: "Montserrat-ExtraBold", size: 19)
        nameUser.font = UIFont(name: "Montserrat-ExtraBold", size: 19)
        
        nicknameAttributedString()
        
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
            profileImageView.layer.cornerRadius = 60 / 2
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? EditViewController {
            controller.delegate = self
        }
        if segue.identifier == "goToShare", let destinationVC = segue.destination as? ShareTasksViewController {
            destinationVC.tasks = self.tasks
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
    
    func switchEditBtn(task: Task) {
        let storyboard = UIStoryboard(name: "EditMenu", bundle: nil)
        if let editVC = storyboard.instantiateViewController(withIdentifier: "EditViewController") as? EditViewController {
            editVC.delegate = self
            editVC.taskToEdit = task
            present(editVC, animated: true, completion: nil)
        }
    }
   
    //MARK - @IBAction

    @IBAction func newTaskButton(_ sender: Any) {
    }
    
}

//MARK - Extensions

extension TaskViewController: editTaskProtocol {
    func saveEdit(nameEdited: String, timeEdited: String?) {
        guard let id = selectedTaskID else { return }
                         
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            tasks[index].title = nameEdited
            tasks[index].time = timeEdited ?? ""
                             
            saveTasks()
            tableView.reloadData()
        }
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

            let attributedText = NSAttributedString(
                string: task.title,
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.darkGray
                ]
            )
            cell.taskText?.attributedText = attributedText
        } else {
            cell.imageFill?.image = UIImage(systemName: "circle")

            let attributedText = NSAttributedString(
                string: task.title,
                attributes: [
                    .strikethroughStyle: 0,
                    .foregroundColor: UIColor.label
                ]
            )
            cell.taskText?.attributedText = attributedText
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedTask = tasks.remove(at: sourceIndexPath.row)
        tasks.insert(movedTask, at: destinationIndexPath.row)
        saveTasks()
    }

}

extension TaskViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TaskCell {
            tasks[indexPath.row].isCompleted.toggle()
            saveTasks()
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
            let task = self.tasks[indexPath.row]
            self.selectedTaskID = task.id
            self.switchEditBtn(task: task)
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .red
        editAction.image = UIImage(systemName: "square.and.pencil")
        editAction.backgroundColor = .black
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])

    }
}
