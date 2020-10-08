//
//  ResponseDecoder.swift
//  RxBSUIRSchedule
//
//  Created by Artsiom Batura on 10/8/20.
//

import Foundation

public class ResponseDecoder<Result> {
    
    public func decode(data: Data) throws -> Result {
        throw APIError.InvalidDecoder
    }
    
}
