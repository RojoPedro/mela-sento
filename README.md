# MelaSento

A cross-platform social betting mobile application built with **Flutter**, **Dart**, and **Supabase**.

## Features

- **Authentication:** Email/password & Google Sign-In via `supabase_flutter` and `google_sign_in`
- **Groups & Bets:** Create bets (`create_bet_page.dart`), manage friend groups (`group_detail_page.dart`), and view rankings/stats (`fl_chart`)
- **Dark Glassmorphic UI:** Custom dark theme (`core/theme.dart`) using `glass_kit`, `google_fonts`, and `animate_do`

## Tech Stack

- **Flutter** / **Dart** (`>=3.0.0 <4.0.0`)
- **Supabase** (Auth & Realtime Database)
- **fl_chart**, **glass_kit**, **animate_do**

## Local Setup

```bash
flutter pub get
flutter run
```
