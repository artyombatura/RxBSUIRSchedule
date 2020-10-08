//
//  Day.swift
//  RxBSUIRSchedule
//
//  Created by Artsiom Batura on 10/8/20.
//

import Foundation
import RxDataSources

class Day {
    public var weekDay: String?
    public var schedule: [Schedule]?
    public var currentWeekNumber: Int?
    
    public var scheduleForCurrentWeek: [Schedule] {
        getScheduleForCurrentWeek() ?? [Schedule]()
    }
    
    init(weekday: String, schedule: [Schedule]) {
        self.weekDay = weekday
        self.schedule = schedule
    }
}

// MARK: - Day schedule filtering by currentDay
extension Day {
    private func getScheduleForCurrentWeek() -> [Schedule]? {
        guard
            let schedule = self.schedule,
            let currentWeekNumber = self.currentWeekNumber
        else { return nil }
        
        var tempSchedule: [Schedule] = [Schedule]()
        schedule.forEach { (schedule) in
            guard
                let weeksNumber = schedule.weekNumber
            else { return }
            if weeksNumber.contains(currentWeekNumber) {
                schedule.weekNumber = [currentWeekNumber]
                tempSchedule.append(schedule)
            }
        }
        return tempSchedule
    }
}
