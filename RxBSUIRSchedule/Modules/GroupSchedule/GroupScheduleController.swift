//
//  GroupScheduleController.swift
//  RxBSUIRSchedule
//
//  Created by Artyom Batura on 10/7/20.
//

import UIKit
import RxSwift

class GroupScheduleController: UIViewController, Storyboarded {

    // MARK: - Properties
    
    // MARK: - Rx
    private let disposeBag = DisposeBag()
    
    // MARK: - Subviews
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        APIRequests.getSchedule(814303)
            .do(onSuccess: { (_) in
                DispatchQueue.main.async {
                    self.title = "Данные загружены"
                }
            },
            onError: { (_) in
                DispatchQueue.main.async {
                    self.title = "Ошибка загрузки"
                }
            },
            onSubscribe: {
                DispatchQueue.main.async {
                    self.title = "Идет загрузка"
                }
            })
            .subscribe { (result) in
                print(result)
            } onError: { (error) in
                self.showAllert(title: "Error", message: error.localizedDescription)
            }
            .disposed(by: disposeBag)

    }
    

}
