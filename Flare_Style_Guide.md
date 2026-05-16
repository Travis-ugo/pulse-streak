# Flare — UI/UX Style Guidelines

## 1. Design Philosophy & Stitch Integration

**Stitch Design Continuity**: We will connect to and continue using the core design language established on Stitch. This ensures a seamless visual identity, leveraging familiar interaction patterns, component structures, and an overall cohesive user experience across our product ecosystem.

The Flare interface builds upon this foundation, adapting it specifically for the emotional engagement required in habit tracking and streak building.

## 2. Core Aesthetic Principles

* **Minimalist**: Clean interfaces with ample breathing room. Remove unnecessary visual noise to focus the user on their goals.
* **Premium Feel**: High-quality UI components, deep contrast, precise alignment, and polished details.
* **Dark Mode First**: The primary design environment is Dark Mode. This emphasizes the glowing amber accents (the "Pulse" and "Flame") and creates an immersive, focused experience.
* **Dynamic & Smooth**: Fluid transitions, 60fps native SwiftUI animations, soft gradients, and interactive feedback.

---

## 3. Color Palette

The color system is designed to provide high contrast in Dark Mode while keeping the UI energetic and motivating.

### Primary Color: Orange / Amber
* **Usage**: The core color for streaks, active states, progress rings, and the primary app flame.
* **Effect**: Represents momentum, energy, and the "fire" of a continuous streak.

### Secondary Color: Black / Dark Gray
* **Usage**: Backgrounds, secondary card backgrounds, and structural elements.
* **Effect**: Provides a deep, immersive canvas that makes the primary colors pop.

### Accent Color: Electric Blue or Purple
* **Usage**: Secondary actions, alternative habit categories, subtle highlights, or milestone celebrations.
* **Effect**: Adds depth and a premium tech feel without overpowering the primary amber.

---

## 4. Typography

We rely on native Apple fonts to ensure maximum legibility and a native iOS feel.

* **Primary Typeface**: `SF Pro Display` (Used for large headers, counters, and bold statements)
* **Secondary Typeface**: `SF Pro Rounded` (Used for friendly, approachable numbers like the streak counter, and softer UI elements)

**Typographic Hierarchy**:
* **H1 (Large Titles)**: Bold, tight tracking (e.g., "Good Evening, Travis 🔥")
* **H2 (Section Headers)**: Semibold, balanced
* **Body**: Regular, readable, subtle gray for secondary text
* **Numbers/Streaks**: SF Pro Rounded, Heavy or Bold, often with a glowing text effect.

---

## 5. UI Components & Elements

### Cards
* **Style**: Soft rounded corners (e.g., `cornerRadius: 16` or `20`).
* **Background**: Slightly lighter gray than the main dark background to create depth.
* **Shadows**: Soft, expansive drop shadows in light mode; subtle glowing drop shadows or inner borders in dark mode.

### Buttons
* **Primary Actions**: Solid Primary Color (Amber) with bold text.
* **Secondary Actions**: Blurred backgrounds (Material/Glassmorphism) or outlined with the Accent color.
* **Interactions**: All buttons should have a subtle scale-down effect when pressed, accompanied by haptic feedback.

---

## 6. Animations & Haptics

Animations are a core part of the Flare experience. They reward the user and make the app feel "alive."

* **Streak Flame**: The flame icon should have a continuous, subtle idle animation (breathing effect). When a habit is completed, the flame should flare up.
* **Progress Fill**: Rings and progress bars should fill smoothly with an ease-in-out curve.
* **Card Glow**: Completing a habit triggers a brief pulse of the primary color glowing from behind the card.
* **Haptics**: Use `UIImpactFeedbackGenerator`.
  * **Light**: Navigating tabs.
  * **Medium/Rigid**: Toggling a habit.
  * **Success**: Reaching a milestone or restoring a streak.

---

## 7. Imagery & Iconography

* **Icons**: Use SF Symbols to maintain a native iOS feel. Use consistent weights (e.g., Regular or Medium) across the app.
* **App Icon**: A glowing flame merged with a circular pulse ring on a dark background. It should immediately convey the ideas of "Momentum" and "Consistency."

---

## 8. Layout & Navigation Structure

### Bottom Tab Bar
Clean, translucent (Material design) tab bar to keep the focus on the content scrolling underneath.
1. **Home** (Dashboard & Today's Habits)
2. **Calendar** (GitHub-style contribution graph and history)
3. **Analytics** (Charts and insights)
4. **Achievements** (Milestones and momentum score)
5. **Settings** (App preferences)

### Spacing & Grid
* **Base Unit**: 8pt grid system.
* **Standard Padding**: 16pt or 20pt for screen edges and spacing between major sections.
* **Component Padding**: 12pt or 16pt inside cards.

---

## 9. Accessibility (A11y)

* **Dynamic Type**: All text must scale according to the user's system preferences.
* **Contrast Ratios**: Ensure text meets at least AA WCAG standards against its background.
* **Reduced Motion**: Provide fallback state-changes without bouncy animations if the user has "Reduce Motion" enabled in iOS settings.
* **VoiceOver**: All buttons and custom interactive elements must have descriptive accessibility labels.
