//
//  IncomeViewController.swift
//  EasyFinance
//
//  Created by Никита Гундорин on 04.04.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class IncomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var dataProvider: IncomeDataProvider!
    @IBOutlet weak var balance: UILabel!
    var viewModel: IncomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = IncomeViewModel()
        dataProvider.viewModel = viewModel
        balance.text = viewModel.balance
    }

}
