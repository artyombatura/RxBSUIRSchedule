//
//  JSONToScheduleResponseDecoder.swift
//  RxBSUIRSchedule
//
//  Created by Artsiom Batura on 10/8/20.
//

import Foundation
import SwiftyJSON

class JSONToScheduleResponseDecoder: JSONResponseDecoder<Schedule> {
    
    private var employeeDecoder: JSONToEmployeeResponseDecoder
    
    override init(path: [String]) {
        employeeDecoder = JSONToEmployeeResponseDecoder()
        
        super.init(path: path)
    }
    
    override func decode(json: JSON) throws -> Schedule {
        
        var employee: Employee?
        
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
        else {
            throw APIError.InvalidDecoder
        }
        
        if let employeeJSON = json["employee"].array {
            if employeeJSON.count > 0 {
                do {
                    employee = try employeeDecoder.decode(json: employeeJSON.first!)
                } catch {
                    print("Error")
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
        
        return Schedule(weekNumber: weekNumberInt, studentGroup: studentGroupObject, numSubgroup: numSubgroup, auditory: auditoryObject,
                        lessonTime: lessonTime, startLessonTime: startLessonTime, endLessonTime: endLessonTime, subject: subject,
                        note: "", lessonType: LessonType(rawValue: lessonTypeString) ?? .pz, employee: employee, zaoch: zaoch)
    }
}
