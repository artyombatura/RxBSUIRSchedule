//
//  UIViewController+Extensions.swift
//  RxBSUIRSchedule
//
//  Created by Artyom Batura on 10/7/20.
//

import UIKit

extension UIViewController {
    func showAllert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отмена",
                                         style: .cancel) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancelAction)
        self.present(alert,
                     animated: true,
                     completion: nil)
    }
}
