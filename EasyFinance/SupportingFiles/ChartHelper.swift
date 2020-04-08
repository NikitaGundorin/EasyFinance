//
//  ChartHelper.swift
//  EasyFinance
//
//  Created by Никита Гундорин on 08.04.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation
import Charts

class ChartHelper: IAxisValueFormatter {
    static func setupChart(chart: LineChartView) {
        chart.xAxis.labelPosition = .bottom
        chart.xAxis.valueFormatter = ChartHelper()
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
    
    static func setBorderFor(button: UIButton, underline: UIView, buttons: [UIButton], underlines: [UIView]) {
        for btn in buttons {
            if (btn == button) {
                btn.layer.borderWidth = 1
                btn.layer.borderColor = UIColor.systemGray.cgColor
                btn.layer.cornerRadius = 2
                continue
            }
            btn.layer.borderWidth = 0
        }
        
        for line in underlines {
            if (line == underline) {
                line.isHidden = true
                continue
            }
            line.isHidden = false
        }
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        FormatHelper.getShortFormattedDate(date: Date(timeIntervalSince1970: value))
    }
}
