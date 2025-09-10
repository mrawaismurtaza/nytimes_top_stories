# NYTimes Top Stories Flutter App

A production-quality Flutter application that presents the New York Times Top Stories in a master list with a tappable detail screen. This app demonstrates expertise in Dart/Flutter, third-party REST API integration, state management, architecture, and UX quality.

## Features

### Core Functionality
- **Article List View**: Display articles with thumbnail images, titles, and author bylines
- **Detail View**: Full article view with large image, title, description, author, and "See More" button
- **WebView Integration**: Read full articles within the app
- **Search**: Search articles by title or author name (client-side)
- **Filter by Section**: Filter articles by NYT sections (home, world, science, technology, sports, etc.)

### UI/UX Features
- **Layout Toggle**: Switch between list and grid layout views
- **Pull-to-Refresh**: Refresh articles with swipe gesture
- **Dark/Light Theme**: Automatic theme switching support
- **Portrait/Landscape**: Responsive design for all orientations
- **Loading States**: Proper loading indicators for all async operations
- **Error Handling**: Graceful error states with retry functionality
- **Empty States**: User-friendly empty state messages

### Technical Features
- **Clean Architecture**: Separation of concerns with proper layering
- **BLoC State Management**: Immutable state management with flutter_bloc
- **Dependency Injection**: Using get_it for service locator pattern
- **Environment Variables**: Secure API key storage with flutter_dotenv
- **SOLID Principles**: Following SOLID design principles
- **Null Safety**: Full null safety implementation

## Architecture

### Project Structure
```
lib/
├── main.dart                           # App entry point
├── core/
│   ├── app_router.dart                # Navigation routing
│   └── app_theme.dart                 # Theme configuration
├── data/
│   ├── models/
│   │   └── top_story.dart            # Data models
│   └── repositories/
│       └── top_stories_rep.dart      # Data layer
├── features/
│   ├── blocs/
│   │   └── top_stories/              # BLoC state management
│   │       ├── topstories_bloc.dart
│   │       ├── topstories_event.dart
│   │       └── topstories_state.dart
│   ├── screens/
│   │   ├── home.dart                 # Main list screen
│   │   └── detail_view.dart          # Article detail screen
│   └── shared_widgets/
│       └── detailed_view_card.dart   # WebView component
```

### State Management
- **BLoC Pattern**: Business Logic Component pattern for state management
- **Immutable States**: All states are immutable for predictable state changes
- **Event-Driven**: User interactions trigger events that modify state
- **Separation of Concerns**: UI components only handle presentation logic

### Design Patterns
- **Repository Pattern**: Abstract data access layer
- **Dependency Injection**: Service locator pattern with get_it
- **Factory Pattern**: For creating BLoC instances
- **Observer Pattern**: BLoC event/state system

## API Integration

### NYTimes Top Stories API
- **Endpoint**: `https://api.nytimes.com/svc/topstories/v2/{section}.json`
- **Authentication**: API key-based authentication
- **Sections**: home, world, politics, business, technology, science, health, sports, entertainment
- **Rate Limiting**: Handles API rate limits gracefully

### Security
- **Environment Variables**: API keys stored in `.env` file
- **Gitignore**: Sensitive files excluded from version control
- **No Hardcoded Secrets**: All secrets managed through environment variables

## Setup Instructions

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- NYTimes Developer API Key

### Installation
1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd nytimes_top_stories
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Setup API Key**
   - Create a developer account at [NYTimes Developer Portal](https://developer.nytimes.com/)
   - Generate an API key for the Top Stories API
   - Create `assets/.env` file in the project root
   - Add your API key:
     ```
     NYT_API_KEY=your_api_key_here
     ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Platform-Specific Setup

#### Android
- Minimum SDK: 21
- Target SDK: 34
- Internet permission configured in manifest

#### iOS
- Minimum iOS version: 12.0
- App Transport Security configured for HTTP requests

## Dependencies

### Core Dependencies
- **flutter_bloc**: ^8.1.3 - State management
- **get_it**: ^7.6.4 - Dependency injection
- **dio**: ^5.3.2 - HTTP client
- **flutter_dotenv**: ^5.1.0 - Environment variables
- **webview_flutter**: ^4.4.2 - WebView integration

### Development Dependencies
- **flutter_test**: Testing framework
- **flutter_lints**: Dart linting rules

## Testing

### Running Tests
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

### Test Coverage
- Unit tests for BLoC components
- Widget tests for UI components
- Integration tests for user flows

## Performance Optimizations

### Image Loading
- Lazy loading for article images
- Error handling for failed image loads
- Placeholder widgets for missing images

### Network Optimization
- Efficient API request handling
- Proper error handling and retry logic
- Caching strategies for improved performance

### Memory Management
- Proper disposal of controllers and streams
- Efficient list rendering with builders
- Optimized image memory usage

## Contributing

### Code Style
- Follow Dart style guidelines
- Use meaningful variable and function names
- Maintain consistent formatting with `dart format`
- Add documentation for public APIs

### Pull Request Process
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

For questions or support, please create an issue in the repository.