//
//  PeriodButtons.swift
//  EasyFinance
//
//  Created by Никита Гундорин on 08.04.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class PeriodButtons: UIView {
    @IBOutlet weak var weekButton: UIButton!
    @IBOutlet weak var weekButtonUnderline: UIView!
    @IBOutlet weak var monthButton: UIButton!
    @IBOutlet weak var monthButtonUnderline: UIView!
    @IBOutlet weak var quarterButton: UIButton!
    @IBOutlet weak var quarterButtonUnderline: UIView!
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var allButtonUnderline: UIView!

    weak var delegate: ChartDelegate?
    
    let nibName = "PeriodButtons"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        setBorderFor(button: weekButton, underline: weekButtonUnderline)
    }
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
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
        delegate?.viewModel.period = .week
        setBorderFor(button: weekButton, underline: weekButtonUnderline)
        delegate?.setChart()
    }
    
    @IBAction func monthSelected(_ sender: Any) {
        delegate?.viewModel.period = .month
        setBorderFor(button: monthButton, underline: monthButtonUnderline)
        delegate?.setChart()
    }
    
    @IBAction func quarterSelected(_ sender: Any) {
        delegate?.viewModel.period = .quarter
        setBorderFor(button: quarterButton, underline: quarterButtonUnderline)
        delegate?.setChart()
    }
    
    @IBAction func allSelected(_ sender: Any) {
        delegate?.viewModel.period = .all
        setBorderFor(button: allButton, underline: allButtonUnderline)
        delegate?.setChart()
        
    }
}

protocol ChartDelegate: class {
    var viewModel: ChartViewModelProtocol { get set }
    func setChart()
}
