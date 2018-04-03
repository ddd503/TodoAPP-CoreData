//
//  TodoListDao.swift
//  TodoApp_CoreData
//
//  Created by kawaharadai on 2018/04/02.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import CoreData
import UIKit

protocol TodoListDaoDelegate: class {
    func reload(dataSource: [NSManagedObject])
}

class TodoListDao: NSObject {
    
    //MARK: - Properties
    var fetchedArray = [NSManagedObject]()
    weak var delegate: TodoListDaoDelegate?
    
    private func getContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        return managedContext
    }
    
    /// 全件取得
    func select() {
        guard let context = getContext() else {
            print("NSManagedObjectContextの取得に失敗")
            return
        }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Todo")
        
        /// ascendind:true 昇順、false 降順
        let sortDescripter = NSSortDescriptor(key: "registTime", ascending: false)
        fetchRequest.sortDescriptors = [sortDescripter]
        
        do {
            fetchedArray = try context.fetch(fetchRequest)
            delegate?.reload(dataSource: fetchedArray)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    /// 新規保存
    func save(newTask: String) {
        guard let context = getContext() else {
            print("NSManagedObjectContextの取得に失敗")
            return
        }
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Todo",
                                                      in: context) else {
                                                        print("NSEntityDescriptionの生成に失敗")
                                                        return
        }
        
        let task = NSManagedObject(entity: entity,
                                   insertInto: context)
        
        task.setValue(NSDate(), forKeyPath: "registTime")
        task.setValue(newTask, forKeyPath: "task")
        
        do {
            try context.save()
            select()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    /// 更新
    func update(task: NSManagedObject, updateTask: String) {
        guard let context = getContext() else {
            print("NSManagedObjectContextの取得に失敗")
            return
        }
        
        /// 情報のアップデート
        task.setValue(NSDate(), forKeyPath: "registTime")
        task.setValue(updateTask, forKey: "task")
        
        do {
            try context.save()
            select()
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    /// 1件削除
    func delete(task: NSManagedObject) {
        guard let context = getContext() else {
            print("NSManagedObjectContextの取得に失敗")
            return
        }
        
        context.delete(task)
        
        do {
            try context.save()
            select()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    /// 全件削除
    func allDelete() {
        guard let context = getContext() else {
            print("NSManagedObjectContextの取得に失敗")
            return
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            select()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
}
