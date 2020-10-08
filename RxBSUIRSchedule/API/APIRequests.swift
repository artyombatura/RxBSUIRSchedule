//
//  APIRequests.swift
//  RxBSUIRSchedule
//
//  Created by Artyom Batura on 10/7/20.
//

import Foundation
import UIKit
import RxSwift
import SwiftyJSON

class APIRequests {
    public static func getSchedule(_ forGroupNumber: Int) -> Single<[Day]> {
        return Single<[Day]>.create { (single) -> Disposable in
            do {
                var urlComponents = URLComponents(string: APIConfigurations.baseApiURL.appending(APIConfigurations.APIEndPoints.schedule.rawValue))
                let queryItem = URLQueryItem(name: "studentGroup",
                                             value: String(forGroupNumber))
                urlComponents?.queryItems = [queryItem]
                if let finalURL = urlComponents?.url {
                    let request = URLRequest(url: finalURL)
                    
                    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                        if let error = error {
                            single(.error(error))
                            return
                        }
                        
                        if let data = data {
                            if let json = try? JSON(data: data) {
                                let decoder = JSONToDayListResponseDecoder()
                                if let model = try? decoder.decode(json: json) {
                                    single(.success(model))
                                } else {
                                    single(.error(APIError.BuildModelFailure))
                                }
                            } else {
                                single(.error(APIError.BuildJSONFailure))
                            }
                        } else {
                            single(.error(APIError.NotFound))
                        }
                    }
                    
                    task.resume()
                } else {
                    single(.error(APIError.buildURLFailure))
                }
                
            }
            
            return Disposables.create()
        }
    }
}
