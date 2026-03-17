import EventKit

let store = EKEventStore()

let targetCalendarName = "Busy Mirror"

let excluded = [
"Birthdays",
"Cumpleaños",
"United States Holidays",
"Holidays in Argentina",
"Días festivos de España",
"Ratitas 2.0"
]

let bufferMinutes = 10
let buffer: TimeInterval = TimeInterval(bufferMinutes * 60)

func isBusinessTime(_ start: Date, _ end: Date) -> Bool {

    let cal = Calendar.current
    let weekday = cal.component(.weekday, from: start)

    // domingo o sábado
    if weekday == 1 || weekday == 7 {
        return false
    }

    let hourStart = cal.component(.hour, from: start)
    let hourEnd = cal.component(.hour, from: end)

    if hourStart < 9 || hourEnd > 18 {
        return false
    }

    return true
}

func mergeBusyBlocks(_ blocks: [(Date, Date)]) -> [(Date, Date)] {

    if blocks.isEmpty { return [] }

    let sorted = blocks.sorted { $0.0 < $1.0 }

    var merged: [(Date, Date)] = []
    var current = sorted[0]

    for block in sorted.dropFirst() {

        if block.0 <= current.1 {
            current.1 = max(current.1, block.1)
        } else {
            merged.append(current)
            current = block
        }
    }

    merged.append(current)

    return merged
}

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
     Obtener eventos reales
    */

    let sourceCalendars = calendars.filter {
        $0.title != targetCalendarName && !excluded.contains($0.title)
    }

    let predicate = store.predicateForEvents(
        withStart: now,
        end: future,
        calendars: sourceCalendars
    )

    let events = store.events(matching: predicate)

    /*
     STEP 2
     Generar bloques busy
    */

    var busyBlocks: [(Date, Date)] = []

    for event in events {

        if event.isAllDay { continue }

        let busyStart = event.startDate.addingTimeInterval(-buffer)
        let busyEnd = event.endDate.addingTimeInterval(buffer)

        if !isBusinessTime(busyStart, busyEnd) {
            continue
        }

        busyBlocks.append((busyStart, busyEnd))
    }

    /*
     STEP 3
     Merge de bloques
    */

    let mergedBlocks = mergeBusyBlocks(busyBlocks)

    /*
     STEP 4
     Eliminar Busy antiguos generados por el script
    */

    let existingPredicate = store.predicateForEvents(
        withStart: now,
        end: future,
        calendars: [target]
    )

    let existingBusy = store.events(matching: existingPredicate)

    for e in existingBusy {

        if e.notes == "busy-mirror" {

            do {
                try store.remove(e, span: .thisEvent)
            } catch {
                print("Error removing old busy event")
            }
        }
    }

    /*
     STEP 5
     Crear nuevos Busy
    */

    for block in mergedBlocks {

        let busy = EKEvent(eventStore: store)

        busy.calendar = target
        busy.title = "Busy"
        busy.startDate = block.0
        busy.endDate = block.1
        busy.isAllDay = false
        busy.notes = "busy-mirror"

        do {
            try store.save(busy, span: .thisEvent)
            print("Busy block created \(block.0) - \(block.1)")
        } catch {
            print("Error creating busy block")
        }
    }

    print("Busy mirror sync finished")

    exit(0)
}

RunLoop.main.run()

