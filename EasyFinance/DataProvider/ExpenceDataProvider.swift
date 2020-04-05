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
            self.viewModel.deleteExpence(row: indexPath.row)
            completion(true)
        }
        contextualActions.append(action)
        
        let swipeActionsConfiguration = UISwipeActionsConfiguration(actions: contextualActions)
        swipeActionsConfiguration.performsFirstActionWithFullSwipe = true
        
        return swipeActionsConfiguration
    }
}
