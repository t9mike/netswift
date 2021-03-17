//
//  DateTime.swift
//  gsnet
//
//  Created by Gabor Soulavy on 20/11/2015.
//  Copyright © 2015 Gabor Soulavy. All rights reserved.
//

import Foundation
import AnyDate

//MARK: INITIALISERS AND PRIVATE MEMBERS

public class DateTime : Codable,Hashable,CustomStringConvertible,CustomDebugStringConvertible {

    public func hash(into hasher: inout Hasher) {
        _date.hash(into: &hasher)
    }

    internal var _date: NSDate
    private var _kind: DateTimeKind = .Unspecified
    private var _weekStarts: DayOfWeeks = .Sunday
        
    /// The timezone based on Kind: UTC or user's current timezone
    public private(set) var Timezone : TimeZone

//    private var _anyDate: AnyDate.LocalDateTime? = nil
//
//    private var anyDate: AnyDate.LocalDateTime {
//        if (_anyDate == nil) {
//            let timeZone = DateTime.dateTimeKindToTimeZone(_kind)
//            _anyDate = AnyDate.LocalDateTime(_date as Date, timeZone: timeZone)
//        }
//        return _anyDate!
//    }
    
    private var Components: DateComponents {
        get {
            if (_Components == nil) {
                let timeZone = DateTime.dateTimeKindToTimeZone(_kind)
        //        print("calendar=\(calendar), timeZone=\(timeZone), _date=\(date)")
                _Components = DateTime.calendar.dateComponents(in: timeZone, from: _date as Date)
            }
            return _Components!
        }
    }
    private var _Components : DateComponents? = nil

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.ToJavaScriptTicks())
    }
    
    // NSCalendar.current was expensive in profiling; switch to this global version
    private static let calendar : Calendar = NSCalendar.autoupdatingCurrent
    
    required public convenience init(from decoder: Decoder) throws {
        do
        {
            let container = try decoder.singleValueContainer()
            let jsTicks = try container.decode(Int64.self)
            let ticks = DateTime.JavaScriptTicksToUniversialTicks(jsTicks)
            self.init(ticks: ticks, kind:.Utc)
        } catch
        {
            // Default to minimum value
            self.init(ticks: DateTime.MinValue.Ticks, kind:.Utc)
        }
    }

    public init(year: Int = 2001, month: Int = 1, day: Int = 1, hour: Int = 0, minute: Int = 0, second: Int = 0, millisecond: Int = 0, kind: DateTimeKind = .Local, weekStarts: DayOfWeeks = .Sunday) {
        _weekStarts  = weekStarts
        
        let yearRanged = Math.MoveToRange(x: year, min: -9999, max: 9999)!
        let monthRanged = Math.MoveToRange(x: month, min: 1, max: 12)!
        
        // This is very expensive due to DateTime.DaysInMonth(): assume good input
//        let dayRanged = Math.MoveToRange(x: day, min: 1, max: DateTime.DaysInMonth(year: yearRanged, month: monthRanged)!)
        
        let nanosecond = (millisecond * DateTime.NANOSECONDS_IN_MILLISECOND)
        
        Timezone = DateTime.dateTimeKindToTimeZone(kind)
        let components = NSDateComponents()
        _date = components.nSDateFromComponents(
            year: yearRanged,
            month: monthRanged,
            day: day,
            hour: Math.MoveToRange(x: hour, min: 0, max: 23),
            minute: Math.MoveToRange(x: minute, min: 0, max: 59),
            second: Math.MoveToRange(x: second, min: 0, max: 59),
            nanosecond: nanosecond,
            timeZone: Timezone)! as NSDate
        _kind = kind
    }

    /// Singleton, lazy created
    public static let MinValue : DateTime = DateTime(nsdate: NSDate.distantPast as NSDate)

    /// Singleton, lazy created
    public static let MaxValue : DateTime = DateTime(nsdate: NSDate.distantFuture as NSDate)

    public convenience init(_ year: Int, _ month: Int, _ day: Int, _ kind: DateTimeKind = .Local, _ weekStarts: DayOfWeeks = .Sunday) {
        self.init(year: year, month: month, day: day, kind: kind, weekStarts: weekStarts)
    }
    
    public init(nsdate: NSDate, kind: DateTimeKind = .Utc, weekStarts: DayOfWeeks = .Sunday) {
        _weekStarts = weekStarts
        Timezone = DateTime.dateTimeKindToTimeZone(kind)
        _date = nsdate
        _kind = kind
    }

    public convenience init(date: Date, kind: DateTimeKind = .Utc, weekStarts: DayOfWeeks = .Sunday)
    {
        self.init(nsdate: date as NSDate)
    }
    
    public convenience init(interval: Double, kind: DateTimeKind = .Local, weekStarts: DayOfWeeks = .Sunday) {
        self.init(interval: interval, kind: kind, intervalSince: 0, weekStarts: weekStarts)
    }

    public convenience init(epoch: Double, kind: DateTimeKind = .Local, weekStarts: DayOfWeeks = .Sunday) {
        self.init(interval: epoch, kind: kind, intervalSince: DateTime.SECONDS_BETWEEN_REFERENCEZERO_AND_EPOCHZERO, weekStarts: weekStarts)
    }
    
    public convenience init(ldap: Int64, kind: DateTimeKind = .Local, weekStarts: DayOfWeeks = .Sunday) {
        self.init(ticks: ldap, kind: kind, interval: DateTime.SECONDS_BETWEEN_REFERENCEZERO_AND_LDAPZERO, weekStarts: weekStarts)
    }

    public convenience init(ticks: Int64, kind: DateTimeKind = .Local, weekStarts: DayOfWeeks = .Sunday) {
        self.init(ticks: ticks, kind: kind, interval: DateTime.SECONDS_BETWEEN_REFERENCEZERO_AND_DTZERO, weekStarts: weekStarts)
    }
    
    private init(interval: Double, kind: DateTimeKind, intervalSince: Double, weekStarts: DayOfWeeks) {
        _weekStarts = weekStarts
        Timezone = DateTime.dateTimeKindToTimeZone(kind)
        _date = NSDate(timeIntervalSinceReferenceDate: interval + intervalSince)
        _kind = kind
    }

    private init(ticks: Int64, kind: DateTimeKind, interval: Double, weekStarts: DayOfWeeks) {
        _weekStarts = weekStarts
        Timezone = DateTime.dateTimeKindToTimeZone(kind)
        _date = NSDate(timeIntervalSinceReferenceDate: Double(ticks) / DateTime.LDAP_TICKS_IN_SECOND - interval)
        _kind = kind
    }
        
    /// A signed number indicating the relative values of this instance and value.
    ///
    ///     RETURNS
    ///     Return Value    Description
    ///     Less than zero    This instance is less than value.
    ///     Zero    This instance is equal to value.
    ///     Greater than zero    This instance is greater than value.
    public func CompareTo(_ d : DateTime) -> Int
    {
        if (self < d)
        {
            return -1
        }
        if (self > d)
        {
            return 1
        }
        return 0
    }
    
    public var description: String {
        return ToString("yyyy-MM-dd HH:mm:ss.SSS zzz")
    }

    public var debugDescription: String {
        return description
    }

}

//MARK: PUBLIC DATETIME PROPERTIES

public extension DateTime {
    /// Get the year component of the date
    var Year: Int {
        return Components.year ?? 0
    }
    /// Get the month component of the date
    var Month: Int {
        return Components.month ?? 0
        }
    /// Get the week of the month component of the date
    var WeekOfMonth: Int {
            return Components.weekOfMonth ?? 0
        }
    /// Get the week of the month component of the date
    var WeekOfYear: Int {
            return Components.weekOfYear ?? 0
        }
    /// Get the weekday component of the date
    var Weekday: Int {
            let computedDaysFromWeekStart = (Components.weekday ?? 0 + 1 - self._weekStarts.rawValue) % 7
            return computedDaysFromWeekStart == 0 ? 7 : computedDaysFromWeekStart
        }

    /// Get the weekday ordinal component of the date
    var WeekdayOrdinal: Int {
        return _weekStarts.rawValue
    }
    /// Get the day component of the date
    var Day: Int {
            return Components.day ?? 0
        }
    /// Get the hour component of the date
    var Hour: Int {
            return Components.hour ?? 0
        }
    /// Get the minute component of the date
    var Minute: Int {
            return Components.minute ?? 0
        }
    /// Get the second component of the date
    var Second: Int {
            return Components.second ?? 0
        }
    /// Get the millisecond component of the Date
    var Millisecond: Int {
        return Components.nanosecond  ?? 0 / DateTime.NANOSECONDS_IN_MILLISECOND
    }
    /// Get the era component of the date
    var Era: Int {
        return Components.era ?? 0
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
    var AsNSDate: NSDate {
        return _date
    }

    var AsDate: Date {
        return _date as Date
    }

    /**
    Read-only: the NSDate core type. Returns NSDate.distantPast if conversion unsupported (impossible?)
     - Returns: **copy** NSDate object
    */
    func ToNSDate() -> NSDate {

        return _date.copy() as? NSDate ?? NSDate.distantPast as NSDate
    }

    /**
    Read-only: Fractional seconds  reference, UTC always (**2001-01-01**)
     - Returns: Double in second
    */
    var IntervalUTC: Double {
        return _date.timeIntervalSinceReferenceDate
    }

    /**
     Read-only: Fractional seconds  since epoch zero, UTC always (**1970-01-01**)
     - Returns: Double in second
     */
    var Epoch: Double {
        return _date.timeIntervalSince1970
    }

    /**
     Read-only: In teger LDAP ticks since epoch zero, UTC always (**1601-01-01**)
     - Returns: Double in second
     */
    var LDAP: Int {
        return Int((_date.timeIntervalSinceReferenceDate + DateTime.SECONDS_BETWEEN_REFERENCEZERO_AND_LDAPZERO) * DateTime.LDAP_TICKS_IN_SECOND)
    }

    /**
     Read-only: Integer ticks since fileTime zero, UTC always  (**0001-01-01**)
     - Returns: Int
     */
    var TicksUTC: Int {
        return Int((self.IntervalUTC + DateTime.SECONDS_BETWEEN_REFERENCEZERO_AND_DTZERO) * DateTime.LDAP_TICKS_IN_SECOND)
    }

    /**
     Read-only: Integer ticks since fileTime zero, matching Kind timezone (i.e. local or UTC)  (**0001-01-01**).
     This matches .NET implementation.
     - Returns: Int
     */
    var Ticks: Int64 {
        return Int64((self.IntervalUTC + Double(Timezone.secondsFromGMT(for: _date as Date)) + DateTime.SECONDS_BETWEEN_REFERENCEZERO_AND_DTZERO) * DateTime.LDAP_TICKS_IN_SECOND)
    }

    /**
     Read-only: Returns NSDateComponent belonging to Date
     - Returns: NSDateComponent
     */
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
            return TimeSpan(hours: self.Hour, minutes: self.Minute, seconds: self.Second, milliseconds: self.Millisecond)
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
        let nsdate = calendar.date(from: comp)
        let days = calendar.range(of: .day, in: .month, for: nsdate!)
        return days?.count
    }

    internal func withNewDate(_ date : Date) -> DateTime
    {
        return DateTime(interval: date.timeIntervalSinceReferenceDate, kind: _kind, weekStarts: _weekStarts)
    }
        
    // Why is this needed? DateTime is a struct
//    func copy() -> DateTime {
//        let nsDate: NSDate = self._date.copy() as! NSDate
//        return DateTime(nsdate: nsDate, kind: self._kind, weekStarts: self._weekStarts)
//    }
    
//    mutating func AddMutatingTimeSpan(_ timeSpan: TimeSpan) {
//        self.AddMutatingInterval(timeSpan.Interval)
//    }
    
    /// .NET DateTime scheme: ultimately just add fractional seconds
    func AddTimeSpan(_ timeSpan: TimeSpan) -> DateTime {
        return self.AddInterval(timeSpan.Interval)
    }

    /// Uses Swift Calendar rules.
    func AddComponents(_ components : DateComponents) -> DateTime {
        let date = Components.calendar!.date(byAdding: components, to: _date as Date)
        return self.withNewDate(date!)
    }
    
    /// Uses Swift Calendar rules.
    func AddDaysComponents(_ days: Int) -> DateTime {
        var component = DateComponents()
        component.day = days
        return AddComponents(component)
    }

    /// .NET DateTime scheme: ultimately just add fractional seconds
    func AddDays(_ days: Double) -> DateTime {
        return AddSeconds(days*24*60*60)
    }

    /// .NET DateTime scheme: ultimately just add seconds
    func AddDays(_ days: Int) -> DateTime {
        return AddDays(Double(days))
    }
    
    /// Uses Swift Calendar rules.
    func AddHoursComponent(_ hours: Int) -> DateTime {
        var component = DateComponents()
        component.hour = hours
        return AddComponents(component)
    }

    /// .NET DateTime scheme: ultimately just add fractional seconds
    func AddHours(_ hours: Double) -> DateTime {
        return AddSeconds(hours*60*60)
    }

    /// .NET DateTime scheme: ultimately just add seconds
    func AddHours(_ hours: Int) -> DateTime {
        return AddHours(Double(hours))
    }

    /// Uses Swift Calendar rules.
    func AddMinutesComponent(_ minutes: Int) -> DateTime {
        var component = DateComponents()
        component.minute = minutes
        return AddComponents(component)
    }

    /// .NET DateTime scheme: ultimately just add fractional seconds
    func AddMinutes(_ minutes: Double) -> DateTime {
        return AddSeconds(minutes*60)
    }

    /// .NET DateTime scheme: ultimately just add seconds
    func AddMinutes(_ minutes: Int) -> DateTime {
        return AddMinutes(Double(minutes))
    }

    /// Uses Swift Calendar rules.
    func AddSecondsComponent(_ seconds: Int) -> DateTime {
        var component = DateComponents()
        component.second = seconds
        return AddComponents(component)
    }

    /// Equivalent to AddInterval(): add fractional seconds equivalent to .NET DateTime scheme
    func AddSeconds(_ seconds: Double) -> DateTime {
        return AddInterval(seconds)
    }

    /// Equivalent to AddInterval(): add seconds equivalent to .NET DateTime scheme
    func AddSeconds(_ seconds: Int) -> DateTime {
        return AddSeconds(Double(seconds))
    }

    // Uses Swift Calendar rules.
    func AddMillisecondsComponents(_ milliseconds: Int) -> DateTime {
        var component = DateComponents()
        component.nanosecond = milliseconds * DateTime.NANOSECONDS_IN_MILLISECOND
        return AddComponents(component)
    }

    /// .NET DateTime scheme: ultimately just add fractional seconds
    func AddMilliseconds(_ milliseconds: Double) -> DateTime {
        return AddSeconds(Double(milliseconds)/1000.0)
    }

    /// .NET DateTime scheme: ultimately just add fractional seconds
    func AddMilliseconds(_ milliseconds: Int) -> DateTime {
        return AddMilliseconds(Double(milliseconds))
    }

    /// .NET DateTime scheme: ultimately just add exact seconds
    func AddInterval(_ interval: TimeInterval) -> DateTime {
        let date = self._date.addingTimeInterval(interval)
        return self.withNewDate(date as Date)
    }

    func IsLeapYear() -> Bool {
        return DateTime.IsLeapYear(self.Year)
    }

    static func IsLeapYear(_ year : Int) -> Bool {
        return (( year % 100 != 0)) && (year % 4 == 0) || year % 400 == 0
    }
    
    func IsDaylightSavingTime() -> Bool {
        return Timezone.isDaylightSavingTime(for: _date as Date)
    }
    
    func Equals(_ dateTime: DateTime) -> Bool {
        if (self.IntervalUTC == dateTime.IntervalUTC) {
            return true
        }
        return false
    }
    
    static func Parse(_ dateString: String, _ format: String, _ kind: DateTimeKind = .Local, _ weekStarts: DayOfWeeks = .Sunday) -> DateTime? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = dateTimeKindToTimeZone(kind)
        dateFormatter.dateFormat = format
        if let nsDate = dateFormatter.date(from: dateString) {
            return DateTime(nsdate: nsDate as NSDate, kind: kind, weekStarts: weekStarts)
        }
        return nil
    }
    
    static func Parse(_ dateString: String, _ format: DateTimeFormat, _ kind: DateTimeKind = .Local, _ weekStarts: DayOfWeeks = .Sunday) -> DateTime? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.timeZone = dateTimeKindToTimeZone(kind)
        if let nsDate = dateFormatter.date(from: dateString) {
            return DateTime(nsdate: nsDate as NSDate, kind: kind, weekStarts: weekStarts)
        }
        return nil
    }
    
    func ToString(_ format: DateTimeFormat = .FULL) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.timeZone = Timezone
        return dateFormatter.string(from: _date as Date)
    }
    
    func ToString(_ format: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = format
        dateFormatter.timeZone = Timezone
        return dateFormatter.string(from: _date as Date)
    }
    
    func ToString(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = Timezone
        return dateFormatter.string(from: _date as Date)
    }
    
    func ToUtc() -> DateTime {
        if self._kind == .Utc {
            return self
        } else {
            return DateTime(nsdate: _date, kind: .Utc, weekStarts: _weekStarts)
        }
    }

    func ToUniversalTime() -> DateTime {
        return ToUtc()
    }

    func ToLocalTime() -> DateTime {
        if self._kind == .Local {
            return self
        } else {
            return DateTime(nsdate: _date, kind: .Local, weekStarts: _weekStarts)
        }
    }
    
    private static let DaysTo10000: Int64 = (DaysPer400Years * 25) - 366
    internal static let MinTicks: Int64 = 0
    internal static let MaxTicks: Int64 = (DaysTo10000 * TicksPerDay) - 1
    private static let MaxMillis: Int64 = DaysTo10000 * MillisPerDay
    private static let FileTimeOffset: Int64 = DaysTo1601 * TicksPerDay
    //  The minimum OA date is 0100/01/01 (Note it's year 100).
    //  The maximum OA date is 9999/12/31
    //
    private static let DoubleDateOffset: Int64 = DaysTo1899 * TicksPerDay
    //  All OA dates must be greater than (not >=) OADateMinAsDouble
    //
    private static let OADateMinAsTicks: Int64 = (DaysPer100Years - DaysPerYear) * TicksPerDay
    //  All OA dates must be less than (not <=) OADateMaxAsDouble
    //
    private static let OADateMinAsDouble: Double = -657435.0
    private static let OADateMaxAsDouble: Double = 2958466.0

    private static let TicksPerMillisecond: Int64 = 10000
    private static let TicksPerSecond: Int64 = TicksPerMillisecond * 1000
    private static let TicksPerMinute: Int64 = TicksPerSecond * 60
    private static let TicksPerHour: Int64 = TicksPerMinute * 60
    //  Number of milliseconds per time unit
    //
    private static let TicksPerDay: Int64 = TicksPerHour * 24
    private static let MillisPerSecond: Int64 = 1000
    private static let MillisPerMinute: Int64 = MillisPerSecond * 60
    private static let MillisPerHour: Int64 = MillisPerMinute * 60
    //  Number of days in a non-leap year
    //
    private static let MillisPerDay: Int64 = MillisPerHour * 24
    //  Number of days in 4 years
    //
    private static let DaysPerYear: Int64 = 365
    //  1461
    //  Number of days in 100 years
    //
    private static let DaysPer4Years: Int64 = (DaysPerYear * 4) + 1
    //  36524
    //  Number of days in 400 years
    //
    private static let DaysPer100Years: Int64 = (DaysPer4Years * 25) - 1
    //  146097
    //  Number of days from 1/1/0001 to 12/31/1600
    //
    private static let DaysPer400Years: Int64 = (DaysPer100Years * 4) + 1
    //  584388
    //  Number of days from 1/1/0001 to 12/30/1899
    //
    private static let DaysTo1601: Int64 = DaysPer400Years * 4
    //  Number of days from 1/1/0001 to 12/31/1969
    //
    private static let DaysTo1899: Int64 = ((DaysPer400Years * 4) + (DaysPer100Years * 3)) - 367
    //  719,162
    //  Number of days from 1/1/0001 to 12/31/9999
    //
    internal static let DaysTo1970: Int64 = (DaysPer400Years * 4) + (DaysPer100Years * 3) + (DaysPer4Years * 17) + DaysPerYear
    //  3652059
    //

    // Converts the DateTime instance into an OLE Automation compatible
    //  double date.
    func ToOADate() -> Double {
        return DateTime.TicksToOADate(Ticks)
    }

    // This function is duplicated in COMDateTime.cpp
    private static func TicksToOADate(_ value: Int64) -> Double {
        if value == 0 {
            return 0.0
        }
        //  Returns OleAut's zero'ed date value.
        var value = value
        if value < TicksPerDay {
            value = value + DoubleDateOffset
        }
        //  We could have moved this fix down but we would like to keep the bounds check.
        if value < OADateMinAsTicks {
            fatalError("Arg_OleAutDateInvalid")
        }
        //  Currently, our max date == OA's max date (12/31/9999), so we don't
        //  need an overflow check in that direction.
        var millis: Int64 = (value - DoubleDateOffset) / TicksPerMillisecond
        if millis < 0 {
            let frac: Int64 = millis % MillisPerDay
            if frac != 0 {
                millis = millis - (MillisPerDay + frac) * 2
            }
        }
        return Double(millis) / Double(MillisPerDay)
    }

    func Subtract(_ value : DateTime) -> TimeSpan{
        return TimeSpan(interval: Double(self.IntervalUTC - value.IntervalUTC))
    }
    
    // TODO: add test
    func Subtract(_ value : TimeSpan ) -> DateTime {
        return self.AddInterval(-value.Interval)
   }

    func Add(_ value : TimeSpan ) -> DateTime {
        return self + value
   }

}

//MARK: INTERNAL DATETIME CONSTANTS

internal extension DateTime {
    static let LDAP_TICKS_IN_SECOND: Double = 10000000

    static let NANOSECONDS_IN_MILLISECOND: Int = 1000000

    static let SECONDS_BETWEEN_REFERENCEZERO_AND_DTZERO: Double = 63113904000
    static let SECONDS_BETWEEN_REFERENCEZERO_AND_EPOCHZERO: Double = 978307200
    static let SECONDS_BETWEEN_REFERENCEZERO_AND_LDAPZERO: Double = 12622780800
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
        return DateTime.calendar.date(byAdding: components, to: _date as Date) as NSDate?
    }

    /// Retun timeZone sensitive components
    private var components: DateComponents {
        return DateTime.calendar.dateComponents(DateTime.componentFlags(), from: _date as Date)
    }

    /// Return the NSDateComponents
    private var componentsWithTimeZone: DateComponents {
        let timeZone = DateTime.dateTimeKindToTimeZone(_kind)
        var component = DateTime.calendar.dateComponents(DateTime.componentFlags(), from: _date as Date)
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

    private static let utcTZ = TimeZone(abbreviation: "UTC")!
    
    private static func dateTimeKindToTimeZone(_ kind: DateTimeKind) -> TimeZone {
        if kind == .Utc {
            return utcTZ
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
        return autoreleasepool {
            var calendar = Calendar.current
            calendar.timeZone = self.timeZone!

            return calendar.date(from: self as DateComponents)
        }
    }
}

//MARK: ARITHMETICS OVERLOADS

public func +(left: DateTime, right: TimeSpan) -> DateTime {
    return DateTime(interval: left.IntervalUTC + right.Interval, kind: left.Kind, weekStarts: left.WeekStarts)
}

public func -(left: DateTime, right: TimeSpan) -> DateTime {
    return DateTime(interval: left.IntervalUTC - right.Interval, kind: left.Kind, weekStarts: left.WeekStarts)
}

public func -(lhs: DateTime, rhs: DateTime) -> TimeSpan {
    return lhs.Subtract(rhs)
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
    return (left.IntervalUTC < right.IntervalUTC)
}

public func >(left: DateTime, right: DateTime) -> Bool {
    return (left.IntervalUTC > right.IntervalUTC)
}

public func <=(left: DateTime, right: DateTime) -> Bool {
    return (left.IntervalUTC <= right.IntervalUTC)
}

public func >=(left: DateTime, right: DateTime) -> Bool {
    return (left.IntervalUTC >= right.IntervalUTC)
}

