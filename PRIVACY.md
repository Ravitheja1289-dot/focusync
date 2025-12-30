# Privacy Policy

**Last Updated: December 31, 2025**

## Our Commitment

Focusync is built with privacy as the foundation. We believe your focus patterns, work habits, and productivity data are deeply personal and should remain under your complete control.

## What We Collect

**Nothing.**

Seriously. Focusync does not collect, transmit, or store any of your data on external servers. Everything stays on your device.

## What Focusync Tracks Locally

The app stores the following data **only on your device**:

- **Focus sessions**: Start time, duration, session mode
- **Distraction events**: Count and timestamps when you left the app
- **Break sessions**: Duration and completion status
- **Settings**: Your preferences for notifications, sounds, and default durations

This data is stored using Flutter's local storage (Isar database) and never leaves your device.

## What We Don't Track

- ❌ **No personally identifiable information** - No name, email, or account data
- ❌ **No usage analytics** - We don't know which features you use
- ❌ **No crash reports** - We don't get notified when the app crashes
- ❌ **No device information** - We don't know what phone you use
- ❌ **No location data** - We never access your GPS or location
- ❌ **No contact list** - We don't touch your contacts
- ❌ **No camera or microphone** - We never access these permissions
- ❌ **No app switching data** - We detect when you leave, but not where you go

## How Distraction Detection Works

When you start a focus session, Focusync monitors the app lifecycle to detect when you switch to another app. This is done using Flutter's built-in `AppLifecycleState` API.

**What we know:** You left the Focusync app during a focus session  
**What we don't know:** Which app you switched to, what you did there, or anything else

The detection is purely for counting distractions and calculating your focus quality score. No information about what distracted you is ever recorded.

## Your Data Rights

### You Own Your Data
- All data is stored locally on your device
- You can export all your data as JSON anytime
- You can delete all data with one tap in settings
- No backup is made without your explicit action

### Data Portability
Use the "Export Data" feature in settings to download a JSON file containing:
- All focus sessions with timestamps and durations
- Distraction counts per session
- Break session history
- Your settings preferences

You can use this data however you want: import it elsewhere, analyze it yourself, or just keep it as a record.

### Right to Delete
The "Clear All Data" button in settings permanently removes all session history, analytics, and preferences from your device. This action cannot be undone, and we cannot recover your data because we never had it.

## Third-Party Services

**We use none.**

Focusync has:
- No analytics SDKs (Firebase, Mixpanel, etc.)
- No crash reporting services (Sentry, Crashlytics, etc.)
- No ad networks
- No social media integrations
- No cloud storage providers
- No authentication services

The only third-party code in Focusync is open-source Flutter packages (Riverpod for state management, go_router for navigation, Isar for local storage). These packages run entirely on your device and don't communicate with external servers.

## Future Changes

If we ever introduce optional cloud sync in the future:
- It will be **completely optional** - Default will remain local-only
- It will use **zero-knowledge encryption** - We won't be able to read your data even if we wanted to
- We will update this privacy policy clearly and notify users
- You can delete your cloud data anytime or revert to local-only

We will never introduce:
- Mandatory accounts
- Data selling or sharing
- Third-party analytics
- Advertising

## Children's Privacy

Focusync does not collect any data from anyone, including children under 13. Since we don't collect data at all, we are compliant with COPPA and similar regulations worldwide.

## International Users

Because all data stays on your device, Focusync automatically complies with:
- **GDPR** (European Union)
- **CCPA** (California)
- **PIPEDA** (Canada)
- **LGPD** (Brazil)
- And other privacy regulations worldwide

There's no data to protect, process, or delete on our end because we never have it.

## Security

While we don't have servers to secure, we take security seriously:

- **Local storage encryption**: Isar database uses platform-provided encryption when available
- **No network requests**: The app doesn't make any HTTP requests
- **Minimal permissions**: We only request notification permissions (optional)
- **Open source**: Our code is auditable by anyone

## Changes to This Policy

We will update this privacy policy if we add any features that change how data is handled. When we do:
- We'll update the "Last Updated" date
- We'll notify users in the app
- We'll maintain old versions in our GitHub repository for transparency

## Contact Us

If you have questions about this privacy policy:

- **GitHub Issues**: [https://github.com/yourusername/focusync/issues](https://github.com/yourusername/focusync/issues)
- **Email**: privacy@focusync.app

---

## The Bottom Line

**Focusync doesn't collect your data because we don't want it.**

We built this app because we wanted a focus timer that respects privacy. The best way to protect your data is to never collect it in the first place.

Your focus patterns are yours. Your productivity data is yours. Your improvement journey is yours.

We're just here to help you track it, on your device, under your control, forever.
