//
//  ApiConfigurations.swift
//  RxBSUIRSchedule
//
//  Created by Artyom Batura on 10/7/20.
//

import Foundation

public class APIConfigurations {
    public static let baseApiURL: String = "https://journal.bsuir.by/api/v1/"
    
    enum APIEndPoints: String {
        case schedule = "/studentGroup/schedule"
    }
}

enum APIError: Error {
    case buildURLFailure
}
