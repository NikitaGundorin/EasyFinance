//
//  CategoryViewController.swift
//  EasyFinance
//
//  Created by Никита Гундорин on 04.04.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var dimmerView: UIView!
    @IBOutlet weak var addTextField: UITextField!
    @IBOutlet var dataProvider: CategoryDataProvider!
    @IBOutlet weak var addButton: AddButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var statusBarBlur: UIVisualEffectView!
    @IBOutlet weak var statusBarBlurHeight: NSLayoutConstraint!
    
    var viewModel: CategoryViewModel!
    
    private var itemsToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataProvider.delegate = self
        
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
        
        viewModel = CategoryViewModel()
        dataProvider.viewModel = viewModel
        
        statusBarBlurHeight.constant = SceneDelegate.statusBarHeight ?? 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        itemsToken = viewModel.categories.observe { [weak tableView] changes in
            guard let tableView = tableView else { return }
            
            switch changes {
            case .initial:
                break
            case .update(_, let deletions, _, _):
                if deletions.count == 0 {
                    tableView.reloadData()
                }
            case .error: break
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
        guard let name = addTextField.text,
            name != ""
            else {
                UIView.animate(withDuration: 0.2) {
                    self.view.bringSubviewToFront(self.popupView)
                    self.dimmerView.backgroundColor = UIColor(white: 0, alpha: 0.5)
                    self.addTextField.becomeFirstResponder()
                    self.addButton.isEnabled = false
                }
                return
        }
        do {
            try viewModel.addCategory(name: name)
        }
        catch {
            let title = NSLocalizedString("Category already exists", comment: "Category alert title")
            let message = NSLocalizedString("A category with the same name already exists, select a different name", comment: "Category alert message")
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

            let ok = NSLocalizedString("Ok", comment: "Ok alert action")
            alert.addAction(UIAlertAction(title: ok, style: .default, handler: nil))

            present(alert, animated: true)
            return
        }
        dismissKeyboard()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dvc = segue.destination as? ExpenseViewController,
            let row = tableView.indexPathForSelectedRow?.row
        else {
            return
        }
        
        let category = viewModel.categories[row]
        dvc.category = category
    }
}
