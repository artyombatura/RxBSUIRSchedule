//
//  Employee.swift
//  RxBSUIRSchedule
//
//  Created by Artsiom Batura on 10/8/20.
//

import Foundation
import UIKit
import SwiftyJSON

class Employee {
    public var firstName: String?
    public var lastName: String?
    public var middleName: String?
    public var rank: String?
    public var photoLink: String?
    public var academicDepartment: [String]?
    public var id: Int?
    public var fio: String?
    
    public var photoImage: UIImage?
    
    init(firstName: String, lastName: String, middleName: String, rank: String,
         photoLink: String?, academicDepartment: [String], id: Int, fio: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.middleName = middleName
        self.rank = rank
        self.photoLink = photoLink
        self.academicDepartment = academicDepartment
        self.id = id
        self.fio = fio
    }
    
    init(){}
    
    init(withJSON json: JSON) throws {
        guard
            let firstName = json["firstName"].string,
            let lastName = json["lastName"].string,
            let middleName = json["middleName"].string,
            /*let photoLink = json["photoLink"].string,*/
            let academicDepartment = json["academicDepartment"].arrayObject,
            let id = json["id"].int,
            let fio = json["fio"].string
        else { throw APIError.BuildJSONFailure }
        
        var rank = ""
        if let rankFromJson = json["rank"].string {
            rank = rankFromJson
        }
        
        let academicDepartmentStrings = academicDepartment.map { $0 as! String }
        
        photoLink = json["photoLink"].string
        
        self.firstName = firstName
        self.lastName = lastName
        self.middleName = middleName
        self.rank = rank
        self.academicDepartment = academicDepartmentStrings
        self.id = id
        self.fio = fio
    }
    
}
