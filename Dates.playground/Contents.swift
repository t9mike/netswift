import UIKit

//let d1 = Date.init()

var c = DateComponents()
c.year = 1967
c.month = 5
c.day = 1
c.timeZone = TimeZone(identifier: "CDT")
c.hour = 14
c.minute = 00
let d1 = Calendar.current.date(from: c)!

// Adding large nanoseconds does not work as of Xcode 12.1 / iOS14
// Assuming this: https://stackoverflow.com/questions/43797129/why-are-my-simple-date-calculations-sometimes-failing-in-swift-3-1
// https://stackoverflow.com/questions/54187364/result-of-adding-second-to-date-is-one-minute-off-workaround
var c2 = DateComponents()
c2.second = 86400
//c2.nanosecond = 86400 * Int(1e9) // Should be equivalennt but is not
let d2 = NSCalendar.current.date(byAdding: c2, to: d1)!

print(d1)
print(d2)


c = DateComponents()
c.year = 2020
c.month = 10
c.day = 31
c.timeZone = TimeZone(identifier: "CDT")
c.hour = 14
c.minute = 00
let baseDate = Calendar.current.date(from: c)!
logDate("Base date           ", baseDate)

c = DateComponents()
c.second = 86400
var d = NSCalendar.current.date(byAdding: c, to: baseDate)!
logDate("Add 1 day of seconds", d)

c = DateComponents()
c.day = 1
d = NSCalendar.current.date(byAdding: c, to: baseDate)!
logDate("Add 1 day           ", d)

func logDate(_ what : String, _ date : Date)
{
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .long
//    formatter.timeZone = TimeZone.current
    let localDate = formatter.string(from: date)
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    let gmtDate = formatter.string(from: date)
    print("\(what): \(localDate) / \(gmtDate)")
}
