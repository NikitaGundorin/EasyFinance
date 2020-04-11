//
//  IncomeViewController.swift
//  EasyFinance
//
//  Created by Никита Гундорин on 04.04.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit
import RealmSwift

class IncomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var dataProvider: IncomeDataProvider!
    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var addButton: AddButton!
    @IBOutlet weak var addTextField: UITextField!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var dimmerView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var statusBarBlur: UIVisualEffectView!
    @IBOutlet weak var statusBarBlurHeight: NSLayoutConstraint!
    
    var viewModel: IncomeViewModel!
    
    private var itemsToken: NotificationToken?
    private var balanceToken: NotificationToken?
    
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
        
        addTextField.addTarget(self, action: #selector(self.enableAddButton(_:)), for: .editingChanged)
        
        viewModel = IncomeViewModel()
        dataProvider.viewModel = viewModel
        dataProvider.delegate = self
        balance.text = viewModel.balanceText
        statusBarBlurHeight.constant = SceneDelegate.statusBarHeight ?? 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        itemsToken = viewModel.incomes.observe { [weak tableView] changes in
            guard let tableView = tableView else { return }
            
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, _, _):
                if deletions.count == 0 {
                    tableView.reloadData()
                }
            case .error: break
            }
        }
        
        balanceToken = viewModel.balance.observe { change in
            switch change {
            case .error(_):
                break
            case .change(_):
                self.balance.text = self.viewModel.balanceText
            case .deleted:
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
        let offset = keyboardSize.height - self.tabBarController!.tabBar.frame.size.height
        self.bottomConstraint.constant = offset
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
            self.view.bringSubviewToFront(self.statusBarBlur)
            self.addTextField.text = ""
            self.addButton.isEnabled = true
        })
    }
    
    @objc func enableAddButton(_ textField: UITextField) {
        if (addTextField.text != "" && addTextField.text != nil) {
            addButton.isEnabled = true
        }
        else {
            addButton.isEnabled = false
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        guard let value = addTextField.text,
            value != ""
            else {
                UIView.animate(withDuration: 0.2) {
                    self.view.bringSubviewToFront(self.popupView)
                    self.dimmerView.backgroundColor = UIColor(white: 0, alpha: 0.5)
                    self.addTextField.becomeFirstResponder()
                    self.addButton.isEnabled = false
                }
                return
        }
        viewModel.addIncome(value: value)
        dismissKeyboard()
    }
}
