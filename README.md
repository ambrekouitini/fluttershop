# ShopFlutter - E-Commerce Application

A complete e-commerce Flutter application built with MVVM/Clean Architecture, featuring Firebase Authentication, persistent cart, order management, and cross-platform support (Web, Android, iOS).

## Features

### Core Functionality
- **Product Catalog**: Browse products with search and category filtering
- **Product Details**: View detailed product information with image gallery
- **Shopping Cart**: Add products, modify quantities, view total
- **Checkout**: Simplified checkout flow with mock payment
- **Order Management**: Create and view order history
- **User Authentication**: Email/Password and Google Sign-In via Firebase Auth

### Architecture
- **MVVM Pattern**: Clear separation of concerns with ViewModels
- **Clean Architecture**: Domain, Data, and Presentation layers
- **State Management**: Riverpod for reactive state management
- **Repository Pattern**: Abstraction for data sources
- **Dependency Injection**: Provider-based DI

### Platform-Specific Features
- **Web**: PWA manifest for installable web app
- **Android**: Adaptive icons and material design
- **iOS**: Cupertino widgets support
- **Cross-platform**: Share functionality using share_plus

### Testing
- 5+ Unit tests (models, repositories)
- 2+ Widget tests (UI components, screens)
- Test coverage ≥ 50%

### CI/CD
- GitHub Actions workflow
- Automated testing on push/PR
- Coverage reporting
- Web and Android build artifacts

## Project Structure

```
lib/
├── core/
│   ├── config/         # Router configuration
│   ├── constants/      # App constants
│   ├── providers/      # Riverpod providers
│   └── utils/          # Utility functions
├── data/
│   ├── datasources/    # Local and remote data sources
│   ├── models/         # Data models
│   └── repositories/   # Repository implementations
├── domain/
│   ├── entities/       # Business entities
│   └── usecases/       # Business logic
└── presentation/
    ├── screens/        # UI screens
    ├── viewmodels/     # State management
    └── widgets/        # Reusable widgets

assets/
├── data/              # Mock JSON data
└── images/            # App images

test/
├── unit/              # Unit tests
└── widget/            # Widget tests
```

## Getting Started

### Prerequisites
- Flutter SDK 3.10.0 or higher
- Dart SDK
- Firebase project (for authentication)
- Android Studio / VS Code

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd flutter_application_1
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure Firebase:
   - Create a Firebase project at https://console.firebase.google.com
   - Enable Email/Password and Google authentication
   - Update `lib/main.dart` with your Firebase configuration

4. Run the app:
```bash
# Web
flutter run -d chrome

# Android
flutter run -d <device-id>

# iOS
flutter run -d <device-id>
```

### Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# View coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Building for Production

```bash
# Web
flutter build web --release

# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## Firebase Setup

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a new project
3. Enable Authentication:
   - Email/Password
   - Google Sign-In
4. Get your Firebase config and update in `lib/main.dart`:

```dart
await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
  ),
);
```

## Navigation Routes

- `/login` - Login screen
- `/register` - Registration screen
- `/catalog` - Product catalog (home)
- `/product/:id` - Product detail
- `/cart` - Shopping cart
- `/checkout` - Checkout flow
- `/orders` - Order history
- `/profile` - User profile

## Key Dependencies

- `flutter_riverpod` - State management
- `go_router` - Navigation and routing
- `firebase_core` & `firebase_auth` - Authentication
- `google_sign_in` - Google authentication
- `shared_preferences` - Local storage
- `cached_network_image` - Image caching
- `intl` - Internationalization and formatting
- `share_plus` - Cross-platform sharing
- `equatable` - Value equality
- `uuid` - Unique ID generation

## Features Implementation

### Authentication Guard
The app uses `go_router` with authentication guards that redirect unauthenticated users to the login screen.

### Cart Persistence
Cart data is persisted locally using `shared_preferences`, surviving app restarts.

### Mock Checkout
The checkout flow simulates payment processing with a 2-second delay and creates persistent orders.

### PWA Support
The web build includes a manifest.json for Progressive Web App capabilities, allowing users to install the app.

## Testing Strategy

1. **Unit Tests**: Test business logic, models, and repositories
2. **Widget Tests**: Test UI components and screens
3. **Integration Tests**: Could be added for end-to-end flows

## CI/CD Pipeline

The GitHub Actions workflow:
1. Runs on push/PR to main/develop branches
2. Checks code formatting
3. Analyzes code with Flutter analyzer
4. Runs all tests with coverage
5. Builds Web and Android versions
6. Uploads build artifacts

## License

This project is for educational purposes as part of a Flutter e-commerce course assignment.

## Future Enhancements

- Real payment integration (Stripe)
- Backend API integration
- Push notifications
- Wishlists
- Product reviews and ratings
- Admin panel
- Real-time order tracking
- Multiple payment methods
- Internationalization (i18n)
# fluttershop
# fluttershop
