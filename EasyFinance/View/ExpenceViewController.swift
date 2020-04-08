//
//  ExpenceViewController.swift
//  EasyFinance
//
//  Created by Никита Гундорин on 05.04.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit
import RealmSwift

class ExpenceViewController: UIViewController {
    @IBOutlet var dataProvider: ExpenceDataProvider!
    @IBOutlet weak var paymentScheduleButton: AddButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var dimmerView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var addButton: AddButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var viewModel: ExpenceViewModel!
    var category: Category!
    
    private var itemsToken: NotificationToken?
    
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
        
        dimmerView.addGestureRecognizer(tap)
        
        nameTextField.addTarget(self, action: #selector(self.enableAddButton(_:)), for: .editingChanged)
        valueTextField.addTarget(self, action: #selector(self.enableAddButton(_:)), for: .editingChanged)
        
        viewModel = ExpenceViewModel(category: category)
        dataProvider.viewModel = viewModel
        dataProvider.delegate = self
        
        navigationItem.title = category.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        itemsToken = viewModel.expences.observe { [weak tableView] changes in
            guard let tableView = tableView else { return }
            
            switch changes {
            case .initial:
                break
            case .update(_, let deletions, _, _):
                if deletions.count == 0 {
                     tableView.reloadData()
                }
            case .error:
                break
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        itemsToken?.invalidate()
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
        UIView.animate(withDuration: 0.2, animations: {
            self.dimmerView.backgroundColor = UIColor(white: 0, alpha: 0)
        }, completion: { _ in
            self.view.bringSubviewToFront(self.tableView)
            self.valueTextField.text = ""
            self.nameTextField.text = ""
            self.addButton.isEnabled = true
        })
    }
    
    @objc func enableAddButton(_ textField: UITextField) {
        if (valueTextField.text != "" &&
            valueTextField.text != nil &&
            nameTextField.text != "" &&
            nameTextField.text != nil) {
            
            addButton.isEnabled = true
        }
        else {
            addButton.isEnabled = false
        }
    }
    
    @IBAction func paymentScheduleButtonPressed(_ sender: Any) {
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        guard let name = nameTextField.text,
            name != "",
            let value = valueTextField.text,
            value != ""
            else {
                UIView.animate(withDuration: 0.2) {
                    self.view.bringSubviewToFront(self.popupView)
                    self.dimmerView.backgroundColor = UIColor(white: 0, alpha: 0.5)
                    self.nameTextField.becomeFirstResponder()
                    self.addButton.isEnabled = false
                }
                return
        }
        viewModel.addExpence(name: name, value: value, category: category)
        dismissKeyboard()
    }
}
