# MTCN Golf - Architecture Documentation

## 프로젝트 구조

```
lib/
├── main.dart                  # 앱 진입점
│
├── core/                      # 핵심 기능
│   ├── theme/
│   │   ├── app_theme.dart           # 테마 설정
│   │   └── design_tokens.dart       # 디자인 토큰 (색상, 간격, 폰트 등)
│   └── api/                         # (추후) API 클라이언트
│
├── data/                      # 데이터 계층 (NEW!)
│   ├── mock/                        # 목업 데이터
│   │   ├── mock_players.dart
│   │   ├── mock_groups.dart
│   │   ├── mock_roundings.dart
│   │   └── mock_scores.dart
│   └── repositories/                # Repository 패턴
│       ├── player_repository.dart
│       ├── group_repository.dart
│       ├── rounding_repository.dart
│       └── score_repository.dart
│
├── models/                    # 데이터 모델
│   ├── player.dart
│   ├── group.dart
│   ├── rounding.dart
│   ├── score.dart
│   └── score_record.dart
│
├── providers/                 # 상태 관리 (Riverpod)
│   ├── filter_provider.dart
│   └── (기타 providers)
│
├── screens/                   # 화면 (페이지)
│   ├── home/
│   ├── rounding/
│   ├── groups/
│   ├── score/
│   └── profile/
│
└── widgets/                   # 재사용 컴포넌트
    ├── common/                      # 공통 위젯 (NEW!)
    │   ├── search/
    │   │   └── search_bar_widget.dart
    │   ├── filter/
    │   │   └── filter_chip_list.dart
    │   ├── states/
    │   │   ├── empty_state.dart
    │   │   ├── loading_state.dart
    │   │   └── error_state.dart
    │   ├── avatar.dart
    │   ├── badge.dart
    │   ├── status_badge.dart
    │   ├── premium_card.dart
    │   ├── premium_button.dart
    │   └── section_header.dart
    ├── cards/                       # 카드 컴포넌트
    │   ├── group_card.dart
    │   ├── rounding_card.dart
    │   └── score_card.dart
    └── charts/                      # 차트 컴포넌트
        └── score_trend_chart.dart
```

## 아키텍처 레이어

### 1. Presentation Layer (UI)
**위치:** `lib/screens/`, `lib/widgets/`

**책임:**
- 사용자 인터페이스 렌더링
- 사용자 입력 처리
- 상태 변화 반영

**예시:**
```dart
// lib/screens/groups/groups_page.dart
class GroupsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(groupsProvider);
    // UI 렌더링
  }
}
```

### 2. Business Logic Layer (Providers)
**위치:** `lib/providers/`

**책임:**
- 상태 관리
- 비즈니스 로직
- Repository 호출

**예시:**
```dart
// lib/providers/groups_provider.dart
final groupRepositoryProvider = Provider<GroupRepository>((ref) {
  return MockGroupRepository();
});

final groupsProvider = FutureProvider<List<Group>>((ref) async {
  final repository = ref.watch(groupRepositoryProvider);
  return await repository.getAllGroups();
});
```

### 3. Data Layer (Repository Pattern)
**위치:** `lib/data/repositories/`

**책임:**
- 데이터 접근 추상화
- Mock/API 데이터 소스 전환
- 데이터 변환 로직

**예시:**
```dart
// lib/data/repositories/group_repository.dart
abstract class GroupRepository {
  Future<List<Group>> getAllGroups();
  Future<Group> getGroupById(String id);
  // ...
}

class MockGroupRepository implements GroupRepository {
  @override
  Future<List<Group>> getAllGroups() async {
    return MockGroups.all;
  }
}

// 나중에 추가
class ApiGroupRepository implements GroupRepository {
  final ApiClient client;

  @override
  Future<List<Group>> getAllGroups() async {
    final response = await client.get('/groups');
    return response.data.map((json) => Group.fromJson(json)).toList();
  }
}
```

### 4. Model Layer
**위치:** `lib/models/`

**책임:**
- 데이터 구조 정의
- JSON 직렬화/역직렬화
- 비즈니스 규칙 (computed properties)

**예시:**
```dart
// lib/models/group.dart
class Group {
  final String id;
  final String name;
  // ...

  // Computed property
  bool get isNew {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    return difference.inDays <= 7;
  }

  // JSON 직렬화
  Map<String, dynamic> toJson() { ... }
  factory Group.fromJson(Map<String, dynamic> json) { ... }
}
```

## 데이터 흐름

```
┌─────────────┐
│    UI       │ ← 사용자 인터랙션
│  (Screen)   │
└──────┬──────┘
       │ ref.watch(provider)
       ↓
┌──────────────┐
│   Provider   │ ← 상태 관리
│ (Riverpod)   │
└──────┬───────┘
       │ repository.method()
       ↓
┌──────────────┐
│  Repository  │ ← 데이터 접근 추상화
└──────┬───────┘
       │
       ├─→ [Mock Data] ← 개발 중
       │
       └─→ [API Client] ← 프로덕션 (추후)
```

## 주요 패턴

### 1. Repository Pattern
**목적:** 데이터 소스를 추상화하여 비즈니스 로직과 분리

**장점:**
- Mock → API 전환 용이
- 테스트 가능성 향상
- 관심사 분리

**사용 예:**
```dart
// 개발 환경
final repository = MockPlayerRepository();

// 프로덕션 환경
final repository = ApiPlayerRepository(apiClient);
```

### 2. Provider Pattern (Riverpod)
**목적:** 반응형 상태 관리

**종류:**
- `Provider`: 불변 값 제공
- `FutureProvider`: 비동기 데이터
- `StateProvider`: 간단한 상태
- `StateNotifierProvider`: 복잡한 상태 로직

### 3. Widget Composition
**목적:** 재사용 가능한 UI 컴포넌트 구축

**계층:**
```
Page (Screen)
  ├─ Layout Widgets
  ├─ Card Components
  │   ├─ Common Widgets
  │   └─ Atomic Components
  └─ State Components (Empty/Loading/Error)
```

## 재사용 가능한 컴포넌트

### Common Widgets

#### 1. SearchBarWidget
```dart
SearchBarWidget(
  hintText: '검색...',
  onChanged: (value) => handleSearch(value),
)
```

#### 2. FilterChipList
```dart
FilterChipList(
  options: [
    FilterOption(label: '전체', value: 'all'),
    FilterOption(label: '활성', value: 'active'),
  ],
  activeValue: currentFilter,
  onChanged: (value) => updateFilter(value),
)
```

#### 3. EmptyState
```dart
// 검색 결과 없음
EmptyState.search(query: '골프')

// 아이템 없음
EmptyState.noItems(
  itemName: '그룹',
  actionLabel: '그룹 만들기',
  onAction: () => createGroup(),
)
```

#### 4. LoadingState
```dart
LoadingState(message: '데이터 로딩 중...')
```

#### 5. ErrorState
```dart
ErrorState(
  title: '오류 발생',
  message: '네트워크 연결을 확인해주세요',
  onRetry: () => retry(),
)
```

## 디자인 시스템

### Design Tokens
**위치:** `lib/core/theme/design_tokens.dart`

**제공:**
- 색상 팔레트 (Primary, Secondary, Semantic)
- 타이포그래피 (Font sizes, weights)
- 간격 (Spacing scale)
- 반경 (Border radius)
- 그림자 (Shadow levels)
- 그라데이션
- 블러 효과

### Premium Components

#### PremiumCard
4가지 스타일:
- `elevated` - 그림자 효과
- `glass` - Glassmorphism
- `gradient` - 그라데이션 배경
- `outlined` - 테두리

#### PremiumButton
5가지 스타일:
- `primary` - 주요 액션
- `secondary` - 보조 액션
- `outline` - 테두리 버튼
- `ghost` - 투명 버튼
- `gradient` - 그라데이션 버튼

#### StatusBadge
상태 표시:
- 색상 변형 (success, warning, error, info, live)
- Pulse 애니메이션 (live 상태)
- 아이콘 지원

## 백엔드 연동 가이드

### Step 1: API Client 구현
```dart
// lib/core/api/api_client.dart
class ApiClient {
  final Dio dio;
  final String baseUrl;

  ApiClient({required this.baseUrl}) :
    dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<Response> get(String path) async {
    return await dio.get(path);
  }

  Future<Response> post(String path, dynamic data) async {
    return await dio.post(path, data: data);
  }
}
```

### Step 2: API Repository 구현
```dart
// lib/data/repositories/player_repository.dart
class ApiPlayerRepository implements PlayerRepository {
  final ApiClient client;

  ApiPlayerRepository(this.client);

  @override
  Future<List<Player>> getAllPlayers() async {
    final response = await client.get('/api/players');
    return (response.data as List)
      .map((json) => Player.fromJson(json))
      .toList();
  }
}
```

### Step 3: Provider 설정
```dart
// lib/providers/api_providers.dart
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: 'https://api.mtcngolf.com');
});

final playerRepositoryProvider = Provider<PlayerRepository>((ref) {
  // 개발 환경
  if (kDebugMode) {
    return MockPlayerRepository();
  }

  // 프로덕션 환경
  final apiClient = ref.watch(apiClientProvider);
  return ApiPlayerRepository(apiClient);
});
```

### Step 4: Error Handling
```dart
final playersProvider = FutureProvider<List<Player>>((ref) async {
  try {
    final repository = ref.watch(playerRepositoryProvider);
    return await repository.getAllPlayers();
  } catch (e) {
    // 에러 처리
    rethrow;
  }
});
```

### Step 5: UI에서 사용
```dart
class PlayersPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playersAsync = ref.watch(playersProvider);

    return playersAsync.when(
      data: (players) => ListView.builder(...),
      loading: () => LoadingState(),
      error: (error, stack) => ErrorState(
        message: error.toString(),
        onRetry: () => ref.refresh(playersProvider),
      ),
    );
  }
}
```

## 테스팅 전략

### Unit Tests
Repository와 Provider 테스트:
```dart
test('PlayerRepository returns all players', () async {
  final repo = MockPlayerRepository();
  final players = await repo.getAllPlayers();

  expect(players.length, greaterThan(0));
});
```

### Widget Tests
UI 컴포넌트 테스트:
```dart
testWidgets('EmptyState displays correctly', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: EmptyState.noItems(itemName: '그룹'),
    ),
  );

  expect(find.text('그룹이(가) 없습니다'), findsOneWidget);
});
```

### Integration Tests
Provider with Repository:
```dart
testWidgets('GroupsPage loads and displays groups', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        groupRepositoryProvider.overrideWithValue(MockGroupRepository()),
      ],
      child: MaterialApp(home: GroupsPage()),
    ),
  );

  await tester.pumpAndSettle();

  expect(find.byType(GroupCard), findsWidgets);
});
```

## 성능 최적화

### 1. Provider 최적화
```dart
// ✅ Good: 필요한 데이터만 선택
final groupName = ref.watch(groupProvider.select((g) => g.name));

// ❌ Bad: 전체 객체를 watch
final group = ref.watch(groupProvider);
```

### 2. Widget 최적화
```dart
// const 생성자 사용
const Text('Hello')

// ListView.builder 사용 (대신 ListView)
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)
```

### 3. Image 캐싱
```dart
CachedNetworkImage(
  imageUrl: player.avatarUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
)
```

## 코드 컨벤션

### 1. 파일 명명
- 파일명: `snake_case.dart`
- 클래스명: `PascalCase`
- 변수/함수: `camelCase`

### 2. 폴더 구조
- 기능별 모듈화
- 관련 파일들을 함께 배치

### 3. 주석
```dart
/// Public API에는 문서 주석
///
/// [GroupRepository]는 그룹 데이터 접근을 추상화합니다.
abstract class GroupRepository {
  // 구현 상세는 일반 주석
  // TODO: 페이지네이션 추가 필요
}
```

## 환경 설정

### Development
- Mock Repository 사용
- 상세한 로깅
- 디버그 모드 활성화

### Staging
- API Repository 사용
- 스테이징 서버 URL
- 에러 리포팅 활성화

### Production
- API Repository 사용
- 프로덕션 서버 URL
- Analytics 활성화
- 최소 로깅

---

**작성일:** 2025-10-05
**버전:** 1.0.0
**작성자:** MTCN Golf Development Team
