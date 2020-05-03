//
//  ExpenseViewController.swift
//  EasyFinance
//
//  Created by Никита Гундорин on 05.04.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit
import RealmSwift

class ExpenseViewController: UIViewController {
    @IBOutlet private var dataProvider: ExpenseDataProvider!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var popupView: UIView!
    @IBOutlet private weak var dimmerView: UIView!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var valueTextField: UITextField!
    @IBOutlet private weak var addButton: AddButton!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var paymentChartButton: AddButton!
    
    private var viewModel: ExpenseViewModel!
    var category: Category!
    
    private var itemsToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboardBehavior()
        setupDelegates()
        
        navigationItem.title = category.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        itemsToken = viewModel.expenses.observe { [weak tableView] changes in
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
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else { return }
        self.bottomConstraint.constant = keyboardSize.height
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        self.bottomConstraint.constant = 0
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.2, animations: {
            self.dimmerView.backgroundColor = UIColor(white: 0, alpha: 0)
        }, completion: { _ in
            self.view.bringSubviewToFront(self.tableView)
            self.view.bringSubviewToFront(self.paymentChartButton)
            self.valueTextField.text = ""
            self.nameTextField.text = ""
            self.addButton.isEnabled = true
        })
    }
    
    @objc private func enableAddButton() {
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
    
    @IBAction private func addButtonPressed(_ sender: Any) {
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
        viewModel.addExpense(name: name, value: value, category: category)
        dismissKeyboard()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dvc = segue.destination as? CategoryChartViewController else {
            return
        }
        dvc.category = category
    }
    
    private func setupKeyboardBehavior() {
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
        
        nameTextField.addTarget(self, action: #selector(enableAddButton), for: .editingChanged)
        valueTextField.addTarget(self, action: #selector(enableAddButton), for: .editingChanged)
    }
    
    private func setupDelegates() {
        viewModel = ExpenseViewModel(category: category)
        dataProvider.viewModel = viewModel
        dataProvider.delegate = self
    }
}
