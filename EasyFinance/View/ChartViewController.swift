//
//  ChartViewController.swift
//  EasyFinance
//
//  Created by Никита Гундорин on 06.04.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UIViewController {
    
    
    @IBOutlet weak var chart: LineChartView!
    @IBOutlet weak var legend: UIStackView!
    @IBOutlet weak var weekButton: UIButton!
    @IBOutlet weak var weekButtonUnderline: UIView!
    @IBOutlet weak var monthButton: UIButton!
    @IBOutlet weak var monthButtonUnderline: UIView!
    @IBOutlet weak var quarterButton: UIButton!
    @IBOutlet weak var quarterButtonUnderline: UIView!
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var allButtonUnderline: UIView!
    
    
    var viewModel = ChartViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chart.xAxis.labelPosition = .bottom
        chart.xAxis.valueFormatter = viewModel
        chart.xAxis.labelFont = UIFont.systemFont(ofSize: 12, weight: .black)
        chart.leftAxis.labelFont = UIFont.systemFont(ofSize: 9, weight: .black)
        chart.rightAxis.enabled = false
        chart.highlighter = nil
        chart.scaleXEnabled = false
        chart.scaleYEnabled = false
        chart.pinchZoomEnabled = false
        chart.doubleTapToZoomEnabled = false
        chart.legend.enabled = false
        chart.noDataText = "Нет данных за выбранный период"
        chart.extraRightOffset = 30
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.period = .week
        
        setChart()
        setBorderFor(button: weekButton, underline: weekButtonUnderline)
    }
    
    func setChart() {
        guard viewModel.incomes.count + viewModel.expences.count > 0 else {
            chart.data = nil
            legend.isHidden = true
            return
        }
        
        legend.isHidden = false
        var incomeEntries = [ChartDataEntry]()
        for income in viewModel.incomes {
            let incomeEntry = ChartDataEntry(x: Double(income.date.removeTimeStamp().timeIntervalSince1970), y: Double(income.value))
            if incomeEntry.x == incomeEntries.last?.x {
                incomeEntries.last?.y += incomeEntry.y
                continue
            }
            incomeEntries.append(incomeEntry)
        }
        
        let incomesChartDataSet = LineChartDataSet(entries: incomeEntries, label: "Доходы")
        incomesChartDataSet.colors = [UIColor.systemGreen]
        incomesChartDataSet.circleColors = [UIColor.systemGray]
        incomesChartDataSet.circleHoleColor = UIColor.systemGray3
        incomesChartDataSet.drawValuesEnabled = false
        
        var expenceEntries = [ChartDataEntry]()
        for expence in viewModel.expences {
            let expenceEntry = ChartDataEntry(x: Double(expence.date.removeTimeStamp().timeIntervalSince1970), y: Double(expence.value))
            if expenceEntry.x == expenceEntries.last?.x {
                expenceEntries.last?.y += expenceEntry.y
                continue
            }
            expenceEntries.append(expenceEntry)
        }
        
        let expenceChartDataSet = LineChartDataSet(entries: expenceEntries, label: "Расходы")
        expenceChartDataSet.colors = [UIColor.systemRed]
        expenceChartDataSet.circleColors = [UIColor.systemGray]
        expenceChartDataSet.circleHoleColor = UIColor.systemGray3
        expenceChartDataSet.drawValuesEnabled = false
        
        let chartData = LineChartData(dataSets: [incomesChartDataSet, expenceChartDataSet])
        chart.data = chartData
        
        switch viewModel.period {
        case .week:
            chart.xAxis.setLabelCount(viewModel.interval.end.weekDay(), force: true)
            chart.xAxis.axisMaximum = viewModel.interval.end.removeTimeStamp().timeIntervalSince1970
        default:
            chart.xAxis.setLabelCount([incomeEntries.count, expenceEntries.count].max() ?? 6, force: false)
            chart.xAxis.resetCustomAxisMax()
        }
    }
    
    func setBorderFor(button: UIButton, underline: UIView) {
        for btn in [weekButton, monthButton, quarterButton, allButton] {
            if (btn == button) {
                btn?.layer.borderWidth = 1
                btn?.layer.borderColor = UIColor.systemGray.cgColor
                btn?.layer.cornerRadius = 2
                continue
            }
            btn?.layer.borderWidth = 0
        }
        
        for line in [weekButtonUnderline, monthButtonUnderline, quarterButtonUnderline, allButtonUnderline] {
            if (line == underline) {
                line?.isHidden = true
                continue
            }
            line?.isHidden = false
        }
    }
    
    @IBAction func weekSelected(_ sender: Any) {
        viewModel.period = .week
        setBorderFor(button: weekButton, underline: weekButtonUnderline)
        setChart()
    }
    
    @IBAction func monthSelected(_ sender: Any) {
        viewModel.period = .month
        setBorderFor(button: monthButton, underline: monthButtonUnderline)
        setChart()
    }
    
    @IBAction func quarterSelected(_ sender: Any) {
        viewModel.period = .quarter
        setBorderFor(button: quarterButton, underline: quarterButtonUnderline)
        setChart()
    }
    
    @IBAction func allSelected(_ sender: Any) {
        viewModel.period = .all
        setBorderFor(button: allButton, underline: allButtonUnderline)
        setChart()
    }
}
