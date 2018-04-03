//
//  AlertHelper.swift
//  TodoApp_CoreData
//
//  Created by kawaharadai on 2018/04/02.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import CoreData
import UIKit

enum inputType {
    case add
    case update(task: NSManagedObject)
}

protocol AlertHelperDelegate: class {
    func save(inputType: inputType, inputTask: String)
}

/// テキストボックス入りのアラートを生成する
final class AlertHelper: NSObject {
    
    weak var delegate: AlertHelperDelegate?
    
    private var alert = UIAlertController()
    
    func addAlert(type: inputType,
                  title: String?,
                  textFieldText: String?,
                  rightButtonActionName: String = "OK",
                  leftButtonActionName: String = "キャンセル") -> UIAlertController {
        
        alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let rightButtonAction = UIAlertAction(title: rightButtonActionName, style: .default) { _ in
            // テキストフィールド内のテキストを取得
            if
                let textField = self.alert.textFields?.first,
                let inputTask = textField.text {
                self.delegate?.save(inputType: type, inputTask: inputTask)
            }
        }
        
        let leftButtonAction = UIAlertAction(title: leftButtonActionName, style: .cancel, handler: nil)
        
        alert.addAction(leftButtonAction)
        alert.addAction(rightButtonAction)
        
        alert.addTextField {  [weak self] (textField)  in
            textField.delegate = self
            textField.placeholder = "タスクを入力"
            textField.text = textFieldText
            // OKボタンを非活性
            if
                let okButton = self?.alert.actions.last,
                textFieldText == nil {
                okButton.isEnabled = false
            }
        }
        return alert
    }
}

/// 文字数をカウントし、0ならOKを非活性
extension AlertHelper: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        if let okButton = alert.actions.last {
            
            let textFieldText = (textField.text ?? "") as NSString
            let textAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
            okButton.isEnabled = textAfterUpdate.count >= 1
        }
        
        return true
    }
}

