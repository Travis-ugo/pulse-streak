# Flare — iOS Product Requirements Document (PRD)

## Product Overview

Flare is a modern streak-tracking and reminder application designed to help users build consistency around daily and recurring activities.

The app combines:
* Habit tracking
* Smart reminders
* Daily streak systems
* Beautiful animations
* Motivational feedback
* Analytics and progress insights

Unlike traditional habit trackers, Flare focuses heavily on momentum, emotional engagement, and visual progress.

The app should feel:
* Premium
* Minimal
* Motivating
* Fast
* Addictive in a healthy way

Target Platform:
* Native iOS App
* Built using Swift + SwiftUI

---

# App Name

Flare

Alternative Names:
* Ember
* Momentum
* Ignite
* Ritual
* DayForge

Primary recommendation:
Flare

---

# Core User Goal

Users can:
1. Create activities they want to stay consistent with
2. Schedule reminders/alarms
3. Track streaks automatically
4. View progress visually
5. Receive motivational feedback
6. Build long-term consistency

Examples:
* Gym
* Reading
* Prayer
* Coding
* Studying
* Drinking water
* Journaling
* Sleep schedule
* Content posting

---

# Technical Stack

## Frontend
* SwiftUI
* Combine
* MVVM Architecture

## Local Database
* SwiftData OR CoreData

## Notifications
* UserNotifications Framework

## Animations
* Lottie
* Native SwiftUI animations
* Haptic feedback

## Cloud Sync
* iCloud Sync
* Optional Firebase sync later

## Analytics
* Firebase Analytics (optional)

---

# Core Features

# 1. Onboarding Flow

## Screens
1. Welcome Screen
2. Benefits Screen
3. Notification Permission
4. Create First Habit
5. Select Reminder Time
6. Finish Setup

## Onboarding Goal
The user should create at least one habit before entering the app.

---

# 2. Authentication

## Options
* Continue with Apple
* Continue as Guest

## Future Options
* Google Sign In
* Email Sign In

Guest mode should still allow local streak tracking.

---

# 3. Home Dashboard

## Main Components

### Header
* Greeting
* Current streak count
* Momentum score

Example:
“Good Evening, Travis 🔥”

---

### Today’s Habits Section

Each habit card should show:
* Habit icon
* Habit title
* Current streak
* Reminder time
* Completion status
* Progress animation

---

### Completion Interaction

When user taps complete:
* Haptic feedback
* Flame animation
* Card glow animation
* Progress fill animation
* Motivational message

Examples:
* “Momentum maintained 🔥”
* “7 day streak unlocked”
* “Consistency wins.”

---

# 4. Habit Creation

## User Inputs

### Required
* Habit name
* Icon/category
* Reminder time

### Optional
* Color theme
* Notes
* Goal count
* Custom sound

---

## Repeat Schedule Options

### Daily
Repeats every day

### Custom Days
Examples:
* Monday, Wednesday, Friday
* Weekdays only
* Weekends only

### X Times Per Week
Examples:
* 3x weekly
* 5x weekly

### Multiple Times Per Day
Examples:
* Drink water 4 times daily

---

# 5. Streak Logic

## Rules

### Daily Habit
If completed before midnight:
* streak += 1

If missed:
* streak resets

---

### Weekly Habit
Streak only breaks if required weekly count is not reached.

Example:
Gym 3x weekly
User completes 3 sessions:
* streak continues

User completes only 2:
* streak breaks

---

# 6. Smart Reminder System

## Reminder Features
* Repeat alarms
* Multiple reminders
* Snooze
* Persistent reminders
* Critical reminder mode
* Sound selection

---

## Smart Reminder AI (Future)
The app learns user behavior.

Examples:
* User usually completes reading at 10 PM
* App adjusts reminder timing automatically

---

# 7. Animations System

## Streak Flame
The flame grows based on streak length.

### Examples
1-3 days:
* Small flame

7 days:
* Stronger flame

30 days:
* Large animated flame

100+ days:
* Special glowing effect

---

## Risk State
If user has not completed habit near deadline:
* Flame flickers
* Card shakes slightly
* Reminder urgency increases

---

## Milestone Celebrations

Celebrate:
* 7 days
* 14 days
* 30 days
* 100 days
* 365 days

Effects:
* Confetti
* Sound effects
* Full screen celebration
* Achievement badges

---

# 8. Momentum Score

## Purpose
A secondary scoring system that reflects overall consistency.

---

## Formula Example
Factors:
* Habit completion rate
* Longest streak
* Weekly consistency
* Recovery success
* Time consistency

---

## Rank Levels
* Bronze
* Silver
* Gold
* Platinum
* Diamond

---

# 9. Statistics & Insights

## Stats Screen

### Metrics
* Longest streak
* Completion percentage
* Weekly performance
* Monthly consistency
* Habit heatmap

---

## Charts
* Daily completion graph
* Weekly trends
* Streak growth chart
* Calendar heatmap

---

## AI Insights
Examples:
* “You’re most productive on Tuesdays.”
* “Your reading habit is strongest after 8 PM.”
* “You’ve improved consistency by 27%.”

---

# 10. Calendar View

## Features
GitHub-style contribution graph.

Users can:
* View completed days
* View missed days
* Track momentum history
* Replay streak journey

---

# 11. Widgets

## Lock Screen Widget
Shows:
* Current streak
* Flame animation
* Next reminder

---

## Home Screen Widget
Sizes:
* Small
* Medium
* Large

Widget content:
* Today’s habits
* Progress rings
* Streak counter
* Daily quote

---

# 12. Apple Watch Support (Future)
Features:
* Quick completion
* Reminder notifications
* Streak tracking
* Progress rings

---

# 13. Social Features (Phase 2)

## Accountability Groups
Users can:
* Join groups
* Share streaks
* Encourage friends
* Maintain group streaks

---

## Share Cards
Generate beautiful cards:
* “100 Day Coding Streak 🔥”
* “30 Day Gym Streak”

Export formats:
* Instagram Story
* TikTok
* X/Twitter

---

# 14. Monetization

# Free Tier
* Up to 3 habits
* Basic reminders
* Basic streak tracking

---

# Premium Tier

## Features
* Unlimited habits
* AI insights
* Advanced analytics
* Custom animations
* Themes
* Widgets
* Cloud sync
* Shared streaks
* Premium sounds

---

# UI/UX Design Direction

## Style
* Minimal
* Premium
* Dark mode first
* Smooth transitions
* Soft gradients

---

## Inspirations
* Duolingo
* Notion Calendar
* Apple Fitness
* Headspace
* GitHub contribution graph

---

# Color Palette

## Primary
Orange / Amber

## Secondary
Black / Dark Gray

## Accent
Electric Blue or Purple

---

# Typography
* SF Pro Display
* SF Pro Rounded

---

# Navigation Structure

## Bottom Tab Bar
1. Home
2. Calendar
3. Analytics
4. Achievements
5. Settings

---

# Suggested Folder Structure

## Architecture
MVVM

## Structure
* Models/
* Views/
* ViewModels/
* Services/
* Managers/
* Components/
* Widgets/
* Animations/
* Resources/

---

# Key Models

## Habit
Fields:
* id
* title
* icon
* color
* repeatDays
* reminderTimes
* streakCount
* longestStreak
* completionHistory
* createdAt

---

## Completion
Fields:
* id
* habitId
* completedAt
* status

---

## UserStats
Fields:
* momentumScore
* totalCompletions
* totalHabits
* longestGlobalStreak

---

# Notification Requirements

## Local Notifications
Required:
* Daily reminders
* Repeat schedules
* Snooze
* Habit urgency

---

## Dynamic Notification Examples
* “Your streak is waiting 🔥”
* “Don’t break the chain.”
* “One task left today.”
* “Momentum is building.”

---

# Offline Support
The app must work fully offline.

Requirements:
* Local streak calculation
* Local reminders
* Offline completion tracking

Sync later when internet returns.

---

# Performance Requirements

## Goals
* App launch under 2 seconds
* Smooth 60fps animations
* Low battery usage
* Fast notification delivery

---

# Accessibility
Requirements:
* VoiceOver support
* Dynamic font scaling
* Reduced motion mode
* High contrast mode

---

# Future AI Features

## Habit Coach
AI assistant suggests:
* Better reminder times
* Habit stacking
* Consistency strategies

---

## Burnout Detection
Detects declining consistency patterns.

Examples:
* Suggest rest
* Suggest smaller goals
* Suggest recovery mode

---

# App Store Positioning

## Category
Productivity

---

## Keywords
* Habit tracker
* Streak app
* Daily reminder
* Productivity
* Consistency
* Goal tracker

---

# MVP Scope (Version 1)

## MUST HAVE
* Habit creation
* Repeat schedules
* Reminder notifications
* Daily streak logic
* Completion tracking
* Basic analytics
* Home widgets
* Dark mode
* Local storage

---

## NICE TO HAVE
* AI Insights
* Share cards
* Cloud sync
* Group streaks

---

# Suggested Development Timeline

## Week 1
* Project setup
* Core models
* Navigation
* Local database

---

## Week 2
* Habit creation flow
* Dashboard
* Completion logic

---

## Week 3
* Reminder system
* Notifications
* Streak calculations

---

## Week 4
* Animations
* Widgets
* Analytics
* Polish

---

# Final Product Vision
Flare should feel like:
* Apple Fitness meets Duolingo streaks
* Clean, emotional, and motivating
* A daily companion for consistency

The goal is not just habit tracking.
The goal is helping users build momentum and stay consistent long-term.

---

# App Icon Direction

## Style
* Modern
* Minimal
* Premium
* Dark mode friendly

## Main Symbol
A glowing flame merged with a circular pulse ring.

## Colors
* Amber flame
* Dark background
* Subtle orange glow

## Feel
* Momentum
* Energy
* Consistency
* Progress

The icon should look App Store quality and instantly recognizable.
