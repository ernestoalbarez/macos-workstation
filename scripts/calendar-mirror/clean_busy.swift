import EventKit

let store = EKEventStore()
let targetCalendarName = "Busy Mirror"

store.requestFullAccessToEvents { granted, error in

    if !granted {
        print("Permission denied")
        exit(1)
    }

    let calendars = store.calendars(for: .event)

    guard let target = calendars.first(where: {$0.title == targetCalendarName}) else {
        print("Calendar not found")
        exit(1)
    }

    let farPast = Date(timeIntervalSince1970: 0)
    let farFuture = Date(timeIntervalSinceNow: 60*60*24*365*10)

    let predicate = store.predicateForEvents(withStart: farPast, end: farFuture, calendars: [target])

    let events = store.events(matching: predicate)

    for e in events {
        try? store.remove(e, span: .thisEvent)
    }

    print("Busy Mirror completely cleaned")

    exit(0)
}

RunLoop.main.run()
