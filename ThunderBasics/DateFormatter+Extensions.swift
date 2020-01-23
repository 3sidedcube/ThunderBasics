//
//  DateFormatter+Extensions.swift
//  ThunderBasics-iOS
//
//  Created by Ben Shutt on 23/01/2020.
//  Copyright © 2020 threesidedcube. All rights reserved.
//

import Foundation

public extension DateFormatter {
    
    /// Standard `iso8601` `DateFormatter`
    /// Note milliseconds included, for customization over `dateFormat`, see `iso8601(dateFormat:timeZone:)`
    static var iso8601: DateFormatter {
        return iso8601Formatter(
            dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        )
    }
    
    /// `DateFormatter` has:
    /// - `.iso8601` `Calendar`
    /// - "en_US_POSIX" `Locale`
    /// - Given `timeZone`, defaults to GMT
    /// - Given `dateFormat`
    static func iso8601Formatter(dateFormat: String, timeZone: TimeZone? = TimeZone(secondsFromGMT: 0)) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = timeZone
        formatter.dateFormat = dateFormat
        return formatter
    }
}
