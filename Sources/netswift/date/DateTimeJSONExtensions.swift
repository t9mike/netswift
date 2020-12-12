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

    func ToUniversalTicks() -> Int
    {
        return self.ToUtc().Ticks
    }

    public func ToJavaScriptTicks() -> Int
    {
        let ticks = self.ToUniversalTicks()
        return DateTime.UniversialTicksToJavaScriptTicks(ticks)
    }

    static func UniversialTicksToJavaScriptTicks(_ universialTicks : Int) -> Int
    {
        let javaScriptTicks = (Int64(universialTicks) - DateTime.InitialJavaScriptDateTicks) / 10000;
        return Int(javaScriptTicks)
    }

    static func JavaScriptTicksToUniversialTicks(_ javaScriptTicks : Int) -> Int
    {
        let ticks = (Int64(javaScriptTicks) * 10000) + InitialJavaScriptDateTicks
        return Int(ticks)
    }

    public static func FromJavaScriptTicks(_ javaScriptTicks : Int) -> DateTime
    {
        let ticks = JavaScriptTicksToUniversialTicks(javaScriptTicks)
        let dateTime = DateTime(ticks: ticks, kind: .Utc, weekStarts:.Sunday)
        return dateTime
    }
}
