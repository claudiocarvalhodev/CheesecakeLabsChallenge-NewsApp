//
//  DateTransform+Custom.swift
//  News
//
//  Created by claudiocarvalho on 07/01/20.
//  Copyright © 2020 claudiocarvalho. All rights reserved.
//

import Foundation
import ObjectMapper

public extension DateTransform {
    
    static var custom: DateFormatterTransform {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return DateFormatterTransform(dateFormatter: formatter)
    }
}
