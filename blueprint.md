# Project Blueprint

## Overview

This document outlines the plan for developing a Flutter application that provides daily prayers, a calendar, and customizable settings.

## Current State

The application has a home screen, a calendar page, and a settings page. The core functionality for settings management (theme and font size) is implemented. The application's theme has been updated to a new, modern design for both light and dark modes based on the provided specifications.

## Plan

### 1. UI/UX Refinement

*   **Component Styling:** Review and update all UI components (buttons, cards, navigation bars, etc.) to ensure they align with the new design aesthetic. This includes applying the specified colors for different states (active, inactive) and elements.
*   **Spacing and Shadows:** Apply consistent spacing (`8-16px`) between elements and add subtle shadows to cards and interactive elements to create depth, as per the design guidelines.
*   **Accessibility:** Verify that text contrast ratios meet WCAG standards for readability in both light and dark themes across the application.

### 2. Feature Enhancements

*   **Calendar View:** Define and implement the functionality for the calendar page.
*   **Patriarch's Blessing Page:** Implement the video player for the Patriarch's blessing.
*   **Prayer Details:** Enhance the prayer details view, ensuring it uses the new theme correctly.

### 3. Code Quality and Maintenance

*   **Refactoring:** Refactor widgets into smaller, reusable components to improve maintainability and consistency.
*   **Performance:** Ensure the application remains performant, especially with the new theme and potential animations or effects.
