//
//  TodoListProvider.swift
//  TodoApp_CoreData
//
//  Created by kawaharadai on 2018/04/02.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import CoreData
import UIKit

protocol TodoListProviderDelegate: class {
    func deleteToDo(index: Int)
}

class TodoListProvider: NSObject {
    var todoData = [NSManagedObject]()
    weak var delegate:TodoListProviderDelegate?
}

// MARK: - UITableViewDataSource
extension TodoListProvider: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return todoData.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoListCell.identifier,
                                                       for: indexPath) as? TodoListCell else {
            fatalError("セルの作成に失敗")
        }
        
        cell.taskInfo = todoData[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.delegate?.deleteToDo(index: indexPath.row)
        }
    }
}
