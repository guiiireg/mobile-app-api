# 📱 Mobile App API — Flutter Anime Explorer & Live Translation Client

> **Note pour les recruteurs / RH :** *Mobile App API est une application mobile cross-platform développée en Flutter et Dart. Elle consomme l'API GraphQL publique AniList pour explorer des catalogues d'animes, intègre un système de traduction multilingue en temps réel (Français / Anglais) avec mise en cache mémoire FIFO et assure le rendu fluide des images et balises HTML riches.*

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![API](https://img.shields.io/badge/API-AniList%20GraphQL-02A9FF?style=for-the-badge)](https://anilist.gitbook.io/anilist-apiv2-docs/)

Welcome to **Mobile App API**, a modern Flutter application designed to browse, discover, and inspect media entries from the AniList GraphQL API with seamless live translation and responsive state management.

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Key Features](#-key-features)
- [Architecture & Project Structure](#-architecture--project-structure)
- [Tech Stack & Dependencies](#-tech-stack--dependencies)
- [Getting Started & Installation](#-getting-started--installation)
- [API Integration](#-api-integration)

---

## 🌟 Overview

The application fetches anime media entries from the AniList GraphQL endpoint and displays them in an adaptive two-column grid. Users can toggle between French and English on the fly, with automated real-time translation powered by Google Translate and optimized with an in-memory FIFO cache to avoid redundant API queries.

---

## 🔥 Key Features

1. **GraphQL API Integration (`api_service.dart`)** :
   - Direct HTTP POST communication with AniList's GraphQL API (`https://graphql.anilist.co`).
   - Query pagination requesting titles (romaji), descriptions, and high-resolution cover images.
   - Robust HTML tag stripping and entity decoding for clean preview cards.

2. **Real-Time Translation with Caching (`translation_service.dart`)** :
   - On-demand translation of synopsis and descriptions from English into French.
   - LRU/FIFO memory cache (up to 500 entries) with compound keys (`lang|text`) preventing duplicate network translation round-trips.

3. **Dynamic Localization & Language Toggle (`localization.dart`)** :
   - In-app language switcher (`🇫🇷 Français` / `🇬🇧 English`) accessible via the navigation app bar.
   - Instant UI re-rendering with reactive `FutureBuilder` bindings.

4. **Detailed Media View (`detail_page.dart`)** :
   - Full-bleed cover image header with loading indicators and error fallbacks.
   - Rich HTML description rendering using `flutter_html`.

5. **Resilient Network Image Handling (`CoverImage` Widget)** :
   - Custom widget with byte-progress loader and placeholder fallback on broken/missing URLs.

---

## 📐 Architecture & Project Structure

```text
mobile-app-api/
├── lib/
│   ├── main.dart                 # Application entry point, CoverImage widget & Grid Catalog view
│   ├── api_service.dart          # AniList GraphQL query client & HTML sanitizer
│   ├── detail_page.dart          # Anime detail screen with HTML synopsis renderer
│   ├── localization.dart         # Static localized UI strings dictionary (EN / FR)
│   └── translation_service.dart  # Translation engine with FIFO memory caching
├── android/                      # Android native platform project
├── ios/                          # iOS native platform project
├── web/                          # Flutter Web support files
├── pubspec.yaml                  # Flutter package metadata & dependencies
└── README.md                     # Main documentation
```

---

## 🛠️ Tech Stack & Dependencies

- **Framework:** [Flutter](https://flutter.dev/)
- **Language:** [Dart](https://dart.dev/)
- **Networking:** `http` package for GraphQL JSON queries
- **Translation:** `translator` (Google Translate API integration)
- **HTML Rendering:** `flutter_html`
- **Data Source:** [AniList GraphQL API v2](https://anilist.gitbook.io/anilist-apiv2-docs/)

---

## 🚀 Getting Started & Installation

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>= 3.0.0`)
- Android Studio / Xcode / VS Code with Flutter extensions
- Android Emulator, iOS Simulator, or a connected physical device

### Running the App

1. **Clone the repository:**
   ```bash
   git clone https://github.com/guiiireg/mobile-app-api.git
   cd mobile-app-api
   ```

2. **Install Flutter dependencies:**
   ```bash
   flutter pub get
   ```

3. **Launch the application:**
   ```bash
   flutter run
   ```
