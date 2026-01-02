# Focusync Architecture Diagram

## 🏗️ High-Level Architecture

```mermaid
graph TB
    subgraph "Presentation Layer"
        UI[Screens & Widgets]
        Providers[Riverpod Providers]
        Router[GoRouter Navigation]
    end
    
    subgraph "Domain Layer"
        Entities[Business Entities]
        Logic[Business Logic]
    end
    
    subgraph "Core Systems"
        Theme[Theme System]
        Widgets[Reusable Widgets]
        Utils[Utilities]
    end
    
    subgraph "Platform"
        Local[Local Storage<br/>Isar DB]
        System[System APIs<br/>Lifecycle]
    end
    
    UI --> Providers
    Providers --> Entities
    Providers --> Logic
    UI --> Router
    UI --> Theme
    UI --> Widgets
    Providers --> Local
    Providers --> System
    
    style UI fill:#818cf8
    style Providers fill:#6366f1
    style Entities fill:#4f46e5
    style Local fill:#312e81
```

## 📱 Feature Module Structure

```mermaid
graph LR
    subgraph "Feature Module (Clean Architecture)"
        direction TB
        Domain[Domain Layer<br/>📦 entities/]
        Presentation[Presentation Layer<br/>🎨 screens/<br/>🧩 widgets/<br/>⚡ providers/]
        
        Domain --> Presentation
    end
    
    style Domain fill:#4f46e5
    style Presentation fill:#818cf8
```

## 🔄 State Management Flow (Riverpod)

```mermaid
sequenceDiagram
    participant UI as UI Widget
    participant Provider as StateNotifierProvider
    participant Controller as SessionController
    participant State as SessionState
    participant Storage as Local Storage
    
    UI->>Provider: ref.watch(provider.select())
    Provider->>Controller: Listen to state
    Controller->>State: Emit new state
    State-->>UI: Rebuild (selective)
    
    UI->>Provider: ref.read().action()
    Provider->>Controller: Execute action
    Controller->>Controller: Update business logic
    Controller->>Storage: Persist data
    Controller->>State: Emit new state
    State-->>UI: Rebuild
```

## 🎯 Session Lifecycle Flow

```mermaid
stateDiagram-v2
    [*] --> SessionIdle
    
    SessionIdle --> SessionActive: startSession()
    
    state SessionActive {
        [*] --> Running
        Running --> Paused: pauseSession()
        Paused --> Running: resumeSession()
        Running --> Completed: Timer expires
        
        Running --> DistractionDetected: App backgrounded
        DistractionDetected --> Running: App resumed
    }
    
    SessionActive --> SessionIdle: completeSession()
    SessionActive --> SessionIdle: cancelSession()
    
    note right of SessionActive
        Tracks:
        - Duration
        - Distractions
        - Focus quality
        - Elapsed time
    end note
```

## 🗺️ Navigation Architecture

```mermaid
graph TD
    Splash[Splash Screen<br/>/] --> Home[Home Screen<br/>/home]
    
    Home --> Session[Focus Session<br/>/session]
    Home --> Analytics[Analytics<br/>/analytics]
    Home --> Settings[Settings<br/>/settings]
    Home --> Account[Account<br/>/account]
    
    Session --> SessionActive[Active Session<br/>Full Screen]
    Session --> SessionComplete[Completion Screen<br/>Modal]
    
    Settings --> SettingsDetail[Setting Details]
    
    Analytics --> AnalyticsDetail[Detailed Stats]
    
    style Splash fill:#312e81
    style Home fill:#4f46e5
    style Session fill:#6366f1
    style SessionActive fill:#818cf8
```

## 🏛️ Core Features Architecture

```mermaid
graph TB
    subgraph "🏠 Home Feature"
        HomeScreen[Home Screen]
        QuickActions[Quick Actions]
        RecentSessions[Recent Sessions]
    end
    
    subgraph "⏱️ Focus Session Feature"
        SessionScreen[Session Screen]
        SessionController[Session Controller]
        SessionEntity[Session Entity]
        CircularTimer[Circular Timer Widget]
        DistractionDetector[Distraction Detector]
        
        SessionController --> SessionEntity
        SessionScreen --> CircularTimer
        SessionController --> DistractionDetector
    end
    
    subgraph "📊 Analytics Feature"
        AnalyticsScreen[Analytics Screen]
        StatsCalculator[Stats Calculator]
        Charts[Chart Widgets]
        
        AnalyticsScreen --> Charts
        AnalyticsScreen --> StatsCalculator
    end
    
    subgraph "⚙️ Settings Feature"
        SettingsScreen[Settings Screen]
        ThemeToggle[Theme Toggle]
        Preferences[User Preferences]
    end
    
    HomeScreen --> SessionScreen
    HomeScreen --> AnalyticsScreen
    HomeScreen --> SettingsScreen
    
    SessionController --> StatsCalculator
    
    style SessionController fill:#6366f1
    style SessionEntity fill:#4f46e5
    style DistractionDetector fill:#ef4444
```

## 🎨 Theme & Design System Flow

```mermaid
graph LR
    AppTheme[AppTheme<br/>app_theme.dart] --> Colors[AppColors<br/>Slate & Indigo]
    AppTheme --> Typography[AppTextStyles<br/>Display, Title, Body]
    AppTheme --> Spacing[AppSpacing<br/>Padding, Radius]
    
    Colors --> DarkTheme[Dark Theme<br/>Primary]
    Colors --> LightTheme[Light Theme<br/>Secondary]
    
    DarkTheme --> Screens
    Typography --> Screens
    Spacing --> Screens
    
    Screens[All Screens]
    
    style AppTheme fill:#4f46e5
    style Colors fill:#6366f1
    style Typography fill:#818cf8
    style Spacing fill:#a5b4fc
```

## ⚡ Performance Optimization Layers

```mermaid
graph TD
    subgraph "Build Optimization"
        Const[const Constructors]
        InitState[Pre-calculation in initState]
        NoCompute[No computation in build]
    end
    
    subgraph "State Optimization"
        Select[Provider .select]
        Selective[Selective Watching]
        Immutable[Immutable State]
    end
    
    subgraph "Animation Optimization"
        PreCalc[Pre-calculated Delays]
        Cache[Cached Paint Elements]
        DidUpdate[didUpdateWidget Checks]
    end
    
    Const --> FastRebuild[Fast Rebuilds]
    Select --> FastRebuild
    PreCalc --> SmoothAnim[Smooth 60fps]
    
    FastRebuild --> Performance[Optimal Performance]
    SmoothAnim --> Performance
    
    style Performance fill:#10b981
    style FastRebuild fill:#6366f1
    style SmoothAnim fill:#818cf8
```

## 📦 Data Flow Architecture

```mermaid
graph TD
    User[User Action] --> UI[UI Event]
    UI --> Provider[Riverpod Provider]
    Provider --> Controller[State Controller]
    
    Controller --> BusinessLogic[Business Logic]
    BusinessLogic --> Validation[Validate]
    Validation --> Transform[Transform Data]
    Transform --> Entity[Update Entity]
    
    Entity --> Persist{Needs Persistence?}
    Persist -->|Yes| Storage[(Local Storage<br/>Isar DB)]
    Persist -->|No| EmitState[Emit New State]
    Storage --> EmitState
    
    EmitState --> StateTree[State Tree]
    StateTree --> SelectiveWatch[Selective Watchers]
    SelectiveWatch --> UIUpdate[UI Rebuild]
    
    style User fill:#818cf8
    style Controller fill:#6366f1
    style Entity fill:#4f46e5
    style Storage fill:#312e81
```

## 🔐 Privacy-First Architecture

```mermaid
graph LR
    subgraph "Local Only"
        App[Focusync App]
        LocalDB[(Local Storage)]
        Device[Device Only]
        
        App --> LocalDB
        LocalDB --> Device
    end
    
    subgraph "NO External Communication"
        NoCloud[❌ No Cloud Sync]
        NoAnalytics[❌ No Analytics]
        NoTracking[❌ No Tracking]
        NoBackend[❌ No Backend]
    end
    
    App -.x.-> NoCloud
    App -.x.-> NoAnalytics
    App -.x.-> NoTracking
    App -.x.-> NoBackend
    
    style App fill:#10b981
    style NoCloud fill:#ef4444
    style NoAnalytics fill:#ef4444
    style NoTracking fill:#ef4444
    style NoBackend fill:#ef4444
```

## 🧩 Widget Composition Pattern

```mermaid
graph TD
    Screen[Screen Widget] --> Layout[Layout Scaffold]
    Layout --> Header[Header Section]
    Layout --> Body[Body Section]
    Layout --> Actions[Action Section]
    
    Body --> Feature1[Feature Widget 1]
    Body --> Feature2[Feature Widget 2]
    
    Feature1 --> Core1[Core Widget]
    Feature1 --> Core2[Core Widget]
    
    Feature2 --> Core3[Core Widget]
    
    Core1 --> Atomic[Atomic Components]
    Core2 --> Atomic
    Core3 --> Atomic
    
    style Screen fill:#4f46e5
    style Layout fill:#6366f1
    style Feature1 fill:#818cf8
    style Feature2 fill:#818cf8
    style Core1 fill:#a5b4fc
    style Atomic fill:#c7d2fe
```

## 📂 Project Directory Structure

```mermaid
graph TD
    Root[lib/] --> Main[main.dart<br/>App Entry]
    
    Root --> Core[core/]
    Core --> Router[router/<br/>GoRouter Config]
    Core --> Theme[theme/<br/>Design System]
    Core --> Widgets[widgets/<br/>Reusable Components]
    
    Root --> Features[features/]
    Features --> Home[home/<br/>Home Screen]
    Features --> Session[focus_session/<br/>Timer Logic]
    Features --> Analytics[analytics/<br/>Stats & Charts]
    Features --> Settings[settings/<br/>Preferences]
    Features --> Auth[auth/<br/>Authentication]
    Features --> Account[account/<br/>User Profile]
    Features --> Splash[splash/<br/>Launch Screen]
    
    Session --> SessionDomain[domain/entities/]
    Session --> SessionPresentation[presentation/<br/>screens/ widgets/ providers/]
    
    style Root fill:#312e81
    style Core fill:#4f46e5
    style Features fill:#6366f1
    style Session fill:#818cf8
```

## 🎯 Key Components & Their Responsibilities

```mermaid
mindmap
  root((Focusync))
    SessionController
      Timer Management
      State Transitions
      Distraction Detection
      Quality Calculation
    CircularTimer Widget
      Visual Timer Display
      Animation Handling
      Progress Indication
    AppRouter
      Route Configuration
      Navigation Logic
      Page Transitions
    AppTheme
      Color Definitions
      Typography System
      Spacing System
    Analytics Calculator
      Session Aggregation
      Focus Quality Metrics
      Trend Analysis
    Settings Manager
      User Preferences
      Theme Toggle
      Timer Defaults
```

## 🔄 App Lifecycle Integration

```mermaid
sequenceDiagram
    participant System as System/OS
    participant App as Flutter App
    participant Observer as WidgetsBindingObserver
    participant Controller as SessionController
    participant State as Session State
    
    System->>App: App Resumed
    App->>Observer: didChangeAppLifecycleState
    Observer->>Controller: Check if session active
    
    System->>App: App Paused/Backgrounded
    App->>Observer: didChangeAppLifecycleState
    Observer->>Controller: markDistraction()
    Controller->>State: Increment distraction count
    State-->>App: Update UI
    
    System->>App: App Inactive
    App->>Observer: didChangeAppLifecycleState
    Observer->>Controller: Handle inactivity
```

---

## 📊 Technology Stack Summary

| Layer | Technology |
|-------|-----------|
| **Framework** | Flutter 3.x |
| **State Management** | Riverpod (StateNotifierProvider) |
| **Navigation** | GoRouter |
| **Local Storage** | Isar DB (planned) |
| **Architecture** | Clean Architecture + Feature-First |
| **Design Pattern** | BLoC-like (via Riverpod) |
| **Theme** | Material Design 3 (Dark-first) |
| **Build System** | Gradle (Android), XCode (iOS) |

---

## 🎨 Design Philosophy

- **Calm UX**: No bright colors, minimal animations, breathing room
- **Honest Tracking**: Real distraction detection, no gamification
- **Privacy-First**: Local-only, no telemetry, no cloud sync
- **Performance**: Const constructors, selective watching, pre-calculation
- **Minimalism**: Essential features only, no bloat

---

*Generated for Focusync v1.0.0 - A focus timer that respects your attention*
