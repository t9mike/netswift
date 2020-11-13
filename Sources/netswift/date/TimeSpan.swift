//
//  TimeSpan.swift
//  gsnet
//
//  Created by Gabor Soulavy on 20/11/2015.
//  Copyright © 2015 Gabor Soulavy. All rights reserved.
//

import Foundation

public struct TimeSpan : CustomStringConvertible
{
    public private(set) var Interval : TimeInterval = 0
    private var _days: Int = 0
    private var _hours: Int = 0
    private var _minutes: Int = 0
    private var _seconds: Int = 0
    private var _milliseconds: Int = 0
    private var _nanoseconds: Int = 0
    
    public var description: String
    {
        var tos = ""
        if Interval < 0 {
            tos += "-"
        }
        if Days != 0 {
            tos += String(Days.magnitude)
            tos += "."
        }
        tos += "\(String(format: "%02", Hours.magnitude)):\(String(format: "%02", Minutes.magnitude)):\(String(format: "%02", Seconds.magnitude))"
        if Milliseconds != 0 {
            tos += "." + String(format: "%3", Milliseconds.magnitude);
        }
        return tos
    }
    
    public init(interval: TimeInterval){
        self.popullateUnits(interval: interval)
    }
    
    // With this initializer, days=1.1 would mean 1.1*24*60*60 seconds, etc.
    public init(days: Double = 0, hours: Double = 0, minutes: Double = 0, seconds: Double = 0, milliseconds: Double = 0, nanoseconds: Double = 0){
        self.popullateUnits(interval: getSecondsFromUnits(days: days, hours: hours, minutes: minutes, seconds: seconds, milliseconds: milliseconds, nanoseconds: nanoseconds))
    }

    public init(days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0, milliseconds: Int = 0, nanoseconds: Int = 0){
        self.popullateUnits(interval: getSecondsFromUnits(days: Double(days), hours: Double(hours), minutes: Double(minutes), seconds: Double(seconds), milliseconds: Double(milliseconds), nanoseconds: Double(nanoseconds)))
    }

    public func Absolute() -> TimeSpan {
        return TimeSpan(interval: Math.Abs(Interval))
    }

    public static var Zero : TimeSpan {
        return TimeSpan(interval: 0)
    }
}

//MARK: TIMESPAN READONLY PROPERTIES

extension TimeSpan {
    
    public var Days: Int {
        return _days
    }
    
    public var Hours: Int {
        return _hours
    }
    
    public var Minutes: Int {
        return _minutes
    }
    
    public var Seconds: Int {
        return _seconds
    }
    
    public var Milliseconds: Int {
        return _milliseconds
    }
    
    public var Nanoseconds: Int {
        return _nanoseconds
    }
        
    public var TotalSeconds: Double {
        return self.Interval
    }
    
    public var TotalMinutes: Double {
        return self.Interval / TimeSpan.INTERVALS_IN_MINUTE
    }
    
    public var TotalHours: Double {
        return self.Interval / TimeSpan.INTERVALS_IN_HOUR
    }
    
    public var TotalDays: Double {
        return self.Interval / TimeSpan.INTERVALS_IN_DAY
    }
}

//MARK: TIMESPAN INSTANCE METHODS

extension TimeSpan {
    public func Add(_ timeSpan: TimeSpan) -> TimeSpan {
        return TimeSpan(interval: self.Interval + timeSpan.Interval)
    }
    
    
    public func Duration() -> TimeSpan {
        return TimeSpan(interval: Math.Abs(self.Interval))
    }
    
    public func Negate() -> TimeSpan {
        return TimeSpan(interval: self.Interval * -1)
    }
    
    public func Subtruct(_ timeSpan: TimeSpan) -> TimeSpan {
        return TimeSpan(interval: self.Interval - timeSpan.Interval)
    }
}

//MARK: TIMESPAN STATIC METHODS

extension TimeSpan {
    public static func FromTicks(_ ticks : Int) -> TimeSpan {
        return TimeSpan(interval: Double(ticks))
    }

    public static func FromDays(_ days: Double) -> TimeSpan {
        return TimeSpan(days: days)
    }
    
    public static func FromHours(_ hours: Double) -> TimeSpan {
        return TimeSpan(hours: hours)
    }
    
    public static func FromMinutes(_ minutes: Double) -> TimeSpan {
        return TimeSpan(minutes: minutes)
    }
    
    public static func FromSeconds(_ seconds: Double) -> TimeSpan {
        return TimeSpan(seconds: seconds)
    }

    public static func FromMilliseconds(_ milliseconds: Double) -> TimeSpan {
        return TimeSpan(milliseconds: milliseconds)
    }

    public static func FromInterval(_ interval: TimeInterval) -> TimeSpan {
        return TimeSpan(interval: interval)
    }
    
    public static func Parse(_ interval: String) -> TimeSpan? {
        if let ticks = Double(interval) {
            return TimeSpan(interval: ticks)
        } else {
            return nil
        }
    }
}

//MARK: TIMESPAN MUTATING METHODS

extension TimeSpan {

}

//MARK: TIMESPAN CONSTANTS

extension TimeSpan {
    internal static let NANOSECONDS_IN_MILLISECOND: Double = 1000000
    internal static let MILLISECONDS_IN_SECOND: Double = 1000
    internal static let SECONDS_IN_MINUTE: Double = 60
    internal static let MINUTES_IN_HOUR: Double = 60
    internal static let HOURS_IN_DAY: Double = 24
    
    // Swift time spans are in Interval = fractional seconds
    static let INTERVALS_IN_SECOND: Double = 1
    static let INTERVALS_IN_MINUTE: Double = TimeSpan.INTERVALS_IN_SECOND * TimeSpan.SECONDS_IN_MINUTE
    static let INTERVALS_IN_HOUR: Double = TimeSpan.INTERVALS_IN_MINUTE * TimeSpan.MINUTES_IN_HOUR
    static let INTERVALS_IN_DAY: Double = TimeSpan.INTERVALS_IN_HOUR * TimeSpan.HOURS_IN_DAY
    static let INTERVALS_IN_MILLISECOND: Double = TimeSpan.INTERVALS_IN_SECOND / TimeSpan.MILLISECONDS_IN_SECOND
    static let INTERVALS_IN_NANOSECOND: Double = TimeSpan.INTERVALS_IN_MILLISECOND / TimeSpan.NANOSECONDS_IN_MILLISECOND
}

//MARK: PRIVATE TIMESPAN HELPER METHODS

private extension TimeSpan {
    private static func GetUnitsAndReminder(_ value: Double, devisionUnit: Double) -> (whole:Int, reminder:Double) {
        let whole = Int(trunc(value / devisionUnit))
        let reminder = value % devisionUnit
        return (whole, reminder)
    }
    
    private mutating func popullateUnits(interval: Double) {
        Interval = interval;
        let days = TimeSpan.GetUnitsAndReminder(interval, devisionUnit: TimeSpan.INTERVALS_IN_DAY)
        _days = days.whole
        let hours = TimeSpan.GetUnitsAndReminder(days.reminder, devisionUnit: TimeSpan.INTERVALS_IN_HOUR)
        _hours = hours.whole
        let minutes = TimeSpan.GetUnitsAndReminder(hours.reminder, devisionUnit: TimeSpan.INTERVALS_IN_MINUTE)
        _minutes = minutes.whole
        let seconds = TimeSpan.GetUnitsAndReminder(minutes.reminder, devisionUnit: TimeSpan.INTERVALS_IN_SECOND)
        _seconds = seconds.whole
        let milliseconds = TimeSpan.GetUnitsAndReminder(seconds.reminder, devisionUnit: TimeSpan.INTERVALS_IN_MILLISECOND)
        _milliseconds = milliseconds.whole
        let nanoseconds = TimeSpan.GetUnitsAndReminder(milliseconds.reminder, devisionUnit: TimeSpan.INTERVALS_IN_NANOSECOND)
        _nanoseconds = nanoseconds.whole
    }
    
    private func getSecondsFromUnits(days: Double = 0, hours: Double = 0, minutes: Double = 0, seconds: Double = 0, milliseconds: Double = 0, nanoseconds: Double = 0) -> Double {
        return days * TimeSpan.INTERVALS_IN_DAY
            + hours * TimeSpan.INTERVALS_IN_HOUR
            + minutes * TimeSpan.INTERVALS_IN_MINUTE
            + seconds * TimeSpan.INTERVALS_IN_SECOND
            + milliseconds * TimeSpan.INTERVALS_IN_MILLISECOND
            + nanoseconds * TimeSpan.INTERVALS_IN_NANOSECOND
    }
}

//MARK: ARITHMETICS OVERLOADS

public func +(left: TimeSpan, right: TimeSpan) -> TimeSpan {
    return TimeSpan(interval: left.Interval + right.Interval)
}

public func -(left: TimeSpan, right: TimeSpan) -> TimeSpan {
    return TimeSpan(interval: left.Interval - right.Interval)
}

public func *(left: TimeSpan, right: Double) -> TimeSpan {
    return TimeSpan(interval: left.Interval * right)
}

public func *(left: Double, right: TimeSpan) -> TimeSpan {
    return TimeSpan(interval: left * right.Interval)
}

public func /(left: TimeSpan, right: TimeSpan) -> Double {
    return Double(left.Interval / right.Interval)
}

public func /(left: TimeSpan, right: Double) -> TimeSpan {
    return TimeSpan(interval: left.Interval / right)
}

//MARK: EQUATABLE IMPLEMENTATION
extension TimeSpan : Equatable {}

public func ==(left: TimeSpan, right: TimeSpan) -> Bool {
    return (left.Interval == right.Interval)
}

public func !=(left: TimeSpan, right: TimeSpan) -> Bool {
    return !(left.Interval == right.Interval)
}

//MARK: COMPARABLE IMPLEMENTATION
extension TimeSpan: Comparable {}

public func <(left: TimeSpan, right: TimeSpan) -> Bool {
    return (left.Interval < right.Interval)
}

public func >(left: TimeSpan, right: TimeSpan) -> Bool {
    return (left.Interval > right.Interval)
}

public func <=(left: TimeSpan, right: TimeSpan) -> Bool {
    return (left.Interval <= right.Interval)
}

public func >=(left: TimeSpan, right: TimeSpan) -> Bool {
    return (left.Interval >= right.Interval)
}

//MARK: ARITHMENTICS

prefix func -(timeSpan: TimeSpan) -> TimeSpan {
    return TimeSpan(interval: -timeSpan.Interval)
}

public func +=( left: inout TimeSpan, right: TimeSpan) {
    left = left + right
}

public func -=(left: inout TimeSpan, right: TimeSpan) {
    left = left - right
}

public func *=(left: inout TimeSpan, right: Double) {
    left = left * right
}

public func /=(left: inout TimeSpan, right: Double) {
    left = left / right
}
