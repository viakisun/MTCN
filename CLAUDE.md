# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MTCN is a premium golf course management application built with React, TypeScript, and Vite. The app is optimized for iPhone 16 Pro and features a modern design system inspired by Australian golf courses. It uses Zustand for state management, Framer Motion for animations, and Tailwind CSS with custom design tokens.

**Live Demo**: https://viakisun.github.io/MTCN/

## Development Commands

```bash
# Install dependencies
npm install

# Start development server (opens on localhost:3000)
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview

# Lint code
npm run lint
```

## Architecture

### State Management (Zustand)

The entire application state is centralized in `/src/lib/store.ts` using Zustand:
- **Navigation state**: `activeTab`, `setActiveTab`
- **Game state**: `isGameActive`, `currentHole`, `spectatorMode`
- **Data collections**: `players`, `groups`, `roundings`, `scoreRecords`, `messages`
- **Demo mode**: `isDemoMode`, `demoStep` for automated demos

All pages and components should access state through `useAppStore()` hook.

### Environment-Aware Rendering

The app has two rendering modes controlled by `/src/utils/environment.ts`:

1. **Development mode** (`shouldUsePhoneFrame = true`): Renders inside iPhone 16 Pro frame with Dynamic Island
2. **Production mode** (`shouldUsePhoneFrame = false`): Renders as full web layout with WebHeader and WebBottomNav

The mode is automatically determined based on `import.meta.env.PROD` and GitHub Pages detection. The App component (`/src/App.tsx`) switches between modes accordingly.

### Mock Data System

All mock data is generated using `@faker-js/faker` in the `/src/data/` directory:
- `players.ts` - Korean names with stable avatar URLs (DiceBear, UI Avatars, RoboHash)
- `roundings.ts` - Golf course roundings with events, weather, players
- `groups.ts` - Alumni groups with members
- `scores.ts` - Score records with detailed statistics
- `chat.ts` - Chat messages for group conversations

Mock data is initialized once via `useMockData()` hook called in HomePage, which populates the Zustand store.

### Custom Hooks Pattern

All page-level data logic is abstracted into custom hooks in `/src/hooks/`:
- `useHomeData()` - Filters upcoming rounding, recent scores, group activities
- `useRoundingData()` - Provides rounding list with filtering logic
- `useScoreData()` - Provides score records with statistics calculations
- `useGroupData()` - Provides groups with filtering and chat messages
- `useProfileData()` - Provides current user and statistics

These hooks consume data from Zustand store and apply page-specific transformations.

### Design System

The design system is centralized in `/src/styles/design-tokens.ts`:

**Color Palette**: Australian golf course theme with terracotta (primary), gold (secondary), eucalyptus green (accent)
- Primary: Terracotta/amber shades inspired by Australian landscape
- Secondary: Gold tones from Australian gold rush
- Semantic: Standard success/warning/error/info colors
- Gradients: Natural Australian themes (terracotta, gold, eucalyptus, sunset, sandstone)

**Typography**: Inter for UI, Playfair Display for headers, JetBrains Mono for code
**Spacing**: 8px-based system with both numeric (1-96) and semantic (xs-5xl) scales
**iPhone 16 Pro specs**: Dynamic Island dimensions, safe areas, notch dimensions
**Golf-specific**: Status colors (scheduled/inProgress/completed), card styles, navigation styles

### Icon System

All icons are custom SVG components in `/src/components/icons/GolfIcons.tsx`. **No emoji usage** - professional vector icons only.

Categories:
- Golf icons: golf-ball, flag, golf-club, trophy, tee, green
- Weather icons: sunny, cloudy, rainy, windy
- Navigation icons: home, calendar, chart, profile
- UI icons: search, close, filter, clock, location, user, users

Use `getIconComponent(iconName, props)` helper for dynamic icon rendering with consistent sizing and colors.

### Component Organization

```
src/components/
├── business/      # Domain logic components (ScoreSummary, GroupActivity, etc.)
├── game/          # Game-specific components (LiveScoreboard, GolfCourseMap, CheerChat)
├── icons/         # SVG icon system (GolfIcons.tsx)
├── layout/        # Layout components (PhoneFrame, HeaderBar, BottomNav, StatusBar, WebHeader, WebBottomNav)
├── pages/         # Full page components (HomePage, RoundingPage, GroupsPage, ScorePage, ProfilePage, etc.)
└── ui/            # Reusable UI primitives (Card, Button, Avatar, Badge, etc.)
```

Page components are rendered by App.tsx based on `activeTab` state with AnimatePresence for transitions.

### Path Aliases

TypeScript and Vite are configured with `@/*` alias pointing to `src/*`:
```typescript
import { useAppStore } from '@/lib/store';
import { designTokens } from '@/styles/design-tokens';
import { Player } from '@/types';
```

Always use the `@/` alias for imports within the src directory.

## Deployment

The app is deployed to GitHub Pages automatically via `.github/workflows/deploy.yml` on every push to main branch. The `base` path in `vite.config.ts` is set to `/MTCN/` for GitHub Pages compatibility.

## Important Patterns

1. **Avatar URL handling**: Use stable avatar services (DiceBear, UI Avatars, RoboHash) to avoid broken images
2. **Korean localization**: Mock data uses Korean names and language for UI text
3. **Responsive design**: iPhone 16 Pro optimized (402×874px viewport) with safe area handling
4. **Animation**: Use Framer Motion for page transitions and micro-interactions
5. **Type safety**: All data structures are defined in `/src/types/index.ts` with strict TypeScript
6. **Styling**: Use inline styles with design tokens, NOT Tailwind classes (except for utility classes like flex-1)

## Key Files

- `/src/App.tsx` - Main app component with environment-aware rendering
- `/src/lib/store.ts` - Zustand state management
- `/src/styles/design-tokens.ts` - Complete design system
- `/src/types/index.ts` - TypeScript type definitions
- `/src/data/index.ts` - Mock data generation entry point
- `/vite.config.ts` - Build configuration with GitHub Pages base path
