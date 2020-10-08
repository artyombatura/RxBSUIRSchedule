//
//  JSONToDayResponseDecoder.swift
//  RxBSUIRSchedule
//
//  Created by Artsiom Batura on 10/8/20.
//

import Foundation
import SwiftyJSON

class JSONToDayResponseDecoder: JSONResponseDecoder<Day> {
    
    private var scheduleDecoder: JSONToScheduleResponseDecoder
    
    override init(path: [String]) {
        scheduleDecoder = JSONToScheduleResponseDecoder()
        
        super.init(path: path)
    }
    
    override func decode(json: JSON) throws -> Day {
        
        var schedule: [Schedule] = [Schedule]()
        
        guard
            let weekday = json["weekDay"].string,
            let scheduleArray = json["schedule"].array
        else {
            throw APIError.InvalidDecoder
        }
        
        for sched in scheduleArray {
            do {
                let scheduleObject = try scheduleDecoder.decode(json: sched)
                schedule.append(scheduleObject)
            } catch {
                print("Error")
            }
        }
        
        
        return Day(weekday: weekday, schedule: schedule)
    }
}
