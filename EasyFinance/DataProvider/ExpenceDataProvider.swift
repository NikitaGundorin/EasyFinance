//
//  ExpenceDataProvider.swift
//  EasyFinance
//
//  Created by Никита Гундорин on 05.04.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation
import UIKit

class ExpenceDataProvider: NSObject, UITableViewDataSource, UITableViewDelegate {
    weak var viewModel: ExpenceViewModel!
    weak var delegate: ExpenceViewController?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.expences.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "expenceCell",
                                                       for: indexPath) as? ExpenceTableViewCell
            else { return UITableViewCell() }
        
        let expence = viewModel.expences[indexPath.row]
        let value = expence.value
        let name = expence.name
        let date = expence.date
        cell.valueLabel.text = FormatHelper.getFormattedCurrency(value: value)
        cell.namelabel.text = name
        cell.dataLabel.text = FormatHelper.getFormattedDate(date: date)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var contextualActions: [UIContextualAction] = []
        
        let action = UIContextualAction(style: .destructive, title: "Удалить") {_,_,completion in
            self.showDeleteAlert(deleteHandler: { _ in
                self.viewModel.deleteExpence(row: indexPath.row)
                self.delegate?.tableView.deleteRows(at: [indexPath], with: .automatic)
                completion(true)
            }, cancelHandler: { _ in
                completion(false)
            })
        }
        contextualActions.append(action)
        
        let swipeActionsConfiguration = UISwipeActionsConfiguration(actions: contextualActions)
        swipeActionsConfiguration.performsFirstActionWithFullSwipe = true
        
        return swipeActionsConfiguration
    }
    
    func showDeleteAlert(deleteHandler: ((UIAlertAction) -> Void)?, cancelHandler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: "Удалить расход?", message: "Вы уверены, что хотите удалить расход? Это действие необратимо", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: deleteHandler))
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: cancelHandler))

        delegate?.present(alert, animated: true)
    }
}
