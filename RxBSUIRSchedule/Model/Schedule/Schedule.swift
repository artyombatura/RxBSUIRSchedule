//
//  Schedule.swift
//  RxBSUIRSchedule
//
//  Created by Artsiom Batura on 10/8/20.
//

import Foundation

enum LessonType: String {
    case lk = "ЛК"
    case pz = "ПЗ"
    case lr = "ЛР"
}

class Schedule {
    
    public var weekNumber: [Int]?
    public var studentGroup: String?
    public var numSubgroup: Int?
    public var auditory: String?
    public var lessonTime: String?
    public var startLessonTime: String?
    public var endLessonTime: String?
    public var subject: String?
    public var note: String?
    public var lessonType: LessonType?
    public var employee: Employee?
    public var zaoch: Bool?
    
    init(weekNumber: [Int], studentGroup: String, numSubgroup: Int, auditory: String?, lessonTime: String,
         startLessonTime: String, endLessonTime: String, subject: String, note: String, lessonType: LessonType,
         employee: Employee?, zaoch: Bool) {
        self.weekNumber = weekNumber
        self.studentGroup = studentGroup
        self.numSubgroup = numSubgroup
        self.auditory = auditory
        self.lessonTime = lessonTime
        self.startLessonTime = startLessonTime
        self.endLessonTime = endLessonTime
        self.subject = subject
        self.note = note
        self.lessonType = lessonType
        self.employee = employee
        self.zaoch = zaoch
    }
    
}
