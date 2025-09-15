# Project Blueprint

## Overview

This document outlines the architecture and features of the 7 Prayers Flutter application. The app is designed to provide users with a daily prayer schedule, including notifications and prayer content. It also includes a blessing page and a theme toggle for a personalized user experience.

## Features

- **Prayer Schedule:** The app displays a list of seven daily prayers, with the title, time, and an associated image for each prayer.
- **Prayer Content:** Each prayer has a dedicated page with the prayer text.
- **Notifications:** The app schedules daily notifications for each prayer time.
- **Blessing Page:** A dedicated page with a blessing text.
- **Theme Toggle:** Users can switch between light, dark, and system theme modes.
- **Custom Fonts:** The app uses custom fonts for a unique and visually appealing design.

## Project Structure

- **`lib/main.dart`:** The main entry point of the application. Initializes the app and sets up the theme.
- **`lib/pages/home_screen.dart`:** The main screen of the app, displaying the prayer schedule.
- **`lib/pages/blessing_page.dart`:** The page with the blessing text.
- **`lib/pages/morning_prayer_page.dart`:** The page with the morning prayer text.
- **`lib/pages/afternoon_prayer_page.dart`:** The page with the afternoon prayer text.
- **`lib/pages/evening_prayer_page.dart`:** The page with the evening prayer text.
- **`lib/pages/midnight_prayer_page.dart`:** The page with the midnight prayer text.
- **`lib/data/prayer_data.dart`:** The data source for the prayer schedule.
- **`lib/models/prayer_model.dart`:** The data model for a single prayer.
- **`lib/providers/alarm_provider.dart`:** The provider for scheduling and managing alarms.
- **`lib/services/notification_service.dart`:** The service for handling local notifications.
- **`lib/models/alarm_model.dart`:** The data model for a single alarm.
- **`assets/fonts/`:** The directory with the custom fonts.
- **`assets/images/`:** The directory with the images for the prayer schedule.
- **`assets/audio/`:** The directory with the custom notification sound.

## Current Plan

I have completed all the requested changes. The app now has a new design, custom fonts, a theme toggle, a blessing page, and a complete prayer schedule with notifications.

If you have any other requests, please let me know.