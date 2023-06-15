//
//  ViewController.swift
//  simple_Realm_To_Do_List
//
//  Created by Kirill Khomicevich on 15.06.2023.
//

import UIKit
import RealmSwift
import SnapKit

// MARK: - ToDoListModel
class ToDoListModel: Object {
    @objc dynamic var task: String = ""
    @objc dynamic var completed = false
}

class ViewController: UIViewController {

    // MARK: - Private constants
    private let cellId = "cell"
    private let realm = try! Realm()

    // MARK: - Private variables
    private var tasks: Results<ToDoListModel>!

    // MARK: - Private interface constants
    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupController()
    }

}

// MARK: - private extension
private extension ViewController {

    func setupController() {
        setupAddSubview()
        setupConstraints()
        setupTableView()
        setupNavigationView()
        setupRealm()
    }

    func setupAddSubview() {
        view.addSubview(tableView)
    }

    func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.top.bottom.right.left.equalTo(view)
        }
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }

    func setupNavigationView() {
        self.title = "To Do List"
        self.navigationItem.rightBarButtonItem = setupRightButtonNavigationView()
    }

    func setupRealm() {
        tasks = realm.objects(ToDoListModel.self)
    }

    func setupAlert() {
        let alert = UIAlertController(title: "New task",
                                      message: "Please fill in the field",
                                      preferredStyle: .alert)
        var alertTextField: UITextField!
        alert.addTextField { textField in
            alertTextField = textField
            textField.placeholder = "New task"
        }

        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            guard let text = alertTextField.text, !text.isEmpty else { return }

            let task = ToDoListModel()
            task.task = text

            try! self.realm.write() {
                self.realm.add(task)
            }
            self.reloadData()
        }
    
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive )

        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }

    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

}

// MARK: - Methods private extension
private extension ViewController {

    func setupRightButtonNavigationView() -> UIBarButtonItem {
        let button = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(didTapRightBarButtonItem))
        return button
    }

}

// MARK: - @objc private extension
@objc private extension ViewController {

    func didTapRightBarButtonItem() {
        setupAlert()
    }

}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            guard let sSelf = self else { return }

            let selectRow = sSelf.tasks[indexPath.row]
            try! sSelf.realm.write() {
                sSelf.realm.delete(selectRow)
            }
            sSelf.reloadData()
            completionHandler(true)
        }

        deleteAction.image = UIImage(systemName: "trash")

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }

}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tasks.count != 0 {
            return tasks.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.task
        return cell
    }

}

