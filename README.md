<div align="center">
  <img src="https://via.placeholder.com/150/000000/FF8C00?text=🔥" alt="Flare Logo" width="120" height="120" style="border-radius: 30px;">
  <h1>Flare</h1>
  <p><b>A modern streak-tracking and reminder iOS app designed to help you build momentum.</b></p>
  
  [![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg?style=flat&logo=swift)](https://swift.org)
  [![SwiftUI](https://img.shields.io/badge/SwiftUI-Framework-blue.svg?style=flat&logo=apple)](https://developer.apple.com/xcode/swiftui/)
  [![Platform](https://img.shields.io/badge/Platform-iOS_17+-lightgrey.svg?style=flat&logo=apple)](https://www.apple.com/ios/)
  [![Architecture](https://img.shields.io/badge/Architecture-MVVM-success.svg?style=flat)]()
</div>

---

## 🌟 Overview

**Flare** isn't just another habit tracker. It is designed to foster **momentum, emotional engagement, and visual progress**. Whether you are trying to hit the gym, code daily, read more, or drink enough water, Flare uses beautiful native animations and a rewarding streak system to keep you addicted to self-improvement.

Built natively for iOS with a focus on a **premium, minimal, and dark-mode-first** aesthetic.

## ✨ Core Features

* **🔥 Momentum-Based Streaks:** Dynamic flame animations that grow stronger as your streak gets longer.
* **📅 Smart Reminders:** Persistent notifications, snooze options, and AI-driven reminder timing.
* **📊 Contribution Calendar:** A GitHub-style heat map to visualize your history, missed days, and overall momentum.
* **🏆 Milestone Celebrations:** Rewarding haptics and animations for hitting 7, 30, 100, and 365-day goals.
* **📱 Beautiful Widgets:** Home and Lock Screen widgets that bring your progress directly to your iOS dashboard.
* **🌙 Dark Mode First:** A deep, immersive dark canvas where energetic amber progress rings pop.
* **✈️ 100% Offline Support:** Your streaks live on your device, syncing gracefully when you reconnect.

## 🛠 Tech Stack

Flare is built with modern iOS technologies to ensure high performance and seamless interactions:

* **UI Framework:** SwiftUI
* **Architecture:** MVVM (Model-View-ViewModel)
* **Reactive Programming:** Combine
* **Local Database:** SwiftData (or CoreData)
* **Animations:** Native SwiftUI Animations & Lottie
* **Haptics:** `UIImpactFeedbackGenerator`
* **Notifications:** UserNotifications Framework

## 🎨 Design Philosophy

Our design connects with the **Stitch Design Continuity** system, ensuring a seamless, premium experience:

* **Minimalist & Focused:** Zero clutter. We highlight what matters most—your habits and your streak.
* **Premium Feel:** High-quality components, soft gradients, and precise alignments.
* **Dynamic & Alive:** 60fps animations make the interface feel responsive and rewarding.
* **Color Palette:**
  * **Primary:** Amber / Orange (Momentum & Energy)
  * **Secondary:** Deep Black / Dark Gray (Immersive Canvas)
  * **Accent:** Electric Blue / Purple (Depth & Highlights)

> *Read the full [Product Requirements Document (PRD)](Flare_PRD.md) and [Style Guidelines](Flare_Style_Guide.md) for deeper insights.*

## 📂 Project Structure

```text
Flare/
├── Models/        # Core data structures (Habit, Completion, UserStats)
├── Views/         # SwiftUI views (Home, Calendar, Stats, Settings)
├── ViewModels/    # State management and business logic
├── Services/      # Data handling, local storage, API clients
├── Managers/      # Notification, Haptics, and Theme managers
├── Components/    # Reusable UI elements (Buttons, Cards, Progress Rings)
├── Widgets/       # iOS Lock/Home Screen Widgets
├── Animations/    # Lottie files and custom SwiftUI transitions
├── Resources/     # Assets, Fonts, and Localization strings
```

## 🚀 Getting Started

*(Instructions for cloning, installing dependencies, and running the project will be added as the initial architecture is scaffolded.)*

---

<div align="center">
  <i>"The goal is not just habit tracking. The goal is helping users build momentum and stay consistent long-term."</i>
</div>
# flare
