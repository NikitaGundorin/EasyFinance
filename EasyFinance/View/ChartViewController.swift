//
//  ChartViewController.swift
//  EasyFinance
//
//  Created by Никита Гундорин on 06.04.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UIViewController, ChartDelegate {
    @IBOutlet private weak var chart: LineChartView!
    @IBOutlet private weak var legend: UIStackView!
    @IBOutlet private weak var periodButtons: PeriodButtons!
    
    var viewModel: ChartViewModelProtocol = ChartViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.period = .week
        periodButtons.delegate = self
        
        ChartHelper.setupChart(chart: chart)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setChart()
    }
    
    func setChart() {
        guard let incomes = viewModel.incomes,
            incomes.count + viewModel.expenses.count > 0 else {
            chart.data = nil
            legend.isHidden = true
            return
        }
        
        legend.isHidden = false
        var incomeEntries = [ChartDataEntry]()
        for income in incomes {
            let incomeEntry = ChartDataEntry(x: Double(income.date.removeTimeStamp().timeIntervalSince1970), y: Double(income.value))
            if incomeEntry.x == incomeEntries.last?.x {
                incomeEntries.last?.y += incomeEntry.y
                continue
            }
            incomeEntries.append(incomeEntry)
        }
        
        let incomesChartDataSet = LineChartDataSet(entries: incomeEntries, label: "")
        incomesChartDataSet.colors = [UIColor.systemGreen]
        incomesChartDataSet.circleColors = [UIColor.systemGray]
        incomesChartDataSet.circleHoleColor = UIColor.systemGray3
        incomesChartDataSet.drawValuesEnabled = false
        
        var expenseEntries = [ChartDataEntry]()
        for expense in viewModel.expenses {
            let expenseEntry = ChartDataEntry(x: Double(expense.date.removeTimeStamp().timeIntervalSince1970), y: Double(expense.value))
            if expenseEntry.x == expenseEntries.last?.x {
                expenseEntries.last?.y += expenseEntry.y
                continue
            }
            expenseEntries.append(expenseEntry)
        }
        
        let expenseChartDataSet = LineChartDataSet(entries: expenseEntries, label: "")
        expenseChartDataSet.colors = [UIColor.systemRed]
        expenseChartDataSet.circleColors = [UIColor.systemGray]
        expenseChartDataSet.circleHoleColor = UIColor.systemGray3
        expenseChartDataSet.drawValuesEnabled = false
        
        let chartData = LineChartData(dataSets: [incomesChartDataSet, expenseChartDataSet])
        chart.data = chartData
        
        switch viewModel.period {
        case .week:
            chart.xAxis.setLabelCount(viewModel.interval.end.weekDay(), force: true)
            chart.xAxis.axisMaximum = viewModel.interval.end.removeTimeStamp().timeIntervalSince1970
        default:
            let number = [incomeEntries.count, expenseEntries.count].max() ?? 6
            chart.xAxis.setLabelCount(number, force: false)
            chart.xAxis.resetCustomAxisMax()
        }
    }
}
