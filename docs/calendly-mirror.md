## Calendly Busy Mirror

### Problem

When working with multiple **corporate calendars**, those calendars often do **not allow external integrations** such as publishing events or sharing availability with third‑party tools.

However, the **macOS Calendar application** can still access those events locally because the accounts are configured in the system.

The problem is that **Calendly** only reads availability from calendars that are directly connected to it (for example a personal Google account). As a result, Calendly may show time slots as available even when there are meetings in corporate calendars.

### Solution

This project creates a **"Busy Mirror" calendar** connected to the personal Google account used by Calendly.

A local script reads events from all calendars available in the macOS Calendar app and mirrors the occupied time blocks into the "Busy Mirror" calendar.

Calendly then reads availability from this mirrored calendar, preventing scheduling conflicts.

### Architecture

The workflow works as follows:

1. Calendly reads availability from the **"Busy Mirror" calendar**.
2. Calendly creates new meetings in the **personal Google calendar**.
3. The Google account owns both:
   - the personal calendar
   - the **Busy Mirror** calendar
4. All **corporate calendars** are connected to the macOS Calendar application.
5. The **Google account** is also connected to the macOS Calendar application.
6. A local script reads all events from the macOS Calendar database using EventKit.
7. The script mirrors occupied time blocks into the **Busy Mirror** calendar.

### Script Behavior

The script runs automatically (via `launchd`) and performs the following tasks:

1. Reads all events from calendars available in the macOS Calendar app
2. Ignores specific calendars such as holidays or birthdays
3. Ignores all‑day events
4. Adds **buffer time before and after meetings**
5. Merges consecutive or overlapping events into a **single busy block**
6. Avoids creating duplicate events
7. Writes the resulting busy blocks to the **Busy Mirror calendar**

Example:

```
10:00 – 10:30 Standup
10:30 – 11:00 Grooming
```

With buffer and merge logic:

```
09:50 – 11:10 Busy
```

### Benefits

- Prevents scheduling conflicts in Calendly
- Works with restricted corporate calendars
- Requires **no integration permissions** from corporate systems
- Runs locally and automatically

### Technologies Used

- macOS Calendar
- EventKit (Apple calendar API)
- Swift
- launchd automation

### Notes

The **Busy Mirror calendar does not need to be visible** in the Calendar UI. It only needs to exist so the script can write events and Calendly can read them.

---

## Calendar Busy Mirror Setup

This script mirrors busy events from all calendars configured in the macOS Calendar application into a dedicated calendar used by Calendly.

This avoids scheduling conflicts when corporate calendars cannot be integrated directly with Calendly.

---

### Requirements

- macOS
- Calendar accounts configured in macOS
- Swift installed (comes with Xcode command line tools)

Install command line tools:
```bash
xcode-select --install
```

### Step 1 — Create Busy Mirror calendar

Open personal calendar and create a new calendar named:
```bash
Busy Mirror
```
This calendar must be connected to the same account used by Calendly.

### Step 2 — Compile the script

Navigate to the script directory:
```bash
cd scripts/calendar-mirror
```

Compile the Swift script:
```bash
swiftc busy_mirror.swift -o busy_mirror
```

### Step 3 — Install LaunchAgent

Copy the LaunchAgent configuration:
```bash
cp busy.mirror.plist ~/Library/LaunchAgents/
```

Load the agent:
```bash
launchctl load ~/Library/LaunchAgents/busy.mirror.plist
```

### Step 4 — Verify

Check if the job is running:
```bash
launchctl list | grep busy
```

You should see:
```bash
busy.mirror
```

The script will now run every 5 minutes.

### Logs
Output logs:
```bash
tail -f /tmp/busy_mirror.log
```

Error logs:
```bash
tail -f /tmp/busy_mirror.error.log
```

### How it works
1.	Reads events from all calendars configured in macOS
2.	Excludes holidays and birthdays
3.	Adds buffer time before and after meetings
4.	Merges overlapping events
5.	Writes busy blocks to the Busy Mirror calendar

Calendly reads availability from this mirror calendar.
