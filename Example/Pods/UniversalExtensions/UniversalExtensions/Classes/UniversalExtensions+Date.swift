

extension Int {
    var mintues: TimeInterval {
        return TimeInterval(self) * CTDateComponentMinute
    }
    
    var hours: TimeInterval {
        return TimeInterval(self) * CTDateComponentHour
    }
    
    var days: TimeInterval {
        return TimeInterval(self) * CTDateComponentDay
    }
    
    var weeks: TimeInterval {
        return TimeInterval(self) * CTDateComponentWeek
    }
}

private enum WeekdayRange {
    case First
    case Last
}

public struct WordDescriptor {
    var shorter: String?
    var short: String?
    var `default`: String
    var long: String?
    var longer: String?
}

// TODO : may not work on other locals
let CTDateComponentMinute: TimeInterval = 60
let CTDateComponentHour: TimeInterval = CTDateComponentMinute*60
let CTDateComponentDay: TimeInterval = CTDateComponentHour*24
let CTDateComponentWeek: TimeInterval = CTDateComponentDay*7

extension String {
    /**
     0 is .none, 1 is .short, 2 is .medium, 3 is .long, 4 is .full
     d: 0 t: 0 ->
     d: 0 t: 1 -> 10:09 AM
     d: 0 t: 2 -> 10:09:00 AM
     d: 0 t: 3 -> 10:09:00 AM PDT
     d: 0 t: 4 -> 10:09:00 AM Pacific Daylight Time
     d: 1 t: 0 -> 3/30/18
     d: 1 t: 1 -> 3/30/18, 10:09 AM
     d: 1 t: 2 -> 3/30/18, 10:09:00 AM
     d: 1 t: 3 -> 3/30/18, 10:09:00 AM PDT
     d: 1 t: 4 -> 3/30/18, 10:09:00 AM Pacific Daylight Time
     d: 2 t: 0 -> Mar 30, 2018
     d: 2 t: 1 -> Mar 30, 2018 at 10:09 AM
     d: 2 t: 2 -> Mar 30, 2018 at 10:09:00 AM
     d: 2 t: 3 -> Mar 30, 2018 at 10:09:00 AM PDT
     d: 2 t: 4 -> Mar 30, 2018 at 10:09:00 AM Pacific Daylight Time
     d: 3 t: 0 -> March 30, 2018
     d: 3 t: 1 -> March 30, 2018 at 10:09 AM
     d: 3 t: 2 -> March 30, 2018 at 10:09:00 AM
     d: 3 t: 3 -> March 30, 2018 at 10:09:00 AM PDT
     d: 3 t: 4 -> March 30, 2018 at 10:09:00 AM Pacific Daylight Time
     d: 4 t: 0 -> Friday, March 30, 2018
     d: 4 t: 1 -> Friday, March 30, 2018 at 10:09 AM
     d: 4 t: 2 -> Friday, March 30, 2018 at 10:09:00 AM
     d: 4 t: 3 -> Friday, March 30, 2018 at 10:09:00 AM PDT
     d: 4 t: 4 -> Friday, March 30, 2018 at 10:09:00 AM Pacific Daylight Time
     */
    init(date: NSDate, dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .none) {
        #if swift(>=4.0)
        self.init(DateFormatter.localizedString(from: date as Date, dateStyle: dateStyle, timeStyle: timeStyle))
        #else
        self.init(DateFormatter.localizedString(from: date as Date, dateStyle: dateStyle, timeStyle: timeStyle))!
        #endif
    }
    
    init(date: Date, dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .none) {
        self = String(date: date as NSDate, dateStyle: dateStyle, timeStyle: timeStyle)
    }
    
    init(date: Date, formatter dateFormat: String, timeZone: TimeZone = TimeZone.current, locale: Locale = Locale.current) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = locale
        
        #if swift(>=4.0)
        self.init(dateFormatter.string(from: date))
        #else
        self.init(dateFormatter.string(from: date))!
        #endif
    }
    
    /*
     Formats the number of seconds into units providedas
     3600 seconds is "1h 0m 0s"
     */
    init(timeInterval: TimeInterval) {
        self.init(timeInterval: timeInterval, units: .weekday, .day, .hour, .minute, .second)
    }
    
    init(timeInterval: TimeInterval, units: Calendar.Component...) {
        let options = TimeIntervalOptions(units: units, unitWindowSize: 0)
        
        self.init(timeInterval: timeInterval, options: options)
    }
    
    struct TimeIntervalOptions {
        /**
         - warning: keep this collection sorted, the last element is the smallest
         */
        var units: [Calendar.Component]
        var unitWindowSize: Int = 0
        var textInterpolation: (Int, WordDescriptor) -> (String)
        var textSeparator: String
        
        init(
            units: [Calendar.Component],
            unitWindowSize: Int,
            textInterpolation: @escaping (Int, WordDescriptor) -> (String) = { "\($0)\($1.shorter!) " },
            textSeparator: String = " "
            ) {
            self.units = units
            self.unitWindowSize = unitWindowSize
            self.textInterpolation = textInterpolation
            self.textSeparator = textSeparator
        }
        
        /** only displaying time; hour, minute and second */
        static var time: TimeIntervalOptions {
            return .init(units: [.hour, .minute, .second], unitWindowSize: 0)
        }
        
        /** window size of 2 only displaying hour, minute and second */
        static var largestTwoTime: TimeIntervalOptions {
            return .init(units: [.hour, .minute, .second], unitWindowSize: 2)
        }
        
        /** window size of 2 only displaying day, hour and mintue */
        static var largestTwoUnits: TimeIntervalOptions {
            return .init(units: [.day, .hour, .minute], unitWindowSize: 2)
        }
    }
    
    init(timeInterval: TimeInterval, options: TimeIntervalOptions) {
        //TODO: guard edge cases
        
        var nSeconds = abs(Int(timeInterval))
        
        var string = ""
        var currentWindowSize = 1
        
        let dateComponentScales = DateComponents.ComponentScales
        
        //TODO Months
        for aUnit in options.units {
            if options.unitWindowSize != 0, currentWindowSize > options.unitWindowSize {
                break
            }
            
            if let scaleInfo = dateComponentScales[aUnit] {
                if aUnit == .second {
                    if nSeconds > 0 {
                        //TODO: puralization
                        string.append(options.textInterpolation(nSeconds, scaleInfo.character))
                        string.append(options.textSeparator)
                    }
                } else {
                    let unitCount = nSeconds/Int(scaleInfo.scale)
                    nSeconds -= unitCount*Int(scaleInfo.scale)
                    if unitCount > 0 {
                        let text = options.textInterpolation(unitCount, scaleInfo.character)
                        
                        //TODO: puralization
                        string.append(text)
                        string.append(options.textSeparator)
                        currentWindowSize += 1
                    }
                }
            }
        }
        
        // If no units were added to string, add the smallest unit with the count
        //of zero
        if string == "" {
            if let smallestUnit = options.units.last,
                let scaleInfo = dateComponentScales[smallestUnit] {
                
                self = options.textInterpolation(0, scaleInfo.character)
                
                // Error? return the empty string
            } else {
                self = string
            }
        } else {
            // deletes the appended textSeparator
            if options.textSeparator != "" {
                string.removeLast()
            }
            
            self = string
        }
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

extension DateComponents {
    static let AllComponents: Set<Calendar.Component> = [.era,.year,.month,.day,.hour,.minute,.second,.weekday,.weekdayOrdinal,.quarter,.weekOfMonth,.weekOfYear,.yearForWeekOfYear,.nanosecond,.calendar,.timeZone]
    
    static let ComponentScales: [Calendar.Component: (scale: TimeInterval, character: WordDescriptor)] = [
        .second: (1, WordDescriptor(shorter: "s", short: "sec", default: "Second", long: nil, longer: nil)),
        .minute: (CTDateComponentMinute, WordDescriptor(shorter: "m", short: "min", default: "Minute", long: nil, longer: nil)),
        .hour: (CTDateComponentHour, WordDescriptor(shorter: "h", short: "hr", default: "Hour", long: nil, longer: nil)),
        .day: (CTDateComponentDay, WordDescriptor(shorter: "d", short: "day", default: "Day", long: nil, longer: nil)),
        .weekday: (CTDateComponentWeek, WordDescriptor(shorter: "w", short: "wk", default: "Week", long: nil, longer: nil))
    ]
    static let DayComponents: Set<Calendar.Component> = [.year,.month,.day]
    static let TimeComponents: Set<Calendar.Component> = [.hour,.minute,.second]
    
    init(date: Date, forComponents components: Set<Calendar.Component>)  {
        self = Calendar.current.dateComponents(components, from: date)
    }
    
    var dateValue: Date? {
        return Calendar.current.date(from: self)
    }
    
    /** returns the length in time, seconds+mintues+hours only */
    var timeInterval: TimeInterval {
        get {
            var interval: TimeInterval = 0
            if let _second = second {
                interval += TimeInterval(_second)
            }
            if let _minute = minute {
                interval += TimeInterval(_minute)*CTDateComponentMinute
            }
            if let _hour = hour {
                interval += TimeInterval(_hour)*CTDateComponentHour
            }
            
            return interval
        }
    }
    
    /** requires weekday and the calendar */
    var weekdayTitle: String? {
        if let weekdaySymbols = calendar?.weekdaySymbols {
            if let day = weekday {
                return weekdaySymbols[day - 1]
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}

extension Date {
    
    /*
     returns today's date with hour = minute = second = 0. Use `interval = 0`
     to return midnight
     */
    init(timeIntervalSinceMidnight interval: TimeInterval, from date: Date = Date()) {
        var components = DateComponents(date: date.addingTimeInterval(interval), forComponents: DateComponents.AllComponents)
        components.hour = 0
        components.minute = 0
        components.second = 0
        self = components.dateValue!.addingTimeInterval(interval)
    }
    
    func components(_ components: Set<Calendar.Component>) -> DateComponents {
        return DateComponents(date: self, forComponents: components)
    }
    
    var midnight: Date {
        var components = DateComponents(date: self, forComponents: DateComponents.AllComponents)
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        return components.dateValue!
    }
    
    var endOfDay: Date {
        var components = DateComponents(date: self, forComponents: DateComponents.AllComponents)
        components.hour = 23
        components.minute = 59
        components.second = 59
        
        return components.date!
    }
    
    /**
     compares year, month, and day only
     
     - returns: true if the comparison is true
     */
    func isSameDay(as otherDate: Date) -> Bool {
        let selfComponents = self.components(DateComponents.DayComponents)
        let otherComponents = otherDate.components(DateComponents.DayComponents)
        let selfTuple = (selfComponents.year!, selfComponents.month!, selfComponents.day!)
        let otherTuple = (otherComponents.year!, otherComponents.month!, otherComponents.day!)
        
        return selfTuple == otherTuple
    }
    
    func isSame(as otherDate: Date, compareBy query: (_ lo: DateComponents, _ ro: DateComponents) -> (Bool)) -> Bool {
        let selfDateComponents = DateComponents(date: self, forComponents: DateComponents.AllComponents)
        let otherDateComponents = DateComponents(date: otherDate, forComponents: DateComponents.AllComponents)
        
        return query(selfDateComponents, otherDateComponents)
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

private func weekday(from sourceDate: Date, weekday: String? = nil, weekdayRange: WeekdayRange? = .First) -> Date {
    //assert(weekday == nil && weekdayRange == nil, "must use weekday or weekday range")
    
    let calendar = Calendar.current
    var dateComponents = DateComponents()
    let listOfWeekdays = calendar.weekdaySymbols
    if weekday != nil {
        dateComponents.weekday = listOfWeekdays.index(of: weekday!)
    } else {
        dateComponents.weekday = weekdayRange == .First ? 1 : listOfWeekdays.count
    }
    
    let sourceDateComponents = DateComponents(date: sourceDate, forComponents: [.weekday])
    
    if sourceDateComponents.weekday! == dateComponents.weekday! {
        return sourceDate
    }
    
    let direction: Calendar.SearchDirection
    if dateComponents.weekday! < sourceDateComponents.weekday! {
        direction = .backward
    } else {
        direction = .forward
    }
    
    let date = calendar.nextDate(after: sourceDate, matching: dateComponents, matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: direction)!
    
    return date
}

extension Calendar {
    public func endOfDay(for date: Date) -> Date {
        let startOfDate = self.startOfDay(for: date)
        var components = DateComponents(date: startOfDate, forComponents: [.hour,.minute,.second])
        components.hour = 23
        components.minute = 59
        components.second = 59
        
        return components.date!
    }
}
