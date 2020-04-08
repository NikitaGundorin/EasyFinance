//
//  CategoryChartViewController.swift
//  EasyFinance
//
//  Created by Никита Гундорин on 08.04.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit
import Charts

class CategoryChartViewController: UIViewController, ChartDelegate {
    @IBOutlet weak var chart: LineChartView!
    @IBOutlet weak var periodButtons: PeriodButtons!
    
    var viewModel: ChartViewModelProtocol = CategoryChartViewModel()
    var category: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.category = category
        viewModel.period = .week
        periodButtons.delegate = self
        
        ChartHelper.setupChart(chart: chart)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setChart()
    }
    
    func setChart() {
        guard viewModel.expenses.count > 0 else {
            chart.data = nil
            return
        }

        var expenseEntries = [ChartDataEntry]()
        for expense in viewModel.expenses {
            let expenseEntry = ChartDataEntry(x: Double(expense.date.removeTimeStamp().timeIntervalSince1970), y: Double(expense.value))
            if expenseEntry.x == expenseEntries.last?.x {
                expenseEntries.last?.y += expenseEntry.y
                continue
            }
            expenseEntries.append(expenseEntry)
        }
        
        let expenseChartDataSet = LineChartDataSet(entries: expenseEntries, label: "Расходы")
        expenseChartDataSet.colors = [UIColor.systemRed]
        expenseChartDataSet.circleColors = [UIColor.systemGray]
        expenseChartDataSet.circleHoleColor = UIColor.systemGray3
        expenseChartDataSet.drawValuesEnabled = false
        
        let chartData = LineChartData(dataSets: [expenseChartDataSet])
        chart.data = chartData
        
        switch viewModel.period {
        case .week:
            chart.xAxis.setLabelCount(viewModel.interval.end.weekDay(), force: true)
            chart.xAxis.axisMaximum = viewModel.interval.end.removeTimeStamp().timeIntervalSince1970
        default:
            chart.xAxis.setLabelCount(expenseEntries.count, force: false)
            chart.xAxis.resetCustomAxisMax()
        }
    }
}
