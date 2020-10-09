//
//  WeeksViewModel.swift
//  RxBSUIRSchedule
//
//  Created by Artsiom Batura on 10/9/20.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

enum WeekNumber: Int {
    case All = 0
    case First = 1
    case Second = 2
    case Third = 3
    case Fourth = 4
}

class WeeksViewModel {
    
    struct Input {
        let weekNumber: BehaviorRelay<WeekNumber> = BehaviorRelay<WeekNumber>(value: .All)
    }
    
    struct Output {
        let weekChange: Driver<WeekNumber>
    }
    
    let input = Input()
    let output: Output
    
    init() {
        output = Output(weekChange: input.weekNumber.asDriver())
    }
    
    // Methods and bindings
    
}
