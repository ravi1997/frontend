# Flutter Core Dependencies

This document lists the recommended packages for the Flutter implementation of the Form Management System.

## State Management
- `flutter_riverpod`: ^2.5.0 - The most modern and robust state management for Flutter.
- `riverpod_annotation`: ^2.3.0 - For code generation support.

## Navigation
- `go_router`: ^13.0.0 - Declarative routing for deep linking and web support.

## Networking
- `dio`: ^5.4.0 - Powerful HTTP client with interceptors and cancellation.

## Serialization & Models
- `json_annotation`: ^4.8.0 - For JSON serialization.
- `freezed_annotation`: ^2.4.0 - For union types and clones (immutable data).

## Persistence
- `hive_flutter`: ^1.1.0 - Fast, NoSQL local database (good for web/mobile).
- OR `drift`: ^2.14.0 - Robust SQL database (good for complex queries).

## UI & Assets
- `google_fonts`: ^6.1.0 - Access to high-quality fonts.
- `flutter_svg`: ^2.0.0+1 - SVG support.
- `lottie`: ^3.0.0 - High-quality animations.
- `font_awesome_flutter`: ^10.6.0 - Extensive icon set.

## Utility
- `logger`: ^2.0.0+1 - For better console debugging.
- `intl`: ^0.19.0 - Internationalization and date formatting.
- `pinput`: ^4.0.0 - For OTP/PIN inputs if needed.

## Development Dependencies
- `build_runner`: ^2.4.0 - Task runner for code generation.
- `freezed`: ^2.4.0 - Code generation for models.
- `json_serializable`: ^6.7.0.
- `riverpod_generator`: ^2.3.0.
- `riverpod_lint`: ^2.3.0.
- `mocktail`: ^1.0.0 - For unit testing mocks.
