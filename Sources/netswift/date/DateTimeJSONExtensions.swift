//
//  File.swift
//  
//
//  Created by Michael S. Muegel on 11/29/20.
//

import Foundation

extension DateTime
{
    // The JavaScript Date type's origin is the Unix epoch: midnight on 1 January 1970.
    // The .NET DateTime type's origin is midnight on 1 January 0001.
    static let InitialJavaScriptDateTicks : Int64 = 621355968000000000

    func ToUniversalTicks() -> Int64
    {
        return self.ToUtc().Ticks
    }

    public func ToJavaScriptTicks() -> Int64
    {
        let ticks = self.ToUniversalTicks()
        return DateTime.UniversialTicksToJavaScriptTicks(ticks)
    }

    static func UniversialTicksToJavaScriptTicks(_ universialTicks : Int64) -> Int64
    {
        let javaScriptTicks = (Int64(universialTicks) - DateTime.InitialJavaScriptDateTicks) / 10000;
        return Int64(javaScriptTicks)
    }

    static func JavaScriptTicksToUniversialTicks(_ javaScriptTicks : Int64) -> Int64
    {
        let ticks = (Int64(javaScriptTicks) * 10000) + InitialJavaScriptDateTicks
        return Int64(ticks)
    }

    public static func FromJavaScriptTicks(_ javaScriptTicks : Int64) -> DateTime
    {
        let ticks = JavaScriptTicksToUniversialTicks(javaScriptTicks)
        let dateTime = DateTime(ticks: ticks, kind: .Utc, weekStarts:.Sunday)
        return dateTime
    }
}
