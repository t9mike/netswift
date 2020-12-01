//
//  File.swift
//  
//
//  Created by Michael S. Muegel on 11/29/20.
//

import Foundation

extension DateTime
{
    static let InitialJavaScriptDateTicks = 621355968000000000

    func ToUniversalTicks() -> Int
    {
        return self.ToUtc().Ticks
    }

    public func ToJavaScriptTicks() -> Int
    {
        let ticks = self.ToUniversalTicks()
        return DateTime.UniversialTicksToJavaScriptTicks(ticks);
    }

    static func UniversialTicksToJavaScriptTicks(_ universialTicks : Int) -> Int
    {
        let javaScriptTicks = (universialTicks - DateTime.InitialJavaScriptDateTicks) / 10000;
        return javaScriptTicks;
    }

    static func JavaScriptTicksToUniversialTicks(_ javaScriptTicks : Int) -> Int
    {
        let ticks = (javaScriptTicks * 10000) + InitialJavaScriptDateTicks
        return ticks;
    }

    public static func FromJavaScriptTicks(_ javaScriptTicks : Int) -> DateTime
    {
        let ticks = JavaScriptTicksToUniversialTicks(javaScriptTicks)
        let dateTime = DateTime(ticks: ticks, kind: .Utc, weekStarts:.Sunday)
        return dateTime;
    }
}
