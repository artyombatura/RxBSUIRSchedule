//
//  StoryboardedProtocol.swift
//  RxBSUIRSchedule
//
//  Created by Artyom Batura on 10/7/20.
//

import UIKit

protocol Storyboarded {
    static func storyboardInstance() -> Self
}

extension Storyboarded where Self: UIViewController {
    static func storyboardInstance() -> Self {
        let name = String(describing: self)
        let storyboard = UIStoryboard(name: name, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: name) as! Self
    }
}
