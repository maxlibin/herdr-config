// Prints the next (or current) timed calendar event within 24 hours for the
// herdr tab bar, e.g. "📅 Standup in 12m", "📅 Standup now", "📅 Lunch 13:30".
// Prints nothing when the day ahead is free. Exits non-zero without access.
import EventKit
import Foundation

let store = EKEventStore()
let granted = DispatchSemaphore(value: 0)
var hasAccess = false
store.requestFullAccessToEvents { ok, error in
    hasAccess = ok
    if let error = error { FileHandle.standardError.write("calendar access error: \(error)\n".data(using: .utf8)!) }
    granted.signal()
}
granted.wait()
guard hasAccess else {
    FileHandle.standardError.write("calendar access denied: allow it in System Settings > Privacy & Security > Calendars\n".data(using: .utf8)!)
    exit(1)
}

let now = Date()
let predicate = store.predicateForEvents(withStart: now, end: now.addingTimeInterval(24 * 3600), calendars: nil)
let upcoming = store.events(matching: predicate)
    .filter { !$0.isAllDay && $0.endDate > now && $0.status != .canceled }
    .sorted { $0.startDate < $1.startDate }

guard let event = upcoming.first else { exit(0) }

let title = (event.title ?? "Busy").trimmingCharacters(in: .whitespacesAndNewlines)
let shortTitle = title.count > 24 ? String(title.prefix(23)) + "…" : title
let minutes = Int(event.startDate.timeIntervalSince(now) / 60)
let when: String
if minutes <= 0 {
    when = "now"
} else if minutes < 60 {
    when = "in \(minutes)m"
} else {
    let formatter = DateFormatter()
    formatter.dateFormat = Calendar.current.isDateInToday(event.startDate) ? "HH:mm" : "EEE HH:mm"
    when = formatter.string(from: event.startDate)
}
print("📅 \(shortTitle) \(when)")
