//
//  DateTime.swift
//  gsnet
//
//  Created by Gabor Soulavy on 20/11/2015.
//  Copyright © 2015 Gabor Soulavy. All rights reserved.
//

import Foundation

//MARK: INITIALISERS AND PRIVATE MEMBERS

public struct DateTime {
    internal var _date: NSDate
    private var _kind: DateTimeKind = .Unspecified
    private var _weekStarts: DayOfWeeks = .Sunday

    public init(year: Int = 2001, month: Int = 1, day: Int = 1, hour: Int = 0, minute: Int = 0, second: Int = 0, millisecond: Int = 0, kind: DateTimeKind = .Local, weekStarts: DayOfWeeks = .Sunday) {
        _weekStarts  = weekStarts
        let yearRanged = Math.MoveToRange(x: year, min: -9999, max: 9999)!
        let monthRanged = Math.MoveToRange(x: month, min: 1, max: 12)!
        let dayRanged = Math.MoveToRange(x: day, min: 1, max: DateTime.DaysInMonth(year: yearRanged, month: monthRanged)!)
        let nanosecond = (millisecond * DateTime.NANOSECONDS_IN_MILLISECOND)
        
        let components = NSDateComponents()
        _date = components.nSDateFromComponents(
            year: yearRanged,
                month: monthRanged,
                day: dayRanged,
                hour: Math.MoveToRange(x: hour, min: 0, max: 23),
                minute: Math.MoveToRange(x: minute, min: 0, max: 59),
                second: Math.MoveToRange(x: second, min: 0, max: 59),
                nanosecond: nanosecond,
            timeZone: DateTime.dateTimeKindToTimeZone(kind))! as NSDate
        _kind = kind
    }

    public init(nsdate: NSDate, kind: DateTimeKind = .Local, weekStarts: DayOfWeeks = .Sunday) {
        _weekStarts = weekStarts
        let timeZone: TimeZone = DateTime.dateTimeKindToTimeZone(kind)
        var calendar = NSCalendar.current
        calendar.timeZone = timeZone
        _date = nsdate
        _kind = kind
    }

    public init(interval: Double, kind: DateTimeKind = .Local, weekStarts: DayOfWeeks = .Sunday) {
        self.init(interval: interval, kind: kind, intervalSince: 0, weekStarts: weekStarts)
    }

    public init(epoch: Double, kind: DateTimeKind = .Local, weekStarts: DayOfWeeks = .Sunday) {
        self.init(interval: epoch, kind: kind, intervalSince: DateTime.TICKS_BETWEEN_REFERENCEZERO_AND_EPOCHZERO_IN_SECONDS, weekStarts: weekStarts)
    }
    
    public init(ldap: Int, kind: DateTimeKind = .Local, weekStarts: DayOfWeeks = .Sunday) {
        self.init(ticks: ldap, kind: kind, interval: DateTime.TICKS_BETWEEN_REFERENCEZERO_AND_LDAPZERO_IN_SECONDS, weekStarts: weekStarts)
    }

    public init(ticks: Int, kind: DateTimeKind = .Local, weekStarts: DayOfWeeks = .Sunday) {
        self.init(ticks: ticks, kind: kind, interval: DateTime.TICKS_BETWEEN_REFERENCEZERO_AND_DTZERO_IN_SECONDS, weekStarts: weekStarts)
    }
    
    private init(interval: Double, kind: DateTimeKind, intervalSince: Double, weekStarts: DayOfWeeks) {
        _weekStarts = weekStarts
        let timeZone: TimeZone = DateTime.dateTimeKindToTimeZone(kind)
        var calendar = NSCalendar.current
        calendar.timeZone = timeZone
        _date = NSDate(timeIntervalSinceReferenceDate: interval + intervalSince)
        _kind = kind
    }

    private init(ticks: Int, kind: DateTimeKind, interval: Double, weekStarts: DayOfWeeks) {
        _weekStarts = weekStarts
        let timeZone: TimeZone = DateTime.dateTimeKindToTimeZone(kind)
        var calendar = NSCalendar.current
        calendar.timeZone = timeZone
        _date = NSDate(timeIntervalSinceReferenceDate: Double(ticks) / DateTime.LDAP_TICKS_IN_SECOND - interval)
        _kind = kind
    }
}

//MARK: PUBLIC DATETIME PROPERTIES

public extension DateTime {
    /// Get the year component of the date
    var Year: Int {
        return Components.year!
    }
    /// Get the month component of the date
    var Month: Int {
        return Components.month!
    }
    /// Get the week of the month component of the date
    var WeekOfMonth: Int {
        return Components.weekOfMonth!
    }
    /// Get the week of the month component of the date
    var WeekOfYear: Int {
        return Components.weekOfYear!
    }
    /// Get the weekday component of the date
    var Weekday: Int {
        let computedDaysFromWeekStart = (Components.weekday! + 1 - self._weekStarts.rawValue) % 7
        return computedDaysFromWeekStart == 0 ? 7 : computedDaysFromWeekStart
    }

    /// Get the weekday ordinal component of the date
    var WeekdayOrdinal: Int {
        return _weekStarts.rawValue
    }
    /// Get the day component of the date
    var Day: Int {
        return Components.day!
    }
    /// Get the hour component of the date
    var Hour: Int {
        return Components.hour!
    }
    /// Get the minute component of the date
    var Minute: Int {
        return Components.minute!
    }
    /// Get the second component of the date
    var Second: Int {
        return Components.second!
    }
    /// Get the millisecond component of the Date
    var Millisecond: Int {
        return Components.nanosecond! / DateTime.NANOSECONDS_IN_MILLISECOND
    }
    /// Get the era component of the date
    var Era: Int {
        return Components.era!
    }
    /// Get the current month name based upon current locale
    var MonthName: String {
        let dateFormatter = NSDate.localThreadDateFormatter()
        dateFormatter.locale = NSLocale.autoupdatingCurrent
        return dateFormatter.monthSymbols[Month - 1] as String
    }
    /// Get the current weekday name
    var WeekdayName: String {
        let dateFormatter = NSDate.localThreadDateFormatter()
        dateFormatter.locale = NSLocale.autoupdatingCurrent
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: _date as Date)
    }

    /**
    Read-only: the kind of the date
     - Returns: DateTimeKind
        - Values: **Utc, Local, Unspecified**
    */
    var Kind: DateTimeKind {
        return _kind
    }

    /**
    Read-only: the NSDate core type
     - Returns: **original** NSDate object (will mutate the original Date object)
    */
    var AsDate: NSDate? {
        return _date
    }

    /**
    Read-only: the NSDate core type
     - Returns: **copy** NSDate object
    */
    var ToNSDate: NSDate? {

        return _date.copy() as? NSDate
    }

    /**
    Read-only: Double ticks since reference (**2001-01-01**)
     - Returns: Double in second
    */
    var Interval: Double {
        return _date.timeIntervalSinceReferenceDate
    }

    /**
     Read-only: Double ticks since epoch zero (**1970-01-01**)
     - Returns: Double in second
     */
    var Epoch: Double {
        return _date.timeIntervalSince1970
    }

    /**
     Read-only: Double ticks since epoch zero (**1601-01-01**)
     - Returns: Double in second
     */
    var LDAP: Int {
        return Int((_date.timeIntervalSinceReferenceDate + DateTime.TICKS_BETWEEN_REFERENCEZERO_AND_LDAPZERO_IN_SECONDS) * DateTime.LDAP_TICKS_IN_SECOND)
    }

    /**
     Read-only: Int ticks since fileTime zero (**0001-01-01**)
     - Returns: Int
     */
    var Ticks: Int {
        return Int((self.Interval + DateTime.TICKS_BETWEEN_REFERENCEZERO_AND_DTZERO_IN_SECONDS) * DateTime.LDAP_TICKS_IN_SECOND)
    }

    /**
     Read-only: Returns NSDateComponent belonging to Date
     - Returns: NSDateComponent
     */
    var Components: DateComponents {
        let timeZone = DateTime.dateTimeKindToTimeZone(_kind)
        var calendar = NSCalendar.current
        calendar.timeZone = timeZone
        return calendar.dateComponents(in: timeZone, from: _date as Date)
    }
    
    var Date: DateTime {
        return DateTime(year: self.Year, month: self.Month, day: self.Day, kind: self._kind)
    }
    
    var DayOfWeek: DayOfWeeks {
        return DayOfWeeks(rawValue: Components.weekday!)!
    }
    
    var DayOfYear: Int {
        return (Components.calendar?.ordinality(of: .day, in: .year, for: _date as Date))!
    }
    
    static var Now: DateTime {
        return DateTime(nsdate: NSDate(), kind: .Local)
    }
    
    static var UtcNow: DateTime {
        return DateTime(nsdate: NSDate(), kind: .Utc)
    }
    
    var TimeOfDay: TimeSpan {
        return TimeSpan(hours: Double(self.Hour), minutes: Double(self.Minute), seconds: Double(self.Second), milliseconds: Double(self.Millisecond))
    }
    
    var WeekStarts: DayOfWeeks {
        get { return _weekStarts }
        set { _weekStarts = newValue }
    }
}

//MARK: PUBLIC DATETIME METHODS

public extension DateTime {
    static func DaysInMonth(year: Int? = nil, month: Int? = nil) -> Int? {
        if year == nil || month == nil {
            return nil
        }
        var comp = DateComponents()
        comp.year = Math.MoveToRange(x: year!, min: 1, max: 9999)!
        comp.month = Math.MoveToRange(x: month!, min: 0, max: 12)!
        let cal = NSCalendar.current
        let nsdate = cal.date(from: comp)
        let days = cal.range(of: .day, in: .month, for: nsdate!)
        return days?.count
    }

    internal func withNewDate(_ date : Date) -> DateTime
    {
        var copy = self
        copy._date = date as NSDate
        return copy
    }
    
    // Why is this needed? DateTime is a struct
//    func copy() -> DateTime {
//        let nsDate: NSDate = self._date.copy() as! NSDate
//        return DateTime(nsdate: nsDate, kind: self._kind, weekStarts: self._weekStarts)
//    }
    
//    mutating func AddMutatingTimeSpan(_ timeSpan: TimeSpan) {
//        self.AddMutatingInterval(timeSpan.Interval)
//    }
    
    func AddTimeSpan(_ timeSpan: TimeSpan) -> DateTime {
        return self.AddInterval(timeSpan.Interval)
    }

    func AddComponents(_ components : DateComponents) -> DateTime {
        let date = Components.calendar?.date(byAdding: components, to: _date as Date)
        return self.withNewDate(date!)
    }
    
    func AddDays(_ days: Int) -> DateTime {
        var component = DateComponents()
        component.day = days
        return AddComponents(component)
    }
    
    func AddHours(_ hours: Int) -> DateTime {
        var component = DateComponents()
        component.hour = hours
        return AddComponents(component)
    }

    func AddMinutes(_ minutes: Int) -> DateTime {
        var component = DateComponents()
        component.minute = minutes
        return AddComponents(component)
    }

    func AddSeconds(_ seconds: Int) -> DateTime {
        var component = DateComponents()
        component.second = seconds
        return AddComponents(component)
    }

    func AddMilliseconds(_ milliseconds: Int) -> DateTime {
        var component = DateComponents()
        component.nanosecond = milliseconds * DateTime.NANOSECONDS_IN_MILLISECOND
        return AddComponents(component)
    }
    
    func AddInterval(_ interval: TimeInterval) -> DateTime {
        let date = self._date.addingTimeInterval(interval)
        return self.withNewDate(date as Date)
    }
    
    func IsLeapYear() -> Bool {
        let year = self.Year
        return (( year % 100 != 0)) && (year % 4 == 0) || year % 400 == 0
    }
    
    func IsDaylightSavingTime() -> Bool {
        let timeZone = DateTime.dateTimeKindToTimeZone(_kind)
        return timeZone.isDaylightSavingTime(for: _date as Date)
    }
    
    func Equals(_ dateTime: DateTime) -> Bool {
        if (self.Interval == dateTime.Interval) {
            return true
        }
        return false
    }
    
    static func Parse(_ dateString: String, _ format: String, _ kind: DateTimeKind = .Local, _ weekStarts: DayOfWeeks = .Sunday) -> DateTime? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if let nsDate = dateFormatter.date(from: dateString) {
            return DateTime(nsdate: nsDate as NSDate, kind: kind, weekStarts: weekStarts)
        }
        return nil
    }
    
    static func Parse(_ dateString: String, _ format: DateTimeFormat, _ kind: DateTimeKind = .Local, _ weekStarts: DayOfWeeks = .Sunday) -> DateTime? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        if let nsDate = dateFormatter.date(from: dateString) {
            return DateTime(nsdate: nsDate as NSDate, kind: kind, weekStarts: weekStarts)
        }
        return nil
    }
    
    func ToString(_ format: DateTimeFormat = .FULL) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: _date as Date)
    }
    
    func ToString(_ format: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = format
        return dateFormatter.string(from: _date as Date)
    }
    
    func ToString(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: _date as Date)
    }
    
    func ToUtc() -> DateTime {
        if self._kind == .Utc {
            return self
        } else {
            return DateTime(nsdate: _date, kind: .Utc, weekStarts: _weekStarts)
        }
    }
    
    func ToLocal() -> DateTime {
        if self._kind == .Local {
            return self
        } else {
            return DateTime(nsdate: _date, kind: .Local, weekStarts: _weekStarts)
        }
    }
}

//MARK: INTERNAL DATETIME CONSTANTS

internal extension DateTime {
    static let LDAP_TICKS_IN_SECOND: Double = 10000000

    static let NANOSECONDS_IN_MILLISECOND: Int = 1000000

    static let TICKS_BETWEEN_REFERENCEZERO_AND_DTZERO_IN_SECONDS: Double = 63113904000
    static let TICKS_BETWEEN_REFERENCEZERO_AND_EPOCHZERO_IN_SECONDS: Double = 978307200
    static let TICKS_BETWEEN_REFERENCEZERO_AND_LDAPZERO_IN_SECONDS: Double = 12622780800
}

//MARK: PRIVATE DATETIME MEMBERS

private extension DateTime {

    private static func componentFlags() -> Set<Calendar.Component> {
        return [.era,
                .year,
                .month,
                .day,
                .weekOfYear,
                .hour,
                .minute,
                .second,
                .nanosecond,
                .weekday,
                .weekOfMonth,
                .weekdayOrdinal,
                .weekOfYear,
                .timeZone]
    }

    private func addComponents(components: DateComponents) -> NSDate? {
        let calendar = NSCalendar.current
        return calendar.date(byAdding: components, to: _date as Date) as NSDate?
    }

    /// Retun timeZone sensitive components
    private var components: DateComponents {
        return NSCalendar.current.dateComponents(DateTime.componentFlags(), from: _date as Date)
    }

    /// Return the NSDateComponents
    private var componentsWithTimeZone: DateComponents {
        let timeZone = DateTime.dateTimeKindToTimeZone(_kind)
        var calendar = NSCalendar.current
        calendar.timeZone = timeZone
        var component = NSCalendar.current.dateComponents(DateTime.componentFlags(), from: _date as Date)
        component.timeZone = timeZone
        return component
    }

    /**
     This function uses NSThread dictionary to store and retrive a thread-local object, creating it if it has not already been created
     
     :param: key    identifier of the object context
     :param: create create closure that will be invoked to create the object
     
     :returns: a cached instance of the object
     */
//    private static func cachedObjectInCurrentThread<T:AnyObject>(key: String, create: () -> T) -> T {
//        if let threadDictionary = NSThread.currentThread().threadDictionary as NSMutableDictionary? {
//            if let cachedObject = threadDictionary[key] as! T? {
//                return cachedObject
//            } else {
//                let newObject = create()
//                threadDictionary[key] = newObject
//                return newObject
//            }
//        } else {
//            assert(false, "Current NSThread dictionary is nil. This should never happens, we will return a new instance of the object on each call")
//            return create()
//        }
//    }

    /**
     Return a thread-cached DateFormatter instance
     
     :returns: instance of DateFormatter
     */
//    private static func localThreadDateFormatter() -> DateFormatter {
//        return DateTime.cachedObjectInCurrentThread("com.library.swiftdate.dateformatter") {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//            return dateFormatter
//        }
//    }

    private static func dateTimeKindToTimeZone(_ kind: DateTimeKind) -> TimeZone {
        if kind == .Utc {
            return TimeZone(abbreviation: "UTC")!
        }
        return TimeZone.current
    }
}

internal extension NSDateComponents {

    func nSDateFromComponents(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil, nanosecond: Int? = nil, timeZone: TimeZone? = nil) -> Date! {
        if year != nil {
            self.year = year!
        }
        if month != nil {
            self.month = month!
        }
        if day != nil {
            self.day = day!
        }
        self.hour = (hour != nil) ? hour! : 0
        self.minute = (minute != nil) ? minute! : 0
        self.second = (second != nil) ? second! : 0
        self.nanosecond = (nanosecond != nil) ? nanosecond! : 0
        self.timeZone = (timeZone != nil ? timeZone! : TimeZone.current)

        // Set weekday stuff to undefined to prevent dateFromComponents to get confused
        self.yearForWeekOfYear = NSDateComponentUndefined
        self.weekOfYear = NSDateComponentUndefined
        self.weekday = NSDateComponentUndefined
        self.weekdayOrdinal = NSDateComponentUndefined

        // Set calendar time zone to desired time zone
        var calendar = Calendar.current
        calendar.timeZone = self.timeZone!

        return calendar.date(from: self as DateComponents)
    }
}

//MARK: ARITHMETICS OVERLOADS

public func +(left: DateTime, right: TimeSpan) -> DateTime {
    return DateTime(interval: left.Interval + right.Interval, kind: left.Kind, weekStarts: left.WeekStarts)
}

public func -(left: DateTime, right: TimeSpan) -> DateTime {
    return DateTime(interval: left.Interval - right.Interval, kind: left.Kind, weekStarts: left.WeekStarts)
}

//MARK: EQUATABLE IMPLEMENTATION

extension DateTime : Equatable {}

public func ==(left: DateTime, right: DateTime) -> Bool {
    return left.Equals(right)
}

public func !=(left: DateTime, right: DateTime) -> Bool {
    return !left.Equals(right)
}

//MARK: COMPARABLE IMPLEMENTATION

extension DateTime: Comparable {}

public func <(left: DateTime, right: DateTime) -> Bool {
    return (left.Interval < right.Interval)
}

public func >(left: DateTime, right: DateTime) -> Bool {
    return (left.Interval > right.Interval)
}

public func <=(left: DateTime, right: DateTime) -> Bool {
    return (left.Interval <= right.Interval)
}

public func >=(left: DateTime, right: DateTime) -> Bool {
    return (left.Interval >= right.Interval)
}
