//
//  TodoListCell.swift
//  TodoApp_CoreData
//
//  Created by kawaharadai on 2018/04/02.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import CoreData
import UIKit

class TodoListCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak private var task: UILabel!
    @IBOutlet weak private var time: UILabel!
    
    //MARK: - Properties
    static var identifier: String {
        return String(describing: self)
    }
    
    var taskInfo: NSManagedObject? {
        didSet {
            setInfo(info: taskInfo)
        }
    }
    
    private func setInfo(info: NSManagedObject?) {
        task.text = info?.value(forKey: "task") as? String
        if let date = info?.value(forKey: "registTime") as? NSDate {
            time.text = dateFormat(date: date)
        }
    }
    
    /// NSDataのフォーマットを変更
    private func dateFormat(date: NSDate) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        return dateFormatter.string(from: date as Date)
    }
}
