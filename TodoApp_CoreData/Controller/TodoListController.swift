//
//  TodoListController.swift
//  TodoApp_CoreData
//
//  Created by kawaharadai on 2018/04/02.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import CoreData
import UIKit

class TodoListController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak private var todoList: UITableView!
    @IBOutlet weak private var allDeleteButton: UIButton!
    
    //MARK: - Properties
    private let provider = TodoListProvider()
    private let alertHelper = AlertHelper()
    private let todoListDao = TodoListDao()
    private let cellHeight: CGFloat = 60
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        todoListDao.select()
    }
    
    // MARK: - Action
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        todoList.isEditing = editing
        allDeleteButton.isHidden = !editing
    }
    
    @IBAction func addTask(_ sender: Any) {
        let addAlert = alertHelper.addAlert(type: .add,
                                            title: "新規追加",
                                            message: nil)
        self.present(addAlert, animated: true, completion: nil)
    }
    
    @IBAction func deleteAll(_ sender: Any) {
        todoListDao.allDelete()
    }
    
    // MARK: - Private
    private func setup() {
        navigationItem.rightBarButtonItem = editButtonItem
        setupTableView()
        setupDelegate()
    }
    
    private func setupTableView() {
        todoList.dataSource = provider
        todoList.delegate = self
        todoList.rowHeight = cellHeight
    }
    
    private func setupDelegate() {
        alertHelper.delegate = self
        provider.delegate = self
        todoListDao.delegate = self
    }
}

// MARK: - AlertHelperDelegate
extension TodoListController: AlertHelperDelegate {
    func save(inputType: inputType, inputTask: String) {
        switch inputType {
        case .add:
            todoListDao.save(newTask: inputTask)
            todoListDao.select()
        case .update(let updateTask):
            todoListDao.update(task: updateTask, updateTask: inputTask)
        }
    }
}

// MARK: - TodoListProviderDelegate
extension TodoListController: TodoListProviderDelegate {
    func deleteToDo(index: Int) {
        let selectedTask = provider.todoData[index]
        todoListDao.delete(task: selectedTask)
        provider.todoData.remove(at: index)
    }
}

// MARK: - TodoListDaoDelegate
extension TodoListController: TodoListDaoDelegate {
    func reload(dataSource: [NSManagedObject]) {
        DispatchQueue.main.async {
            self.provider.todoData = dataSource
            self.todoList.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate
extension TodoListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if todoList.isEditing {
            let selectedTask = provider.todoData[indexPath.row]
            let updateAlert = alertHelper.addAlert(type: .update(task: selectedTask),
                                                   title: "内容変更",
                                                   message: nil)
            self.present(updateAlert, animated: true, completion: nil)
        }
    }
}
