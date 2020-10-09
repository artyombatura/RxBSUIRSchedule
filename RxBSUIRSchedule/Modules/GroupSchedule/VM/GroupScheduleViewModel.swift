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
        let weekNumber: BehaviorRelay<Int> = BehaviorRelay<Int>(value: 0)
    }
    
    struct Output {
        let groupSchedule: Driver<[Day]>
        let loadingState: Driver<LoadingState>
        let networkError: Signal<Error>
        let onWeekChange: Driver<Int>
    }
    
    let input = Input()
    let output: Output
    
    private let schedule = BehaviorRelay<[Day]>(value: [])
    private let filteredSchedule = BehaviorRelay<[Day]>(value: [])
    public var scheduleItems: [Day] = [Day]()
    private let loadingState: PublishRelay<LoadingState> = PublishRelay<LoadingState>()
    private let networkFetchResult: PublishRelay<Error> = PublishRelay<Error>()
    
    let disposeBag = DisposeBag()
    
    init() {
        output = Output(groupSchedule: filteredSchedule.asDriver(),
                        loadingState: loadingState.asDriver(onErrorJustReturn: .None),
                        networkError: networkFetchResult.asSignal(),
                        onWeekChange: input.weekNumber.asDriver())
        
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
                        } onError: { [weak self] (error) in
                            self?.loadingState.accept(.None)
                            self?.networkFetchResult.accept(error)
                        } onSubscribe: { [weak self] in
                            self?.loadingState.accept(.Loading)
                        }
                        .catchError({ (error) -> Single<[Day]> in
                            .just([])
                        })
                }
                return .just([])
            }
            .bind(to: schedule)
            .disposed(by: disposeBag)

        // Filter schedule
        Observable<[Day]>
            .combineLatest(schedule, input.weekNumber) { (schedule, weekNumber) -> [Day] in
                if weekNumber == 0 { return schedule }
                else {
                    return schedule.map { (day) -> Day in
                        day.getSchedule(forWeekNumber: weekNumber)
                    }
                }
            }
            .do(onNext: { [weak self] (schedule) in
                self?.scheduleItems = schedule
            })
            .bind(to: self.filteredSchedule)
            .disposed(by: disposeBag)
    }
}
