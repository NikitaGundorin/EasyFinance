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
        var contextualActions: [UIContextualAction] = []
        
        let action = UIContextualAction(style: .destructive, title: "Удалить") { (_, _, completion) in
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
    
    func showDeleteAlert(deleteHandler: ((UIAlertAction) -> Void)?, cancelHandler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: "Удалить категорию?", message: "Вы уверены, что хотите удалить категорию? Все расходы из этой категории будут перенесены в Прочее", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: deleteHandler))
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: cancelHandler))

        delegate?.present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.performSegue(withIdentifier: "showExpences", sender: delegate)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
