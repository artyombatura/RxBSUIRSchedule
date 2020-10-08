//
//  GroupScheduleViewModel.swift
//  RxBSUIRSchedule
//
//  Created by Artsiom Batura on 10/8/20.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxRelay

final class GroupScheduleViewModel {
    enum LoadingState {
        case None
        case Loading
    }
    
    struct Input {
        let groupNumber: PublishRelay<String> = PublishRelay<String>()
        let find: PublishRelay<Void> = PublishRelay<Void>()
    }
    
    struct Output {
        let groupSchedule: Driver<[Day]>
        let loadingState: Driver<LoadingState>
    }
    
    let input = Input()
    let output: Output
    
    private let schedule = BehaviorRelay<[Day]>(value: [])
    public var scheduleItems: [Day] = [Day]()
    private let loadingState: PublishRelay<LoadingState> = PublishRelay<LoadingState>()
    
    let disposeBag = DisposeBag()
    
    init() {
        output = Output(groupSchedule: schedule.asDriver(),
                        loadingState: loadingState.asDriver(onErrorJustReturn: .None))
        
        self.bind()
    }
    
    // MARK: - Bind
    private func bind() {
        input.find
            .withLatestFrom(input.groupNumber) { (_, groupNumber) -> String in
                return groupNumber
            }
            .flatMap { (groupNumberString) -> Single<[Day]> in
                
                
                if let groupNumber = Int(groupNumberString) {
                    return APIRequests.getSchedule(groupNumber)
                        .do { [weak self] days in
                            self?.scheduleItems = days
                            self?.loadingState.accept(.None)
                        } onError: { [weak self] (_) in
                            self?.loadingState.accept(.None)
                        } onSubscribe: { [weak self] in
                            self?.loadingState.accept(.Loading)
                        }
                }
                return Observable.of([Day]()).asSingle()
            }
            .bind(to: schedule)
            .disposed(by: disposeBag)
    }
}
