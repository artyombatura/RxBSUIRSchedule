//
//  Schedule.swift
//  RxBSUIRSchedule
//
//  Created by Artsiom Batura on 10/8/20.
//

import Foundation
import SwiftyJSON

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
    
    init(withJSON json: JSON) throws {
        guard
            let weekNumber = json["weekNumber"].arrayObject,
            let studentGroup = json["studentGroup"].arrayObject,
            let numSubgroup = json["numSubgroup"].int,
            let auditory = json["auditory"].arrayObject,
            let lessonTime = json["lessonTime"].string,
            let startLessonTime = json["startLessonTime"].string,
            let endLessonTime = json["endLessonTime"].string,
            let subject = json["subject"].string,
            /*let note = json["note"].string,*/
            let lessonTypeString = json["lessonType"].string,
            /*let employeeJSON = json["employee"].array,*/
            let zaoch = json["zaoch"].bool
        else { throw APIError.BuildJSONFailure }
        
        if let employeeJSON = json["employee"].array {
            if employeeJSON.count > 0 {
                do {
                    employee = try Employee(withJSON: employeeJSON.first!)
                } catch {
                    throw error
                }
            }
        }
        
        let weekNumberInt = weekNumber.map { $0 as! Int }
        guard
            let studentGroupObject = (studentGroup.first) as? String
        else {
            throw APIError.InvalidDecoder
        }
        
        var auditoryObject: String?
        if let aud = auditory.first {
            auditoryObject = aud as? String
        }
        
        // INIT
        self.weekNumber = weekNumberInt
        self.studentGroup = studentGroupObject
        self.numSubgroup = numSubgroup
        self.auditory = auditoryObject
        self.lessonTime = lessonTime
        self.startLessonTime = startLessonTime
        self.endLessonTime = endLessonTime
        self.subject = subject
        self.note = ""
        self.lessonType = LessonType(rawValue: lessonTypeString) ?? .pz
        self.zaoch = zaoch
    }
}
