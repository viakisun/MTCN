# Flutter Migration Guide - MTCN Golf App

This guide provides a complete migration path from the React/TypeScript app to Flutter.

## Project Status

✅ **Completed:**
- Flutter project structure created (`mtcn_flutter/`)
- Dependencies configured in `pubspec.yaml`
- Design tokens system (`lib/core/theme/design_tokens.dart`)
- App theme with Google Fonts (`lib/core/theme/app_theme.dart`)
- Data models: Player, Rounding

🚧 **In Progress:**
- Additional data models (Group, ScoreRecord, ChatMessage)
- State management with Riverpod
- UI components and screens

## Project Structure

```
mtcn_flutter/
├── lib/
│   ├── core/
│   │   ├── theme/
│   │   │   ├── design_tokens.dart          ✅ Created
│   │   │   └── app_theme.dart              ✅ Created
│   │   ├── utils/
│   │   │   ├── date_utils.dart             📝 Needed
│   │   │   └── format_utils.dart           📝 Needed
│   │   └── constants/
│   │       └── app_constants.dart          📝 Needed
│   │
│   ├── models/
│   │   ├── player.dart                     ✅ Created
│   │   ├── rounding.dart                   ✅ Created
│   │   ├── group.dart                      📝 Needed
│   │   ├── score_record.dart               📝 Needed
│   │   └── chat_message.dart               📝 Needed
│   │
│   ├── providers/
│   │   ├── app_state_provider.dart         📝 Needed (Riverpod)
│   │   ├── rounding_provider.dart          📝 Needed
│   │   ├── group_provider.dart             📝 Needed
│   │   └── score_provider.dart             📝 Needed
│   │
│   ├── services/
│   │   ├── mock_data_service.dart          📝 Needed
│   │   └── navigation_service.dart         📝 Needed
│   │
│   ├── widgets/
│   │   ├── common/
│   │   │   ├── page_container.dart         📝 Needed
│   │   │   ├── page_header.dart            📝 Needed
│   │   │   ├── create_action_card.dart     📝 Needed
│   │   │   ├── avatar.dart                 📝 Needed
│   │   │   ├── badge.dart                  📝 Needed
│   │   │   └── empty_state.dart            📝 Needed
│   │   ├── cards/
│   │   │   ├── rounding_card.dart          📝 Needed
│   │   │   ├── group_card.dart             📝 Needed
│   │   │   └── score_card.dart             📝 Needed
│   │   └── icons/
│   │       └── golf_icons.dart             📝 Needed
│   │
│   ├── screens/
│   │   ├── home/
│   │   │   └── home_page.dart              📝 Needed
│   │   ├── rounding/
│   │   │   ├── rounding_page.dart          📝 Needed
│   │   │   └── rounding_detail_page.dart   📝 Needed
│   │   ├── groups/
│   │   │   └── groups_page.dart            📝 Needed
│   │   ├── score/
│   │   │   └── score_page.dart             📝 Needed
│   │   └── profile/
│   │       └── profile_page.dart           📝 Needed
│   │
│   └── main.dart                            📝 Needed
│
├── assets/
│   ├── icons/                               📝 Add SVG icons
│   └── images/                              📝 Add images
│
├── pubspec.yaml                             ✅ Configured
└── README.md

```

## Migration Mapping

### 1. Dependencies

| React/TypeScript | Flutter Equivalent |
|------------------|-------------------|
| `react` | Flutter framework (built-in) |
| `zustand` | `flutter_riverpod` |
| `framer-motion` | `flutter_animate` |
| `@faker-js/faker` | `faker` package |
| Tailwind CSS | `design_tokens.dart` + Flutter styling |
| Custom fonts | `google_fonts` package |

### 2. Design System

**React (`design-tokens.ts`)** → **Flutter (`design_tokens.dart`)**

- Colors: Migrated to `Color` constants
- Spacing: Migrated to `double` constants
- Typography: Implemented with Google Fonts
- Shadows: Converted to `BoxShadow` lists
- Animations: Using Flutter's `Duration` and `Curve`

### 3. State Management

**Zustand Store** → **Riverpod Providers**

```typescript
// React (Zustand)
const useAppStore = create((set) => ({
  activeTab: 'home',
  setActiveTab: (tab) => set({ activeTab: tab }),
  ...
}));
```

```dart
// Flutter (Riverpod)
final activeTabProvider = StateProvider<String>((ref) => 'home');

// Usage
final activeTab = ref.watch(activeTabProvider);
ref.read(activeTabProvider.notifier).state = 'rounding';
```

### 4. Components to Widgets

| React Component | Flutter Widget | Status |
|----------------|----------------|--------|
| `PageContainer` | `PageContainer` widget | 📝 Needed |
| `PageHeader` | `PageHeader` widget | 📝 Needed |
| `CreateActionCard` | `CreateActionCard` widget | 📝 Needed |
| `RoundingCard` | `RoundingCard` widget | 📝 Needed |
| `GroupCard` | `GroupCard` widget | 📝 Needed |
| `ScoreCard` | `ScoreCard` widget | 📝 Needed |
| `Avatar` | `Avatar` widget | 📝 Needed |
| `Badge` | `Badge` widget | 📝 Needed |
| `Button` | `ElevatedButton`/`TextButton` | Built-in |

### 5. Pages/Screens

| React Page | Flutter Screen | Status |
|-----------|---------------|--------|
| `HomePage.tsx` | `home_page.dart` | 📝 Needed |
| `RoundingPage.tsx` | `rounding_page.dart` | 📝 Needed |
| `GroupsPage.tsx` | `groups_page.dart` | 📝 Needed |
| `ScorePage.tsx` | `score_page.dart` | 📝 Needed |
| `ProfilePage.tsx` | `profile_page.dart` | 📝 Needed |

### 6. Hooks to Providers

| React Hook | Flutter Provider | Status |
|-----------|-----------------|--------|
| `useMockData` | `mockDataProvider` | 📝 Needed |
| `useHomeData` | `homeDataProvider` | 📝 Needed |
| `useRoundingData` | `roundingDataProvider` | 📝 Needed |
| `useGroupData` | `groupDataProvider` | 📝 Needed |
| `useScoreData` | `scoreDataProvider` | 📝 Needed |
| `useFilteredData` | `FilteredDataNotifier` class | 📝 Needed |

## Quick Start Example

Here's a minimal working Flutter app structure:

### main.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MTCNGolfApp(),
    ),
  );
}

class MTCNGolfApp extends StatelessWidget {
  const MTCNGolfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MTCN Golf',
      theme: AppTheme.lightTheme,
      home: const MainNavigator(),
    );
  }
}

class MainNavigator extends ConsumerStatefulWidget {
  const MainNavigator({super.key});

  @override
  ConsumerState<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends ConsumerState<MainNavigator> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    RoundingPage(),
    GroupsPage(),
    ScorePage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: '라운딩'),
          BottomNavigationBarItem(icon: Icon(Icons.groups), label: '동문회'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: '스코어'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '프로필'),
        ],
      ),
    );
  }
}
```

## Key Differences & Best Practices

### 1. **Styling**
- React uses inline styles + Tailwind
- Flutter uses `Container`, `Padding`, `BoxDecoration`, etc.
- Use `DesignTokens` constants for consistency

### 2. **Animation**
```typescript
// React (Framer Motion)
<motion.div
  initial={{ opacity: 0, y: 20 }}
  animate={{ opacity: 1, y: 0 }}
  transition={{ duration: 0.5 }}
>
```

```dart
// Flutter (flutter_animate)
child.animate()
  .fadeIn(duration: 500.ms)
  .slideY(begin: 20, end: 0, duration: 500.ms);
```

### 3. **Conditional Rendering**
```typescript
// React
{isLoading ? <Loader /> : <Content />}
```

```dart
// Flutter
isLoading ? const Loader() : const Content()
```

### 4. **Lists**
```typescript
// React
{items.map(item => <ItemCard key={item.id} data={item} />)}
```

```dart
// Flutter
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    final item = items[index];
    return ItemCard(data: item);
  },
)
```

## Next Steps

1. **Install dependencies**: `cd mtcn_flutter && flutter pub get`
2. **Create remaining models** (Group, ScoreRecord, ChatMessage)
3. **Set up Riverpod providers** for state management
4. **Build widget library** (PageContainer, Cards, etc.)
5. **Implement screens** (HomePage, RoundingPage, etc.)
6. **Add animations** with flutter_animate
7. **Test on iOS/Android** simulators

## Commands

```bash
# Navigate to Flutter project
cd mtcn_flutter

# Get dependencies
flutter pub get

# Run on iOS simulator
flutter run -d ios

# Run on Android emulator
flutter run -d android

# Build for production
flutter build ios
flutter build android
```

## Notes

- Flutter is **strongly typed** - no `any` types
- **Immutability** is preferred - use `const` constructors
- **Performance** - Flutter compiles to native code (faster than React Native)
- **Hot reload** works similarly to React's Fast Refresh
- **State management** - Riverpod is more powerful than Zustand

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [Google Fonts Package](https://pub.dev/packages/google_fonts)
- [Flutter Animate](https://pub.dev/packages/flutter_animate)
