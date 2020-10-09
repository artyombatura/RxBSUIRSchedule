//
//  WeeksView.swift
//  RxBSUIRSchedule
//
//  Created by Artsiom Batura on 10/9/20.
//

import UIKit
import RxSwift

final class WeeksView: UIView {
    
    // MARK: - Subviews
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var firstWeekButton: UIButton!
    @IBOutlet weak var secondWeekButton: UIButton!
    @IBOutlet weak var thirdWeekButton: UIButton!
    @IBOutlet weak var fourthWeekButton: UIButton!
    @IBOutlet weak var allWeeksButton: UIButton!
    @IBOutlet weak var weekLabel: UILabel!
    
    // MARK: - Rx properties
    let disposeBag = DisposeBag()
    
    // MARK: - ViewModel
    public let viewModel = WeeksViewModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        
        bind()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("WeeksView",
                                 owner: self,
                                 options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask =
            [.flexibleHeight, .flexibleWidth]
    }
}

// MARK: - Bind
extension WeeksView {
    private func bind() {
        bindInputs()
        bindOutputs()
    }
    
    private func bindInputs() {
        viewModel.output.weekChange
            .asObservable()
            .subscribe(onNext: { [weak self] weekNumber in
                switch weekNumber {
                case .First:
                    self?.weekLabel.text = "Неделя 1"
                case .Second:
                    self?.weekLabel.text = "Неделя 2"
                case .Third:
                    self?.weekLabel.text = "Неделя 3"
                case .Fourth:
                    self?.weekLabel.text = "Неделя 4"
                case .All:
                    self?.weekLabel.text = "Все недели"
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOutputs() {
        firstWeekButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.input.weekNumber.accept(.First)
            })
            .disposed(by: disposeBag)
        
        secondWeekButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.input.weekNumber.accept(.Second)
            })
            .disposed(by: disposeBag)
        
        thirdWeekButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.input.weekNumber.accept(.Third)
            })
            .disposed(by: disposeBag)
        
        fourthWeekButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.input.weekNumber.accept(.Fourth)
            })
            .disposed(by: disposeBag)
        
        allWeeksButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.input.weekNumber.accept(.All)
            })
            .disposed(by: disposeBag)
    }
}
