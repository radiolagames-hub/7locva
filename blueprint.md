# Offline Alarm App Blueprint

## Overview

This document outlines the plan for creating a fully offline Flutter mobile app with daily alarms, custom content, and a modern user interface. The app will be built with a focus on offline functionality, user-friendliness, and a clean design.

## Features

*   **Daily Alarms:** 5 configurable alarms per day with custom text and media.
*   **Offline First:** All app assets (images, videos, text) are stored locally.
*   **Modern UI:** A clean, visually appealing interface with custom fonts and distinct alarm cards.
*   **Alarm Popups:** Full-screen popups for alarms that appear on top of other apps.
*   **Detail Pages:** Each alarm has a detail page with specific information and video playback.
*   **State Management:** Using the `provider` package for simple and effective state management.

## Project Structure

```
.
├── assets
│   ├── fonts
│   ├── images
│   └── videos
├── lib
│   ├── main.dart
│   ├── models
│   │   └── alarm_model.dart
│   ├── pages
│   │   ├── detail_page.dart
│   │   ├── home_page.dart
│   │   └── video_player_page.dart
│   ├── providers
│   │   ├── alarm_provider.dart
│   │   └── theme_provider.dart
│   └── services
│       └── notification_service.dart
└── pubspec.yaml
```

## Development Plan

### Phase 1: Project Setup & Core UI

1.  **Dependencies:** Add `flutter_local_notifications`, `video_player`, `provider`, and `google_fonts` to `pubspec.yaml`.
2.  **Asset Folders:** Create `assets/images` and `assets/videos` directories.
3.  **Data Model:** Create `alarm_model.dart` to define the structure of an alarm.
4.  **State Management:**
    *   Set up `theme_provider.dart` for managing light/dark modes.
    *   Set up `alarm_provider.dart` to manage the list of alarms.
5.  **UI Skeletons:**
    *   Create `home_page.dart` with a basic layout for alarm cards.
    *   Create `detail_page.dart` for displaying alarm details.
    *   Create `video_player_page.dart` for video playback.
6.  **Main Entry Point:** Update `main.dart` to use `ChangeNotifierProvider` and set up the initial theme.

### Phase 2: Alarm & Notification Logic

1.  **Notification Service:** Create `notification_service.dart` to encapsulate all `flutter_local_notifications` logic.
2.  **Scheduling:** Implement functions to schedule the 5 daily alarms.
3.  **Time Zone Handling:** Ensure alarms adjust to the device's time zone.
4.  **Snooze Functionality:** Add logic to handle snooze actions from notifications.

### Phase 3: UI Implementation & Polish

1.  **Home Page:**
    *   Implement the alarm cards with background images and text overlays.
    *   Style the page using custom fonts and a clean layout.
2.  **Detail Page:**
    *   Display alarm-specific text and an image.
    *   Implement video playback using `video_player`.
3.  **Video Player:** Build the video player UI with play/pause controls.
4.  **Routing:** Set up navigation between the home, detail, and video player pages.

### Phase 4: Advanced Features & Refinements

1.  **Alarm Popup:** Investigate and implement a full-screen alarm popup that appears over other apps.
2.  **User Customization:** Add the ability for users to edit the first and last alarm times.
3.  **Animations:** Add subtle animations and transitions for a better user experience.
4.  **Testing & Debugging:** Thoroughly test the app on both Android and iOS, focusing on alarm reliability and offline behavior.
5.  **Code Quality:** Run `flutter analyze` and `flutter format .` to ensure code quality.

This plan provides a clear roadmap for the development of the offline alarm app, ensuring all requirements are met in a structured and efficient manner.
