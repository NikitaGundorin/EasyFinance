//
//  IncomeViewController.swift
//  EasyFinance
//
//  Created by Никита Гундорин on 04.04.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class IncomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var dataProvider: IncomeDataProvider!
    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var addButton: AddButton!
    @IBOutlet weak var addTextField: UITextField!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var viewModel: IncomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
          NotificationCenter.default.addObserver(self,
                                                 selector: #selector(keyboardWillShow),
                                                 name: UIResponder.keyboardWillShowNotification,
                                                 object: nil)
        
          NotificationCenter.default.addObserver(self,
                                                 selector: #selector(keyboardWillHide),
                                                 name: UIResponder.keyboardWillHideNotification,
                                                 object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

        view.addGestureRecognizer(tap)
        
        viewModel = IncomeViewModel()
        dataProvider.viewModel = viewModel
        balance.text = viewModel.balance
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else { return }
        self.bottomConstraint.constant = keyboardSize.height
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.bottomConstraint.constant = 0
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        guard let value = addTextField.text,
            value != ""
            else {
                UIView.animate(withDuration: 0.2) {
                    self.view.bringSubviewToFront(self.popupView)
                    self.popupView.backgroundColor = UIColor(white: 0, alpha: 0.5)
                    self.addTextField.becomeFirstResponder()
                }
                return
            }
        dismissKeyboard()
        addTextField.text = ""
        self.view.bringSubviewToFront(tableView)
    }
}
