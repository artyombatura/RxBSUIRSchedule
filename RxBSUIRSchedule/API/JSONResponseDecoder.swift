//
//  JSONResponseDecoder.swift
//  RxBSUIRSchedule
//
//  Created by Artsiom Batura on 10/8/20.
//

import Foundation
import SwiftyJSON

public class JSONResponseDecoder<Result>: ResponseDecoder<Result> {
    
    public let relativePath: [String]
    
    public convenience override init() {
        self.init(path: [])
    }
    
    public convenience init(key: String) {
        self.init(path: [key])
    }
    
    public init(path: [String]) {
        relativePath = path
    }
    
    public final override func decode(data: Data) throws -> Result {
        let json = try JSON(data: data, options: .allowFragments)
        if let error = json.error {
            throw error
        }
        return try decode(json: json[relativePath])
    }
    
    public func decode(json: JSON) throws -> Result {
        throw APIError.InvalidDecoder
    }
    
}
