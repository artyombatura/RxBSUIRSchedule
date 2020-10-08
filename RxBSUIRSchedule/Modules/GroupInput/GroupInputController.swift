//
//  GroupInputController.swift
//  RxBSUIRSchedule
//
//  Created by Artyom Batura on 10/7/20.
//

import UIKit
import RxSwift

class GroupInputController: UIViewController, Storyboarded {
    
    // MARK: - Properties
    @IBOutlet weak var groupInputTextField: UITextField!
    
    // MARK: - Rx
    private let disposeBag = DisposeBag()
    private let isNextAllowed = PublishSubject<Bool>()
    private let groupNumber = BehaviorSubject<Int>(value: 0)
    
    // MARK: - Subviews

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Observables subscriptions
        subscribeOnNextAllowed()
        
        // UI
        configNavigationBar()
        title = "Расписание БГУИР"
    }
}

// MARK: - Methods/Actions
extension GroupInputController {
    @objc
    private func goNextScreen() {
        guard
            let text = groupInputTextField.text
        else {
            isNextAllowed.onNext(false)
            return
        }
        
        if text.isEmpty {
            isNextAllowed.onNext(false)
        } else {
            guard
                let groupNumber = Int(text)
            else {
                isNextAllowed.onNext(false)
                return
            }
            
            isNextAllowed.onNext(true)
            self.groupNumber.onNext(groupNumber)
        }
    }
}

// MARK: - Rx subscriptions
extension GroupInputController {
    private func subscribeOnNextAllowed() {
        isNextAllowed
            .subscribe(onNext: { [weak self] (flag) in
                if flag {
                    let scheduleController = GroupScheduleController.storyboardInstance()
                    self?.navigationController?.pushViewController(scheduleController,
                                                                   animated: true)
                } else {
                    self?.showAllert(title: "Номер группы не заполнен",
                                    message: "Введите номер группы и попробуйте снова")
                }
            })
            .disposed(by: disposeBag)
    }
}


// MARK: - Config navigationBar
extension GroupInputController {
    private func configNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Далее",
                                                                 style: .done,
                                                                 target: self,
                                                                 action: #selector(goNextScreen))
    }
}
