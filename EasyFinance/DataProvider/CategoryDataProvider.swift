//
//  CategoryDataProvider.swift
//  EasyFinance
//
//  Created by Никита Гундорин on 04.04.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation
import UIKit

class CategoryDataProvider: NSObject, UITableViewDataSource, UITableViewDelegate {
    weak var viewModel: CategoryViewModel!
    weak var delegate: CategoryViewController?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell",
                                                       for: indexPath) as? CategoryTableViewCell
            else { return UITableViewCell() }
        
        let name = viewModel.categories[indexPath.row].name
        cell.nameLabel.text = name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.row == viewModel.categories.count - 1 || indexPath.row == 0 {
            return nil
        }
        var contextualActions: [UIContextualAction] = []
        
        let title = NSLocalizedString("Delete", comment: "Delete action for cell")
        let action = UIContextualAction(style: .destructive, title: title) { (_, _, completion) in
            self.showDeleteAlert(deleteHandler: { _ in
                self.viewModel.deleteCategory(row: indexPath.row)
                self.delegate?.tableView.deleteRows(at: [indexPath], with: .automatic)
                completion(true)
            }) { _ in
                completion(false)
            }
        }

        contextualActions.append(action)
        
        let swipeActionsConfiguration = UISwipeActionsConfiguration(actions: contextualActions)
        swipeActionsConfiguration.performsFirstActionWithFullSwipe = true
        
        return swipeActionsConfiguration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.performSegue(withIdentifier: "showExpenses", sender: delegate)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func showDeleteAlert(deleteHandler: ((UIAlertAction) -> Void)?, cancelHandler: ((UIAlertAction) -> Void)?) {
        let title = NSLocalizedString("Delete category?", comment: "Delete category alert title")
        let message = NSLocalizedString("This category will be deleted. All expenses from this category will be transferred to Other.", comment: "Delete expense alert message")
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let delete = NSLocalizedString("Delete", comment: "Delete action for category alert")
        let cancel = NSLocalizedString("Cancel", comment: "Cancel action for category alert")
        
        alert.addAction(UIAlertAction(title: delete, style: .destructive, handler: deleteHandler))
        alert.addAction(UIAlertAction(title: cancel, style: .cancel, handler: cancelHandler))
        
        delegate?.present(alert, animated: true)
    }
}
