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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.incomes.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "incomeCell",
                                                       for: indexPath) as? IncomeTableViewCell
            else { return UITableViewCell() }
        
        let value = viewModel.incomes[indexPath.row].value
        cell.valueLabel.text = FormatHelper.formatCurrency(value: value)
        
        return cell
    }
}