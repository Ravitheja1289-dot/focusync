# Focusync

A minimal focus timer built with Flutter. Calm interface, honest tracking, no gamification.

---

## Visual Preview

Screenshots will be added here once the app reaches visual stability.

---

## Why This App Exists

Most productivity apps fail because they optimize for engagement instead of actual work. They add points, streaks, leaderboards, and artificial urgency. The result is another distraction disguised as a tool.

Focusync takes a different approach. It removes everything unnecessary and focuses on what matters: helping you understand your attention patterns and improve them over time. No tricks, no dopamine manipulation, no false productivity theater.

If you want an app that respects your intelligence and your time, this is it.

---

## Core Features

**Focus sessions** - Start a timer with clear state transitions. Running, paused, or completed. No ambiguity.

**Quick start durations** - 15, 25, 45 minutes, or custom. Pick one and start immediately.

**Distraction detection** - Tracks when you leave the app during active sessions. Honest data, no judgment.

**Minimal analytics** - Shows total time, session count, and focus quality trends. Nothing more, nothing less.

**Settings** - Control default durations, notification behavior, and theme preferences.

**Account management** - Planned for data portability and cross-device sync. Privacy-respecting by design.

**Offline-first** - Everything works without internet. Data stays on your device.

---

## UX and Product Philosophy

The interface is deliberately minimal. Black, white, and shades of indigo. No bright colors competing for attention.

Each screen has one primary action. When you're on the home screen, you start a session. When you're in a session, you focus. When the session ends, you see results. No nested menus, no hidden features, no confusion.

Visual elements serve clarity, not decoration. Animations exist only when they communicate state changes. Nothing moves just to look modern.

This design creates calm, not dopamine hits. The app gets out of your way so you can do your work.

---

## Architecture and Technical Decisions

The codebase follows a feature-based structure. Each feature owns its domain logic, presentation layer, and state management. No circular dependencies, no hidden coupling.

UI components never contain business logic. They receive state, display it, and emit events. State management lives in dedicated controllers that handle transitions, validation, and side effects.

Services like local storage and notifications are treated as infrastructure. Features depend on interfaces, not implementations. This keeps the architecture flexible and testable.

The separation between what the app does and how it does it is intentional. Business logic can be understood without reading UI code. UI can be changed without touching session management.

See [ARCHITECTURE_DIAGRAM.md](ARCHITECTURE_DIAGRAM.md) for detailed flow diagrams and component relationships.

---

## Analytics Philosophy

The analytics screen shows consistency, not vanity metrics.

It tracks total focused time, session count, average focus quality, and weekly trends. These numbers tell you if you're getting better at sustained attention.

It does not track:
- Productivity scores based on arbitrary formulas
- Leaderboards or social comparisons
- AI-generated insights that restate obvious patterns
- Gamification points that encourage gaming the system

The goal is understanding, not optimization theater. If you see a drop in focus quality, you know something changed. If you see consistency over weeks, you know the habit is working. That's enough.

---

## Settings and Account Design

Settings are minimal but powerful. Default session durations, notification preferences, theme selection. Everything you need, nothing you don't.

The Account tab represents identity and control. It's where you manage data export, account deletion, and eventually cross-device sync. The philosophy is simple: you own your data, and you decide what happens to it.

No dark patterns, no hidden data collection, no surprise charges. Just clear controls and honest communication about what the app does with your information.

---

## What's Intentionally Not Included

**Social features** - Sharing sessions or competing with friends creates pressure to perform for an audience instead of focusing on actual work.

**Leaderboards** - Ranking users encourages gaming the system and comparing yourself to others instead of improving on your own terms.

**AI productivity scores** - Algorithmic judgments about productivity are often pseudoscientific and create anxiety without actionable insights.

**Heavy animations** - Flashy transitions and motion effects distract from the core experience and drain battery life.

**Push notification spam** - Constant reminders and encouragement messages become noise. The app respects your attention instead of demanding it.

These exclusions aren't oversights. They're design decisions that make the product better by subtraction.

---

## Tech Stack

- Flutter (cross-platform mobile framework)
- Riverpod (state management with selective rebuilds)
- GoRouter (declarative navigation)
- Isar (local database for session persistence)
- Material Design 3 (dark-first theme system)

Architecture follows Clean Architecture principles with feature-based organization.

---

## Project Status and Roadmap

This is an active project focused on building a solid foundation before adding new features.

Current focus: core session management, distraction detection reliability, and analytics accuracy.

Planned improvements: local data persistence with Isar, account system for data portability, cross-device sync with privacy-preserving backend.

Development is intentionally iterative. Features ship when they're ready, not on arbitrary deadlines.

---

## Getting Started

Clone the repository:
```bash
git clone https://github.com/yourusername/focusync.git
cd focusync
```

Install dependencies:
```bash
flutter pub get
```

Run the app:
```bash
flutter run
```

No backend configuration required. Everything runs locally.

---

## Security and Privacy Notes

No API keys or secrets are committed to this repository. Environment variables are used for any external service configuration.

User data never leaves the device unless explicitly exported by the user. No analytics tracking, no crash reporting that phones home, no hidden telemetry.

When cross-device sync is implemented, it will be end-to-end encrypted with user-controlled keys. Your data remains yours.

---

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

Built with intention. Maintained with care
- **Consistency streaks** - Track consecutive days of focused work
- **Actionable insights** - Specific suggestions based on your data

**No vanity metrics:**
- ❌ No lifetime totals that make you feel bad
- ❌ No leaderboards or social comparison
- ❌ No arbitrary badges or achievements
- ✅ Just meaningful data for personal growth

### ⚙️ Thoughtful Settings
- **Focus rules** - Auto-start breaks, default durations
- **Notification preferences** - Control when and how you're alerted
- **Sound options** - Optional ticking sounds, completion chimes
- **Data controls** - Export your data anytime, delete everything if needed

---

## 🔒 Privacy & Data

### Your Data Stays Yours
- **100% local storage** - All session data stored on your device using Isar database
- **No cloud sync** - We don't have servers to store your data
- **No accounts required** - Use the app without giving us your email
- **No analytics tracking** - We don't know how you use the app
- **No third-party SDKs** - No hidden trackers or ad networks

### What We Track (Locally)
- Focus session durations and timestamps
- Distraction counts and patterns
- Break session completion
- Focus quality scores

### What You Can Do
- **Export your data** - Get a JSON file of all your sessions anytime
- **Delete everything** - One tap to clear all data permanently
- **No backup required** - It's just a focus timer, start fresh anytime

---

## 🚀 Getting Started

### Requirements
- Flutter 3.x or higher
- Dart 3.10.4 or higher
- iOS 12+ / Android 6.0+ / macOS 10.14+ / Windows 10+ / Linux

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/focusync.git
cd focusync

# Install dependencies
flutter pub get

# Run on your device
flutter run
```

### Building for Production

```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release

# macOS
flutter build macos --release

# Windows
flutter build windows --release

# Linux
flutter build linux --release

# Web
flutter build web --release
```

---

## 🏗️ Architecture

Focusync is built with clean architecture principles:

```
lib/
├── core/              # Shared utilities, themes, widgets
│   ├── theme/        # Design system (colors, typography, spacing)
│   ├── router/       # Navigation configuration
│   └── widgets/      # Reusable components
├── features/         # Feature modules
│   ├── focus_session/
│   │   ├── domain/      # Entities, use cases
│   │   ├── data/        # Repositories, data sources
│   │   └── presentation/ # UI, providers, screens
│   ├── analytics/
│   ├── settings/
│   └── home/
└── main.dart
```

### Tech Stack
- **Framework:** Flutter 3.x
- **State Management:** Riverpod 2.6.1
- **Navigation:** go_router 14.8.1
- **Local Storage:** Isar (planned)
- **Architecture:** Clean Architecture + Feature-first structure

---

## 🎨 Design System

### Color Palette
- **Primary:** Indigo 500 (#6366F1) - Calm, focused, professional
- **Background:** Slate 950 (#020617) - Deep, distraction-free
- **Accents:** Purple, Blue, Green (quality indicators)

### Typography
- **Headings:** SF Pro Display / Segoe UI
- **Body:** System default for optimal readability
- **Sizes:** 11px (caption) → 32px (h1)

### Motion
- **Animations:** 200-800ms with easing curves
- **No jarring transitions** - Everything fades and slides smoothly
- **Performance:** 60fps on all devices

---

## 🗺️ Roadmap

### Version 1.0 (Current - December 2025)
- [x] Core focus timer functionality
- [x] Distraction detection and tracking
- [x] Breathing animation for breaks
- [x] Session completion celebration
- [x] Focus analytics dashboard
- [x] Settings screen
- [x] Performance optimizations

### Version 1.1 (Q1 2026)
- [ ] **Persistent storage** - Save sessions with Isar database
- [ ] **Real analytics** - Calculate actual metrics from stored data
- [ ] **Session history** - Browse past sessions in detail
- [ ] **Custom session presets** - Save your favorite configurations
- [ ] **Home screen widgets** - Quick glance at today's focus time

### Version 1.2 (Q2 2026)
- [ ] **Focus modes expansion** - Pomodoro, 52-17, custom patterns
- [ ] **Break variety** - Stretching guides, meditation prompts
- [ ] **Smart scheduling** - Suggested focus times based on patterns
- [ ] **Weekly reports** - Detailed insights delivered Sunday evening
- [ ] **Ambient sounds** - Optional white noise, nature sounds

### Version 2.0 (Q3 2026)
- [ ] **Optional encrypted sync** - Cross-device with zero-knowledge encryption
- [ ] **Desktop integration** - System-level distraction blocking
- [ ] **Calendar integration** - Sync with Google/Apple Calendar
- [ ] **Focus zones** - Location-based automatic session starts
- [ ] **Advanced analytics** - Correlation with time of day, day of week

### Community Requests
- [ ] Dark/light theme toggle (currently dark only)
- [ ] Custom color schemes
- [ ] Multiple timer presets
- [ ] CSV export format
- [ ] Backup/restore functionality

**Note:** Roadmap is subject to change based on user feedback and technical feasibility.

---

## 🤝 Contributing

Contributions are welcome! Please read our contributing guidelines before submitting PRs.

### Development Setup

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes
4. Run tests: `flutter test`
5. Check formatting: `flutter format .`
6. Analyze code: `flutter analyze`
7. Commit: `git commit -m 'Add amazing feature'`
8. Push: `git push origin feature/amazing-feature`
9. Open a Pull Request

### Code Style
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Use `const` constructors wherever possible
- Keep widgets small and focused
- Write tests for business logic
- Document complex algorithms

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

### Inspiration
- **Deep Work** by Cal Newport
- **Atomic Habits** by James Clear
- **Indistractable** by Nir Eyal

### Design Influence
- Apple's Human Interface Guidelines
- Material Design 3
- Calm Technology principles

### Open Source Dependencies
- Flutter team for the amazing framework
- Riverpod for elegant state management
- go_router for declarative navigation
- Isar for blazing-fast local storage

---

## 📞 Contact & Support

- **Issues:** [GitHub Issues](https://github.com/yourusername/focusync/issues)
- **Discussions:** [GitHub Discussions](https://github.com/yourusername/focusync/discussions)
- **Email:** support@focusync.app

### FAQ

**Q: Why no cloud sync?**  
A: Privacy first. Your focus patterns are personal data. We don't want to store it, secure it, or be responsible for it. Local-first means you're in control.

**Q: Will there be a paid version?**  
A: No plans for premium features. If we add optional sync in the future, we'll use an ethical, privacy-focused service and keep it affordable.

**Q: Can I use this for Pomodoro technique?**  
A: Yes! Set 25-minute focus sessions with 5-minute breaks. We'll add Pomodoro presets in v1.1.

**Q: Does it work offline?**  
A: Yes, completely. Since there's no cloud, offline is the only mode.

**Q: How do you detect distractions?**  
A: We use Flutter's app lifecycle detection to know when you switch apps. We don't know *what* you switched to (privacy), just that you left Focusync.

**Q: Will this help me focus better?**  
A: It's a tool, not magic. It helps you become aware of your focus patterns and build consistency. The actual focus work is still up to you.

---

## 🌟 Why Focusync?

Because you deserve a productivity app that:
- **Respects your privacy** instead of selling your data
- **Helps you improve** instead of making you feel guilty
- **Stays calm** instead of creating anxiety
- **Focuses on what matters** instead of gamifying everything
- **Works for you** instead of trying to hook you

**Focus better. Track honestly. Improve consistently.**

---

<p align="center">
  Made with 🧘 for anyone who wants to work with intention
</p>

<p align="center">
  <a href="https://github.com/yourusername/focusync/stargazers">⭐ Star us on GitHub</a>
</p>
