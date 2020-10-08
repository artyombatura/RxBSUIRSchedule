//
//  JSONToDayListResponseDecoder.swift
//  RxBSUIRSchedule
//
//  Created by Artsiom Batura on 10/8/20.
//

import Foundation
import SwiftyJSON

class JSONToDayListResponseDecoder: JSONResponseDecoder<[Day]> {
    
    private var dayDecoder: JSONToDayResponseDecoder
    
    override init(path: [String]) {
        self.dayDecoder = JSONToDayResponseDecoder()
    
        super.init(path: path)
    }
    
    override func decode(json: JSON) throws -> [Day] {
        
        var days: [Day] = [Day]()
        
        guard
            let jsonArray = json["schedules"].array,
            let currentWeekNumber = json["currentWeekNumber"].int
        else {
            throw APIError.InvalidDecoder
        }
        
        for object in jsonArray {
            do {
                let day = try dayDecoder.decode(json: object)
                day.currentWeekNumber = currentWeekNumber
                days.append(day)
            } catch {
                print("Error")
            }
        }
        
        return days
    }
    
}
