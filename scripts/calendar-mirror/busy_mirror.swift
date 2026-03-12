import EventKit

let store = EKEventStore()

let targetCalendarName = "Busy Mirror"

let excluded = [
"Birthdays",
"Cumpleaños",
"United States Holidays",
"Holidays in Argentina",
]

let bufferMinutes = 10
let buffer: TimeInterval = TimeInterval(bufferMinutes * 60)

store.requestFullAccessToEvents { granted, error in

    if !granted {
        print("Calendar permission denied")
        exit(1)
    }

    let calendars = store.calendars(for: .event)

    guard let target = calendars.first(where: { $0.title == targetCalendarName }) else {
        print("Busy Mirror calendar not found")
        exit(1)
    }

    let now = Date()
    let future = Calendar.current.date(byAdding: .day, value: 14, to: now)!

    /*
     STEP 1
     Leer Busy existentes
    */

    let existingPredicate = store.predicateForEvents(withStart: now, end: future, calendars: [target])
    let existingBusy = store.events(matching: existingPredicate)

    var busyIndex = Set<String>()

    for e in existingBusy {
        if e.title == "Busy" {
            let key = "\(e.startDate.timeIntervalSince1970)-\(e.endDate.timeIntervalSince1970)"
            busyIndex.insert(key)
        }
    }

    /*
     STEP 2
     Leer eventos reales
    */

    let sourceCalendars = calendars.filter {
        $0.title != targetCalendarName && !excluded.contains($0.title)
    }

    let predicate = store.predicateForEvents(withStart: now, end: future, calendars: sourceCalendars)
    let events = store.events(matching: predicate)

    /*
     STEP 3
     Crear bloques ocupados con buffer
    */

    var blocks: [(Date, Date)] = []

    for e in events {

        if e.isAllDay { continue }

        if e.availability == .free { continue }

        var start = e.startDate.addingTimeInterval(-buffer)
        let end = e.endDate.addingTimeInterval(buffer)

        if start < now {
            start = now
        }

        blocks.append((start, end))
    }

    /*
     STEP 4
     Ordenar bloques
    */

    blocks.sort { $0.0 < $1.0 }

    /*
     STEP 5
     Fusionar bloques contiguos
    */

    var merged: [(Date, Date)] = []

    for block in blocks {

        if merged.isEmpty {
            merged.append(block)
            continue
        }

        var last = merged.removeLast()

        if block.0 <= last.1 {
            last.1 = max(last.1, block.1)
            merged.append(last)
        } else {
            merged.append(last)
            merged.append(block)
        }
    }

    /*
     STEP 6
     Crear Busy si no existe
    */

    var created = 0

    for block in merged {

        let key = "\(block.0.timeIntervalSince1970)-\(block.1.timeIntervalSince1970)"

        if busyIndex.contains(key) {
            continue
        }

        let busy = EKEvent(eventStore: store)

        busy.calendar = target
        busy.title = "Busy"
        busy.startDate = block.0
        busy.endDate = block.1

        try? store.save(busy, span: .thisEvent)

        created += 1
    }

    print("Busy mirror updated (\(created) blocks created)")

    exit(0)
}

RunLoop.main.run()

