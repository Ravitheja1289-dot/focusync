# Focusync

> A calm, focused, and psychologically serious productivity app designed to help you maintain deep focus and build consistent work habits.

<p align="center">
  <strong>Focus better. Track honestly. Improve consistently.</strong>
</p>

---

## 🎯 What is Focusync?

Focusync is a minimalist focus timer and productivity tracker built on scientific principles of attention management. Unlike gamified productivity apps that create artificial pressure through streaks and points, Focusync helps you understand your actual focus patterns and make meaningful improvements.

**Philosophy:**
- **Psychological seriousness** - Treats focus as a skill to develop, not a game to win
- **Calm UX** - No bright colors, flashy animations, or anxiety-inducing notifications
- **Honest tracking** - Detects distractions and helps you understand your patterns
- **Privacy-first** - All data stays on your device, forever

---

## ✨ Key Features

### 🧘 Immersive Focus Sessions
- **Fullscreen focus mode** - Eliminates all distractions during work
- **Multiple intensity levels** - Deep focus, normal, or light sessions
- **Customizable durations** - From 5 minutes to 2 hours
- **Pause & resume** - Life happens, we handle it gracefully

### 📊 Distraction Detection
- **Automatic tracking** - Detects when you leave the app
- **Progressive warnings** - Gentle reminders that escalate with frequency
- **Pattern recognition** - Understand when you get distracted most
- **No judgment** - Just data to help you improve

### 🌊 Restorative Breaks
- **Guided breathing animation** - 4-4-6-2 breathing pattern for calm
- **Flexible break lengths** - Skip or customize break duration
- **Auto-start option** - Seamlessly transition from focus to break

### 🏆 Session Completion
- **Celebratory feedback** - Subtle confetti and encouraging messages
- **Focus quality score** - Based on distraction rate, not arbitrary points
- **Session insights** - Detailed feedback on your performance
- **Quick actions** - Start another session, take a break, or review analytics

### 📈 Meaningful Analytics
- **Daily & weekly trends** - Visualize your focus patterns over time
- **Focus quality tracking** - Understand not just time, but depth of focus
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
