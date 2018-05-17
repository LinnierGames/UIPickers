//
//  Date+FormattedStrings.swift
//  UIPickers
//
//  Created by Erick Sanchez on 5/17/18.
//

import Foundation

extension DateComponents {
    static let AllComponents: Set<Calendar.Component> = [.era,.year,.month,.day,.hour,.minute,.second,.weekday,.weekdayOrdinal,.quarter,.weekOfMonth,.weekOfYear,.yearForWeekOfYear,.nanosecond,.calendar,.timeZone]
    
    init(date: Date, forComponents components: Set<Calendar.Component>)  {
        self = Calendar.current.dateComponents(components, from: date)
    }
    
    var dateValue: Date? {
        return Calendar.current.date(from: self)
    }
}

extension Date {
    
    /**
     Create a human readable string by defining a custom order, or array, of date tokens.
     
     - parameter formatter: the order and presentation of how the readable
     string will the date look like. You can use string literals in this array to
     add spaces and words like words, `" 'at' "`
     
     ## Usage
     
     ````
     let today = Date()
     
     today.formattedStringWith( .Day_oftheWeekFullName, " ", .Month_shorthand, " ", .Day_ofTheMonthNoPadding, ", ", .Year_noPadding)
     
     prints "Thursday May 10, 2018 at 2:49 PM"
     ````
     
     - returns: the formated date using the complied DateFormatter from `formatter`
     */
    func formattedStringWith(_ formatter: DateFormatterToken...) -> String {
        
        var compiledFormatterString = ""
        for aToken in formatter {
            compiledFormatterString.append(aToken.description)
        }
        
        return self.formattedString(with: compiledFormatterString)
    }
    
    func formattedString(with stringFormatter: String, timeZone: TimeZone = TimeZone.current, locale: Locale = Locale.current) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = stringFormatter
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = locale
        
        return dateFormatter.string(from: self)
    }
    
    /**
     return a new date by updating only the components given
     
     - parameter components: which components are updated to the given `date`
     */
    func equating(to date: Date, by components: Set<Calendar.Component>) -> Date {
        let dateComponents = DateComponents(date: date, forComponents: DateComponents.AllComponents)
        var selfComponents = DateComponents(date: self, forComponents: DateComponents.AllComponents)
        
        for aComponent in components {
            let newComponentValue = dateComponents.value(for: aComponent)
            selfComponents.setValue(newComponentValue, for: aComponent)
        }
        
        return selfComponents.dateValue!
    }
}

struct DateFormatterToken: CustomStringConvertible, ExpressibleByStringLiteral {
    typealias StringLiteralType = String
    
    private(set) var format: String
    
    // Year
    /** 2008 - Year, no padding */
    static let Year_noPadding: DateFormatterToken = "y"
    
    /** 08 - padding with a zero if necessary */
    static let Year_twoDigitPadding: DateFormatterToken = "yy"
    
    /** 2008 - padding with zeros if necessary) */
    static let Year_minimumOfFourDigits: DateFormatterToken = "yyyy"
    
    
    // Quarter
    /** 4 - The quarter of the year. Use QQ if you want zero padding. */
    static let Quarter_ofTheYear: DateFormatterToken = "Q"
    
    /** Q4 - Quarter including "Q" */
    static let Quarter_ofTheYearIncludingQ: DateFormatterToken = "QQQ"
    
    /** 4th quarter - Quarter spelled out */
    static let Quarter_spelledOut: DateFormatterToken = "QQQQ"
    
    
    // Month
    /** 12 - The numeric month of the year. A single M will use '1' for January. */
    static let Month_numericNoPadding: DateFormatterToken = "M"
    
    /** 12 - The numeric month of the year. A double M will use '01' for January. */
    static let Month_numericPadding: DateFormatterToken = "MM"
    
    /** Dec - The shorthand name of the month */
    static let Month_shorthand: DateFormatterToken = "MMM"
    
    /** December - Full name of the month */
    static let Month_fullName: DateFormatterToken = "MMMM"
    
    /** D - Narrow name of the month */
    static let Month_narrowName: DateFormatterToken = "MMMMM"
    
    
    // Day
    /** 14 - The day of the month. A single d will use 1 for January 1st. */
    static let Day_ofTheMonthNoPadding: DateFormatterToken = "d"
    
    /** 14 - The day of the month. A double d will use 01 for January 1st. */
    static let Day_ofTheMonthPadding: DateFormatterToken = "dd"
    
    /** 3rd Tuesday in December - The day of week in the month */
    static let Day_ofTheWeek: DateFormatterToken = "F"
    
    /** Tues - The day of week in the month */
    static let Day_ofTheWeekShorthand: DateFormatterToken = "E"
    
    /** Tuesday - The full name of the day */
    static let Day_oftheWeekFullName: DateFormatterToken = "EEEE"
    
    /** T - The narrow day of week */
    static let Day_ofTheWeekNarrawName: DateFormatterToken = "EEEEE"
    
    
    // Hour
    /** 4 - The 12-hour hour. */
    static let Hour_noPadding12: DateFormatterToken = "h"
    
    /** 04 - The 12-hour hour padding with a zero if there is only 1 digit */
    static let Hour_padding12: DateFormatterToken = "hh"
    
    /** 16 - The 24-hour hour. */
    static let Hour_noPadding24: DateFormatterToken = "H"
    
    /** 16 - The 24-hour hour padding with a zero if there is only 1 digit. */
    static let Hour_padding24: DateFormatterToken = "HH"
    
    /** PM - AM / PM for 12-hour time formats */
    static let Hour_am_pm: DateFormatterToken = "a"
    
    
    // Minute
    /** 5 - The minute, with no padding for zeroes. */
    static let Minute_noPadding: DateFormatterToken = "m"
    
    /** 05 - The minute with zero padding. */
    static let Minute_padding: DateFormatterToken = "mm"
    
    
    // Second
    /** 8 - The seconds, with no padding for zeroes. */
    static let Second_noPadding: DateFormatterToken = "s"
    
    /** 08 - The seconds with zero padding. */
    static let Second_padding: DateFormatterToken = "ss"
    
    
    // Time Zone
    /** CST - The 3 letter name of the time zone. Falls back to GMT-08:00 (hour offset) if the name is not known. */
    static let TimeZone_3Letter: DateFormatterToken = "zzz"
    
    /** Central Standard Time - The expanded time zone name, falls back to GMT-08:00 (hour offset) if name is not known. */
    static let TimeZone_expanded: DateFormatterToken = "zzzz"
    
    /** CST-06:00 - Time zone with abbreviation and offset */
    static let TimeZone_shorthandWithOffset: DateFormatterToken = "zzzz"
    
    /** 0600 - RFC 822 GMT format. Can also match a literal Z for Zulu (UTC) time. */
    static let TimeZone_RFC_822_GMT_format: DateFormatterToken = "Z"
    
    /** 06:00 - ISO 8601 time zone format */
    static let TimeZone_iso8601: DateFormatterToken = "ZZZZZ"
    
    init(stringLiteral value: StringLiteralType) {
        self.format = value
    }
    
    var description: String {
        return self.format
    }
    
    /** 2:09 am - no padding hour, padding minute and am/pm */
    static let Time_noPadding_am_pm = DateFormatterToken(stringLiteral: "\(DateFormatterToken.Hour_noPadding12):\(DateFormatterToken.Minute_padding) \(DateFormatterToken.Hour_am_pm)")
}
