//
//  IncomeDataProvider.swift
//  EasyFinance
//
//  Created by Никита Гундорин on 04.04.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation
import UIKit

class IncomeDataProvider: NSObject, UITableViewDataSource, UITableViewDelegate {
    weak var viewModel: IncomeViewModel!
    weak var delegate: IncomeViewController?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.incomes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "incomeCell",
                                                       for: indexPath) as? IncomeTableViewCell
            else { return UITableViewCell() }
        
        let income = viewModel.incomes[indexPath.row]
        cell.valueLabel.text = FormatHelper.getFormattedCurrency(value: income.value)
        cell.dateLabel.text = FormatHelper.getFormattedDate(date: income.date)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var contextualActions: [UIContextualAction] = []
        
        let title = NSLocalizedString("Delete", comment: "Delete action for cell")
        
        let action = UIContextualAction(style: .destructive, title: title) {_,_,completion in
            self.showDeleteAlert(deleteHandler: { _ in
                self.viewModel.deleteIncome(row: indexPath.row)
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
    
    private func showDeleteAlert(deleteHandler: ((UIAlertAction) -> Void)?, cancelHandler: ((UIAlertAction) -> Void)?) {
        let title = NSLocalizedString("Delete income?", comment: "Delete income alert title")
        let message = NSLocalizedString("This income will be deleted. This action cannot be undone.", comment: "Delete income alert message")
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let delete = NSLocalizedString("Delete", comment: "Delete action for expense alert")
        let cancel = NSLocalizedString("Cancel", comment: "Cancel action for expense alert")
        
        alert.addAction(UIAlertAction(title: delete, style: .destructive, handler: deleteHandler))
        alert.addAction(UIAlertAction(title: cancel, style: .cancel, handler: cancelHandler))
        
        delegate?.present(alert, animated: true)
    }
}
