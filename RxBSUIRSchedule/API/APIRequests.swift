//
//  APIRequests.swift
//  RxBSUIRSchedule
//
//  Created by Artyom Batura on 10/7/20.
//

import Foundation
import UIKit
import RxSwift

class APIRequests {
    public static func getSchedule(_ forGroupNumber: Int) -> Single<[String: Any]> {
        return Single<[String: Any]>.create { (single) -> Disposable in

            do {
                var urlComponents = URLComponents(string: APIConfigurations.baseApiURL.appending(APIConfigurations.APIEndPoints.schedule.rawValue))
                let queryItem = URLQueryItem(name: "studentGroup",
                                             value: String(forGroupNumber))
                
                urlComponents?.queryItems = [queryItem]
                
                guard
                    let finalURL = urlComponents?.url
                else {
                    throw APIError.buildURLFailure
                }
                
                let request = URLRequest(url: finalURL)
                
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        single(.error(error))
                        return
                    }
                    
                    guard
                        let data = data,
                        let json: Any = try? JSONSerialization.jsonObject(with: data,
                                                                options: .mutableLeaves),
                        let result = json as? [String: Any]
                    else {
                        return
                    }
                    
                    single(.success(result))
                }
                
                task.resume()
                
            } catch {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
}
