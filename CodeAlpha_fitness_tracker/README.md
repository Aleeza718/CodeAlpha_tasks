# Fitness Pro

A premium Flutter-based fitness tracking application developed as part of the CodeAlpha App Development Internship.

## Overview

Fitness Pro is a mobile fitness tracking app that allows users to manually record their daily fitness activities and monitor their progress through a simple, modern dashboard.

The app uses local storage so users can keep their fitness records without requiring an online account.

## Features

- Animated splash screen
- Daily fitness dashboard
- Calories tracking
- Steps tracking
- Workout duration tracking
- Water intake tracking
- Weekly activity chart
- Recent activity history
- Manual activity logging
- Multiple activity types
- Height and weight management
- Automatic BMI calculation
- BMI category
- Metric and Imperial unit support
- Goal progress tracking
- Achievement badges
- Daily streak tracking
- Persistent local data storage
- Dynamic time-based greeting
- Premium dark theme
- Responsive mobile UI
- Smooth animations

## Activity Tracking

Users can manually log fitness activities such as:

- Walking
- Running
- Cycling
- Gym
- Yoga
- Workout

Each activity can include:

- Activity type
- Duration
- Calories burned

## Progress Tracking

The dashboard provides an overview of:

- Daily calories
- Daily steps
- Workout progress
- Water intake
- Weekly activity
- Recent activities

The weekly activity chart uses the user's actual recorded activity data.

## Goals & Achievements

Users can track progress toward personal goals:

- Target weight
- Daily step goal
- Weekly workout goal

The app also unlocks achievement badges based on real activity data, such as logging a first workout or maintaining an early streak.

## Streak Tracking

The dashboard highlights the user's current daily streak along with their all-time best streak, calculated from actual logged activity history — not a fixed or fabricated number.

## Profile & BMI

Users can enter their body details, including:

- Height
- Weight

The application automatically calculates BMI and displays the corresponding BMI category.

No fake BMI data is shown when body details have not been entered.

## Local Data Storage

Fitness Pro uses Hive for local data persistence.

User activity records and fitness-related information remain available after closing and reopening the application.

No login or signup is required.

## Technologies Used

- Flutter
- Dart
- Provider
- Hive
- Hive Flutter
- FL Chart
- Flutter Slidable
- UUID

## Project Structure

lib/
├── animations/
├── models/
├── providers/
├── screens/
├── services/
├── theme/
├── utils/
├── widgets/
└── main.dart
