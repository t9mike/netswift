//
//  DateTimeTests.swift
//  gsnet
//
//  Created by Gabor Soulavy on 21/11/2015.
//  Copyright © 2015 Gabor Soulavy. All rights reserved.
//

import XCTest
@testable import netswift

class Date_Tests: XCTestCase {


    override func setUp() {
        
        super.setUp()

    }

    override func tearDown() {

        super.tearDown()
    }

    func test_CreateDateTimeWith_Year_Month_Day() {

        let dt: DateTime = DateTime(year: 2001, month: 01, day: 01)
        XCTAssertNotNil(dt as DateTime)
    }

    func test_GetYear_Month_Day_BackFromInit() {
        let year = 2001
        let month = 02
        let day = 03
        let dt: DateTime = DateTime(year: year, month: month, day: day)
        XCTAssertEqual(dt.Year, year)
        XCTAssertEqual(dt.Month, month)
        XCTAssertEqual(dt.Day, day)
    }

    func test_GetFullSetDate() {
        let year = 1994
        let month = 3
        let day = 22
        let hour = 17
        let min = 15
        let sec = 11
        let millisecond = 555
        let dt: DateTime = DateTime(year: year, month: month, day: day, hour: hour, minute: min, second: sec, millisecond: millisecond, kind: .Local)
        XCTAssertEqual(dt.Year, year)
        XCTAssertEqual(dt.Month, month)
        XCTAssertEqual(dt.Day, day)
        XCTAssertEqual(dt.Hour, hour)
        XCTAssertEqual(dt.Minute, min)
        XCTAssertEqual(dt.Second, sec)
        XCTAssertEqual(dt.Millisecond, millisecond)
    }

    func test_GetKindFromDate() {
        let dt: DateTime = DateTime(year: 2001, month: 01, day: 01, kind: .Local)
        XCTAssertEqual(dt.Kind, DateTimeKind.Local)
        let dt2: DateTime = DateTime(year: 2001, month: 02, day: 02, kind: .Utc)
        XCTAssertEqual(dt2.Kind, DateTimeKind.Utc)
        let dt3: DateTime = DateTime(year: 2001, month: 03, day: 04)
        XCTAssertEqual(dt3.Kind, DateTimeKind.Local)
    }

    func test_AsDate() {
        let dt: DateTime = DateTime(year: 2001, month: 02, day: 03)
        XCTAssertNotNil(dt.AsDate as NSDate)
    }

    func test_ToNSDate() {
        let dt: DateTime = DateTime(year: 1255, month: 03, day: 4)
        XCTAssertNotNil(dt.ToNSDate()! as NSDate)
        let dt2: DateTime = DateTime(year: 1244, month: 02, day: 5, kind: .Utc)
        XCTAssertNotNil(dt2.ToNSDate()! as NSDate)
    }

    func test_ToNSDate_Into_New_DateObject_Utc() {
        let dt1: DateTime = DateTime(year: 1266, month: 03, day: 5, kind: .Utc)
        let nsdate: NSDate = dt1.ToNSDate()!
        let dt2: DateTime = DateTime(nsdate: nsdate)
        XCTAssertNotNil(dt2 as DateTime)
    }

    func test_ToNSDate_Into_New_DateObject_Non_Utc() {
        let dt1: DateTime = DateTime(year: 1266, month: 03, day: 5)
        let nsdate: NSDate = dt1.ToNSDate()!
        let dt2: DateTime = DateTime(nsdate: nsdate)
        XCTAssertNotNil(dt2 as DateTime)
    }

    func test_Interval_Reference_Utc() {
        let dt1: DateTime = DateTime(year: 2011, month: 04, day: 1, hour: 0, minute: 0, second: 0, millisecond: 888, kind: .Utc)
        let dt2: DateTime = DateTime(interval: dt1.IntervalUTC, kind: .Utc)
        XCTAssertEqual(dt1.Year, dt2.Year)
        XCTAssertEqual(dt1.Month, dt2.Month)
        XCTAssertEqual(dt1.Day, dt2.Day)
        XCTAssertEqual(dt1.Hour, dt2.Hour)
        XCTAssertEqual(dt1.Minute, dt2.Minute)
        XCTAssertEqual(dt1.Second, dt2.Second)
        XCTAssertEqual(dt1.Millisecond, dt2.Millisecond)
    }

    func test_Interval_Reference_Local() {
        let dt1: DateTime = DateTime(year: 2011, month: 04, day: 4, hour: 11, minute: 22, second: 11, millisecond: 888, kind: .Local)
        let dt2: DateTime = DateTime(interval: dt1.IntervalUTC, kind: .Local)
        XCTAssertEqual(dt1.Year, dt2.Year)
        XCTAssertEqual(dt1.Month, dt2.Month)
        XCTAssertEqual(dt1.Day, dt2.Day)
        XCTAssertEqual(dt1.Hour, dt2.Hour)
        XCTAssertEqual(dt1.Minute, dt2.Minute)
        XCTAssertEqual(dt1.Second, dt2.Second)
        XCTAssertEqual(dt1.Millisecond, dt2.Millisecond)
    }

    func test_InitDtTick_Utc() {
        let dt: DateTime = DateTime(ticks: 618700000000000000, kind: .Utc)
        XCTAssertEqual(dt.Year, 1961)
        XCTAssertEqual(dt.Month, 8)
        XCTAssertEqual(dt.Day, 1)
        XCTAssertEqual(dt.Hour, 23)
        XCTAssertEqual(dt.Minute, 6)
        XCTAssertEqual(dt.Second, 40)
        XCTAssertEqual(dt.Millisecond, 0)
    }

    func test_DtTicks_Prop_Utc() {
        let dt: DateTime = DateTime(year: 1961, month: 8, day: 1, hour: 23, minute: 6, second: 40, millisecond: 0, kind: .Utc)
        XCTAssertEqual(dt.TicksUTC, 618700000000000000)
    }

    // This test only succeeds if runs in Central Time (CST/CDT)
    func test_DtTicks_Prop_Local() {
        let dt: DateTime = DateTime(year: 1961, month: 8, day: 1, hour: 23-5, minute: 6, second: 40, millisecond: 0, kind: .Local)
        XCTAssertEqual(dt.Ticks, 618699820000000000) // Via C# test program
        XCTAssertEqual(dt.TicksUTC, 618700000000000000) // Via C# test program
    }

    func test_InitLDapTick_Utc() {
        let dt: DateTime = DateTime(ldap: 113682993225550000, kind: .Utc)
        XCTAssertEqual(dt.Year, 1961)
        XCTAssertEqual(dt.Month, 4)
        XCTAssertEqual(dt.Day, 1)
        XCTAssertEqual(dt.Hour, 12)
        XCTAssertEqual(dt.Minute, 55)
        XCTAssertEqual(dt.Second, 22)
        XCTAssertEqual(dt.Millisecond, 555)
    }
    
    func test_DateProp() {
        let dt: DateTime = DateTime(year: 1991, month: 06, day: 03, hour: 12, minute: 11, second: 12, kind: .Utc)
        XCTAssertEqual(dt.Hour, 12)
        XCTAssertEqual(dt.Minute, 11)
        XCTAssertEqual(dt.Second, 12)
        
        let dt2 = dt.Date
        XCTAssertEqual(dt2.Hour, 0)
        XCTAssertEqual(dt2.Minute, 0)
        XCTAssertEqual(dt2.Second, 0)
    }

    func test_LDAPTicks_Prop_Utc() {
        let dt = DateTime(year: 1961, month: 04, day: 01, hour: 12, minute: 55, second: 22, millisecond: 555, kind: DateTimeKind.Utc);
        XCTAssertEqual(dt.LDAP, 113682993225550000)
    }
    
    func test_SetFirstDayOfWeekToMonday() {
        let dt = DateTime(year: 1961, month: 04, day: 01, kind: .Utc, weekStarts: .Monday)
        XCTAssertEqual(dt.WeekStarts, DayOfWeeks.Monday)
    }
    
    func test_FirstDayOfWeekDefaultIsSunday() {
        let dt = DateTime(year: 1961, month: 04, day: 01, kind: .Utc)
        XCTAssertEqual(dt.WeekStarts, DayOfWeeks.Sunday)
    }
    
    func test_WeekdayIs2For20151208_WeekStartsWithMonday() {
        let dt = DateTime(year: 2015, month: 12, day: 08, kind: .Utc, weekStarts: .Monday)
        XCTAssertEqual(dt.Weekday, 2)
    }
    
    func test_WeekdayIs2For20151208_WeekStartsWithTuesday() {
        let dt = DateTime(year: 2015, month: 12, day: 08, kind: .Utc, weekStarts: .Tuesday)
        XCTAssertEqual(dt.Weekday, 1)
    }
    
    func test_WeekdayIs3For20151208_WeekStartsDefault() {
        let dt = DateTime(year: 2015, month: 12, day: 08, kind: .Utc)
        XCTAssertEqual(dt.Weekday, 3)
    }
    
    func test_WeekStartProperty() {
        var dt = DateTime(year: 2015, month: 12, day: 08, kind: .Utc)
        XCTAssertEqual(dt.Weekday, 3)
        dt.WeekStarts = .Monday
        XCTAssertEqual(dt.Weekday, 2)
    }
    
    func test_DayOfWeeksReturnsTuesday() {
        let dt = DateTime(year: 2015, month: 12, day: 08, kind: .Utc, weekStarts: .Monday)
        XCTAssertEqual(dt.DayOfWeek, DayOfWeeks.Tuesday)
    }
    
    func test_DayOfWeeksReturnsMonday() {
        let dt = DateTime(year: 2015, month: 12, day: 07, kind: .Utc, weekStarts: .Sunday)
        XCTAssertEqual(dt.DayOfWeek, DayOfWeeks.Monday)
    }
    
    func test_DayOfWeeksReturnsSaturday() {
        let dt = DateTime(year: 2015, month: 12, day: 05, kind: .Utc, weekStarts: .Sunday)
        XCTAssertEqual(dt.DayOfWeek, DayOfWeeks.Saturday)
    }

    func test_DayOfWeeksReturnsSaturday2() {
        let dt = DateTime(year: 2015, month: 12, day: 05, kind: .Utc, weekStarts: .Monday)
        XCTAssertEqual(dt.DayOfWeek, DayOfWeeks.Saturday)
    }
    
    func test_DayOfYearReturns342() {
        let dt = DateTime(year: 2015, month: 12, day: 08, kind: .Utc, weekStarts: .Monday)
        XCTAssertEqual(dt.DayOfYear, 342)
    }
    
    func test_DayOfYearReturns184() {
        let dt = DateTime(year: 1991, month: 07, day: 03, kind: .Utc)
        XCTAssertEqual(dt.DayOfYear, 184)
    }
    
    func test_TimeOfDay() {
        let dt = DateTime(year: 2001, month: 12, day: 5, hour: 16, minute: 42, second: 11, millisecond: 500, kind: .Local)
        let ts = dt.TimeOfDay
        XCTAssertEqual(dt.Hour, Int(ts.Hours))
        XCTAssertEqual(dt.Minute, Int(ts.Minutes))
        XCTAssertEqual(dt.Second, Int(ts.Seconds))
        XCTAssertEqual(dt.Millisecond, Int(ts.Milliseconds))
        
    }
    
    func test_AddTimeSpan() {
        let dt = DateTime(year: 2001, month: 12, day: 5, hour: 16, minute: 42, second: 11, millisecond: 500, kind: .Local)
        let ts = TimeSpan(days: 1, hours: 1)
        let dt2 = dt.AddTimeSpan(ts)
        XCTAssertEqual(dt2.Year, 2001)
        XCTAssertEqual(dt2.Month, 12)
        XCTAssertEqual(dt2.Day, 6)
        XCTAssertEqual(dt.Day, 5)
        XCTAssertEqual(dt2.Hour, 17)
        XCTAssertEqual(dt.Hour, 16)
    }
        
    func test_AddDays() {
        let interval = TimeSpan(days: 1).Interval
        let dt = DateTime(year: 2001, month: 12, day: 5, hour: 16, minute: 42, second: 11, millisecond: 500, kind: .Utc)
        let originalInterval = dt.IntervalUTC
                
        let dt2 = dt.AddDaysComponents(1)
        XCTAssertEqual(originalInterval, dt2.IntervalUTC - interval)
        XCTAssertEqual(dt2.Year, 2001)
        XCTAssertEqual(dt2.Month, 12)
        XCTAssertEqual(dt2.Day, 6)
        XCTAssertEqual(dt2.Hour, 16)
        XCTAssertEqual(dt2.Minute, 42)
        XCTAssertEqual(dt2.Second, 11)
        XCTAssertEqual(dt2.Millisecond, 500)
        
        // TODO: this shows issue with adding nanoseconds to date now working
        var c = DateComponents()
//        c.second = 86400
        c.nanosecond = 86400 * Int(1e9)
        let d3 = NSCalendar.current.date(byAdding: c, to: dt.ToNSDate()! as Date)
        print(dt.ToNSDate()!)
        print(d3!)        
    }
    
    func test_AddHours() {
        let interval = TimeSpan(hours: 1).Interval
        let dt = DateTime(year: 2001, month: 12, day: 5, hour: 16, minute: 42, second: 11, millisecond: 500, kind: .Utc)
        let originalInterval = dt.IntervalUTC
        let dt2 = dt.AddHoursComponent(1)
        XCTAssertEqual(originalInterval, dt2.IntervalUTC - interval)
        XCTAssertEqual(dt2.Year, 2001)
        XCTAssertEqual(dt2.Month, 12)
        XCTAssertEqual(dt2.Day, 5)
        XCTAssertEqual(dt2.Hour, 17)
        XCTAssertEqual(dt2.Minute, 42)
        XCTAssertEqual(dt2.Second, 11)
        XCTAssertEqual(dt2.Millisecond, 500)
    }
    
    func test_AddMinutes() {
        let interval = TimeSpan(minutes: 1).Interval
        let dt = DateTime(year: 2001, month: 12, day: 5, hour: 16, minute: 42, second: 11, millisecond: 500, kind: .Utc)
        let originalInterval = dt.IntervalUTC
        let dt2 = dt.AddMinutesComponent(1)
        XCTAssertEqual(originalInterval, dt2.IntervalUTC - interval)
        XCTAssertEqual(dt2.Year, 2001)
        XCTAssertEqual(dt2.Month, 12)
        XCTAssertEqual(dt2.Day, 5)
        XCTAssertEqual(dt2.Hour, 16)
        XCTAssertEqual(dt2.Minute, 43)
        XCTAssertEqual(dt2.Second, 11)
        XCTAssertEqual(dt2.Millisecond, 500)
    }
        
    func test_AddSeconds() {
        let interval = TimeSpan(seconds: 47).Interval
        let dt = DateTime(year: 2001, month: 12, day: 5, hour: 16, minute: 42, second: 11, millisecond: 500, kind: .Utc)
        let originalInterval = dt.IntervalUTC
        let dt2 = dt.AddSecondsComponent(47)
        XCTAssertEqual(originalInterval, dt2.IntervalUTC - interval)
        XCTAssertEqual(dt2.Year, 2001)
        XCTAssertEqual(dt2.Month, 12)
        XCTAssertEqual(dt2.Day, 5)
        XCTAssertEqual(dt2.Hour, 16)
        XCTAssertEqual(dt2.Minute, 42)
        XCTAssertEqual(dt2.Second, 58)
        XCTAssertEqual(dt2.Millisecond, 500)
    }
        
    func test_AddMilliseconds() {
        let dt = DateTime(year: 2001, month: 12, day: 5, hour: 16, minute: 42, second: 11, millisecond: 500, kind: .Utc)
        let originalInterval = dt.IntervalUTC
        let dt2 = dt.AddMillisecondsComponents(500)
        XCTAssertEqual(originalInterval, dt2.IntervalUTC - 0.5)
        XCTAssertEqual(dt2.Year, 2001)
        XCTAssertEqual(dt2.Month, 12)
        XCTAssertEqual(dt2.Day, 5)
        XCTAssertEqual(dt2.Hour, 16)
        XCTAssertEqual(dt2.Minute, 42)
        XCTAssertEqual(dt2.Second, 12)
        XCTAssertEqual(dt2.Millisecond, 0)
    }
    
    func test_AddInterval() {
        let dt = DateTime(year: 2001, month: 12, day: 5, hour: 16, minute: 42, second: 11, millisecond: 500, kind: .Local)
        let ts = TimeSpan(days: 1, hours: 1)
        let dt2 = dt.AddInterval(ts.Interval)
        XCTAssertEqual(dt.IntervalUTC, dt2.IntervalUTC - ts.Interval)
        XCTAssertEqual(dt2.Year, 2001)
        XCTAssertEqual(dt2.Month, 12)
        XCTAssertEqual(dt2.Day, 6)
        XCTAssertEqual(dt.Day, 5)
        XCTAssertEqual(dt2.Hour, 17)
        XCTAssertEqual(dt.Hour, 16)
    }
    
    func test_IsLeapYear() {
        let dt = DateTime(year: 2001, kind: .Utc)
        XCTAssertEqual(dt.IsLeapYear(), false)
        let dt2 = DateTime(year: 2008, kind: .Utc)
        XCTAssertEqual(dt2.IsLeapYear(), true)
    }
    
    func test_IsDaylightSavingTime() {
        let dt = DateTime(year: 2015, month: 6, day: 12, kind: .Local)
        XCTAssertEqual(dt.IsDaylightSavingTime(), true)
        let dt2 = DateTime(year: 2015, month: 2, day: 12, kind: .Local)
        XCTAssertEqual(dt2.IsDaylightSavingTime(), false)
        let dt3 = DateTime(year: 2015, month: 6, day: 12, kind: .Utc)
        XCTAssertEqual(dt3.IsDaylightSavingTime(), false)
    }
    
    func test_Equals() {
        let dt1 = DateTime(year: 2015, month: 6, day: 12, hour: 14, minute: 22, kind: .Local, weekStarts: .Monday)
        let dt2 = DateTime(year: 2015, month: 6, day: 12, hour: 14, minute: 22, kind: .Local, weekStarts: .Monday)
        let dt3 = DateTime(year: 2015, month: 6, day: 12, hour: 14, minute: 21, kind: .Local, weekStarts: .Monday)
        let dt4 = DateTime(year: 2015, month: 6, day: 12, hour: 14, minute: 22, kind: .Utc, weekStarts: .Monday)
        let dt5 = DateTime(year: 2015, month: 6, day: 12, hour: 13, minute: 22, kind: .Utc, weekStarts: .Monday)
        XCTAssertTrue(dt1.Equals(dt2))
        XCTAssertFalse(dt1.Equals(dt3))
        XCTAssertFalse(dt1.Equals(dt4))
        XCTAssertFalse(dt1.Equals(dt5))
    }
    
    func test_ParseValid() {
        let dt = DateTime.Parse("2015-12-08", "yyyy-MM-dd")
        XCTAssertEqual(dt?.Year, 2015)
        XCTAssertEqual(dt?.Month, 12)
        XCTAssertEqual(dt?.Day, 8)
    }
    
    func test_ParseInvalid() {
        let dt = DateTime.Parse("sd", "yyyy-MM-dd")
        XCTAssertNil(dt)
    }
    
    func test_ParseValidUtc() {
        let dt = DateTime.Parse("2015-12-08", "yyyy-MM-dd", .Utc)
        XCTAssertEqual(dt?.Year, 2015)
        XCTAssertEqual(dt?.Month, 12)
        XCTAssertEqual(dt?.Day, 8)
        XCTAssertEqual(dt?.Kind, .Utc)
    }
    
    func test_ParseValidLocal() {
        let dt = DateTime.Parse("2015-12-08", "yyyy-MM-dd", .Local)
        XCTAssertEqual(dt?.Year, 2015)
        XCTAssertEqual(dt?.Month, 12)
        XCTAssertEqual(dt?.Day, 8)
        XCTAssertEqual(dt?.Kind, .Local)
    }
    
    func test_ParseValidSummerLocal() {
        let dt = DateTime.Parse("2015-05-08", "yyyy-MM-dd", .Local)
        XCTAssertEqual(dt?.Year, 2015)
        XCTAssertEqual(dt?.Month, 05)
        XCTAssertEqual(dt?.Day, 8)
        XCTAssertEqual(dt?.Kind, .Local)
    }
    
    func test_ToString() {
        let dt = DateTime(year: 1999, month: 12, day: 1, hour: 15, minute: 44, second: 23, millisecond: 500, kind: .Local, weekStarts: .Monday)
        XCTAssertEqual(dt.ToString(.FULL), "1999-12-01 15:44:23.500")
        XCTAssertEqual(dt.ToString(.LONG), "1999-12-01 15:44:23")
        XCTAssertEqual(dt.ToString(.LongDate), "01. December, 1999.")
        XCTAssertEqual(dt.ToString(.MediumDate), "01. Dec, 1999.")
        XCTAssertEqual(dt.ToString(.MediumDateA), "Dec 01, 1999.")
        XCTAssertEqual(dt.ToString(.MediumTime), "3:44:23 PM")
        XCTAssertEqual(dt.ToString(.MediumTimeM), "15:44:23")
        XCTAssertEqual(dt.ToString(.ShortDate), "01/12/99")
        XCTAssertEqual(dt.ToString(.ShortTime), "3:44 PM")
        XCTAssertEqual(dt.ToString(.ShortTimeM), "15:44")
    }
    
    func test_ToStringDefault() {
        let dt = DateTime(year: 1999, month: 12, day: 1, hour: 15, minute: 44, second: 23, millisecond: 500, kind: .Local, weekStarts: .Monday)
        XCTAssertEqual(dt.ToString(), "1999-12-01 15:44:23.500")
    }

    // This test only succeeds if runs in Central Time (CST/CDT)
    func test_ToStringCustom1() {
        let dt = DateTime(year: 1999, month: 12, day: 1, hour: 15, minute: 44, second: 23, millisecond: 500, kind: .Local, weekStarts: .Monday)
        XCTAssertEqual(dt.ToString("EEE, yyyy/MM/dd hh:mm:ss a zzz"), "Wed, 1999/12/01 03:44:23 PM CST")
    }

    // This test only succeeds if runs in Central Time (CST/CDT)
    func test_ToStringCustom2() {
        let dt = DateTime(year: 2020, month: 6, day: 15, hour: 1, minute: 44, second: 23, millisecond: 500, kind: .Local, weekStarts: .Monday)
        XCTAssertEqual(dt.ToString("EEE, yyyy/MM/dd hh:mm:ss a zzz"), "Mon, 2020/06/15 01:44:23 AM CDT")
    }

    // This test only succeeds if runs in Central Time (CST/CDT)
    func test_ToUtc() {
        let local = DateTime(year: 2001, month: 05, day: 7, hour: 14, minute: 44, second: 23, kind: .Local, weekStarts: .Monday)
        let utc = local.ToUtc()
        XCTAssertEqual(local.Hour, utc.Hour - 5)
    }

    // This test only succeeds if runs in Central Time (CST/CDT)
    func test_ToLocal() {
        let utc = DateTime(year: 2001, month: 05, day: 7, hour: 14, minute: 44, second: 23, kind: .Utc, weekStarts: .Monday)
        let local = utc.ToLocalTime()
        XCTAssertEqual(utc.Hour, local.Hour + 5)
    }
    
    func test_LocalToLocal() {
        let local1 = DateTime(year: 2001, month: 05, day: 7, hour: 14, minute: 44, second: 23, kind: .Local, weekStarts: .Monday)
        let local2 = local1.ToLocalTime()
        XCTAssertEqual(local1.Hour, local2.Hour)
    }
    
    func test_UtcTOUtc() {
        let utc1 = DateTime(year: 2001, month: 05, day: 7, hour: 14, minute: 44, second: 23, kind: .Utc, weekStarts: .Monday)
        let utc2 = utc1.ToUtc()
        XCTAssertEqual(utc1.Hour, utc2.Hour)
    }
    
    // This test only succeeds if runs in Central Time (CST/CDT)
    func test_Equatable() {
        let utc = DateTime(year: 2001, month: 05, day: 7, hour: 15+5, minute: 44, second: 23, kind: .Utc, weekStarts: .Monday)
        let local = DateTime(year: 2001, month: 05, day: 7, hour: 15, minute: 44, second: 23, kind: .Local, weekStarts: .Monday)
        let local2 = DateTime(year: 2001, month: 05, day: 7, hour: 16, minute: 44, second: 23, kind: .Local, weekStarts: .Monday)
        XCTAssertTrue(utc == local)
        XCTAssertTrue(local != local2)
        XCTAssertTrue(local2 > local)
    }

    func test_TOADate() {
        let local = DateTime(year: 2020, month: 10, day: 31, hour: 14, minute: 0, second: 0, kind: .Local)
        let oadate = local.ToOADate()
        let expected = 4.4135583333333336E4 // Via C# test program
        XCTAssertTrue(oadate == expected)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
