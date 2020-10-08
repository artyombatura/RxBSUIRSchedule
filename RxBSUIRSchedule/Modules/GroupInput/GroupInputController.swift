//
//  GroupInputController.swift
//  RxBSUIRSchedule
//
//  Created by Artyom Batura on 10/7/20.
//

import UIKit
import RxSwift
import RxCocoa

class GroupInputController: UIViewController, Storyboarded {
    
    // MARK: - Properties
    private var groupNumber: Int = 0
    
    // MARK: - Rx
    private let disposeBag = DisposeBag()
    private let canGoNext = BehaviorSubject<Bool>(value: false)
    
    // MARK: - Subviews
    @IBOutlet weak var groupInputTextField: UITextField!
    private var nextButton: UIBarButtonItem!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI
        configNavigationBar()
        title = "Расписание БГУИР"
        
        // Rx subscriptions
        subscribeOnGroupTextField()
        subscribeOnCanGoNext()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.showAllert(title: "Тестовая группа", message: "814303")
    }
}

// MARK: - Methods/Actions
extension GroupInputController {
    @objc
    private func goNextScreen() {
        let scheduleController = GroupScheduleController.storyboardInstance()
        scheduleController.groupNumber.onNext(self.groupNumber)
        self.navigationController?.pushViewController(scheduleController,
                                                      animated: true)
    }
}

// MARK: - Rx subscriptions
extension GroupInputController {
    private func subscribeOnGroupTextField() {
        groupInputTextField.rx.controlEvent([.editingChanged])
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard
                    let text = self?.groupInputTextField.text
                else { return }
        
                let flag = !text.isEmpty
                
                guard
                    let groupNumber = Int(text)
                else {
                    self?.canGoNext.onNext(false)
                    return
                }
                
                self?.groupNumber = groupNumber
                self?.canGoNext.onNext(flag)
            })
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnCanGoNext() {
        canGoNext
            .subscribe(onNext: { [weak self] flag in
                self?.nextButton.isEnabled = flag
            })
            .disposed(by: disposeBag)
    }
}


// MARK: - Config navigationBar
extension GroupInputController {
    private func configNavigationBar() {
        nextButton = UIBarButtonItem(title: "Далее",
                                     style: .done,
                                     target: self,
                                     action: #selector(goNextScreen))
        self.navigationItem.rightBarButtonItem = nextButton
    }
}
