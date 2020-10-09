//
//  Day.swift
//  RxBSUIRSchedule
//
//  Created by Artsiom Batura on 10/8/20.
//

import Foundation
import RxDataSources
import SwiftyJSON

class Day: NSCopying {
    public var weekDay: String?
    public var schedule: [Schedule]?
    public var currentWeekNumber: Int?

    init(weekday: String, schedule: [Schedule]) {
        self.weekDay = weekday
        self.schedule = schedule
    }
    
    init(fromJSON json: JSON) throws {
        guard
            let weekday = json["weekDay"].string,
            let scheduleArray = json["schedule"].array
        else {
            throw APIError.BuildJSONFailure
        }
        
        var schedules: [Schedule] = [Schedule]()
        for sched in scheduleArray {
            do {
                let scheduleObject = try Schedule(withJSON: sched)
                schedules.append(scheduleObject)
            } catch {
                throw APIError.BuildJSONFailure
            }
        }
        self.schedule = schedules
        self.weekDay = weekday
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Day(weekday: self.weekDay!, schedule: self.schedule!)
        return copy
    }
}

// MARK: - Day schedule filtering by currentDay
extension Day {
    public func getSchedule(forWeekNumber week: Int) -> Day {
        guard
            let schedule = self.schedule,
            let day = self.copy(with: nil) as? Day
        else { return self }
        
        day.schedule = [Schedule]()
        schedule.forEach { (schedule) in
            guard
                let weeksNumber = schedule.weekNumber
            else { return }
            if weeksNumber.contains(week) || weeksNumber.contains(0) {
                day.schedule?.append(schedule)
            }
        }
        
        return day
    }
}

// MARK: - Array of days from JSON
extension Day {
    public static func buildDaysArray(fromJSON json: JSON) throws -> [Day] {
        guard
            let schedulesArray = json["schedules"].array,
            let currentWeekNumber = json["currentWeekNumber"].int
        else {
            throw APIError.BuildJSONFailure
        }
        
        var days: [Day] = [Day]()
        for schedule in schedulesArray {
            do {
                let day = try Day(fromJSON: schedule)
                day.currentWeekNumber = currentWeekNumber
                
                days.append(day)
            } catch {
                throw APIError.BuildJSONFailure
            }
        }
        
        return days
    }
}
