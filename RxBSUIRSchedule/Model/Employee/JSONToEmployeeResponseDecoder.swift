//
//  JSONToEmployeeResponseDecoder.swift
//  RxBSUIRSchedule
//
//  Created by Artsiom Batura on 10/8/20.
//

import Foundation
import SwiftyJSON

class JSONToEmployeeResponseDecoder: JSONResponseDecoder<Employee> {
    
    public override func decode(json: JSON) throws -> Employee {
        
        var photoLink: String?
        
        guard
            let firstName = json["firstName"].string,
            let lastName = json["lastName"].string,
            let middleName = json["middleName"].string,
            /*let photoLink = json["photoLink"].string,*/
            let academicDepartment = json["academicDepartment"].arrayObject,
            let id = json["id"].int,
            let fio = json["fio"].string
        else {
            throw APIError.InvalidDecoder
        }
        
        var rank = ""
        if let rankFromJson = json["rank"].string {
            rank = rankFromJson
        }
        
        let academicDepartmentStrings = academicDepartment.map { $0 as! String }
        
        photoLink = json["photoLink"].string
        
        return Employee(firstName: firstName, lastName: lastName, middleName: middleName,
                        rank: rank, photoLink: photoLink, academicDepartment: academicDepartmentStrings,
                        id: id, fio: fio)
    }
}
