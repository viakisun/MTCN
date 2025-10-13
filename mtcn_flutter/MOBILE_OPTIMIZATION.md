# MTCN Golf - 모바일 앱 최적화 가이드

## 📱 모바일 출시 준비 완료

이 문서는 MTCN Golf 앱의 모바일 최적화 작업 내용을 정리한 가이드입니다.

---

## 🎯 완료된 최적화 작업

### 1. 스플래시 스크린
**위치:** `lib/screens/splash/splash_screen.dart`

**기능:**
- 앱 시작 시 브랜드 로고와 애니메이션 표시
- 2.5초 동안 실행 후 자동 전환
- 온보딩 완료 여부에 따라 온보딩/메인 화면으로 라우팅
- SharedPreferences를 통한 상태 관리

**사용 예:**
```dart
// 자동으로 main.dart에서 실행됨
home: const SplashScreen()
```

---

### 2. 온보딩 플로우
**위치:** `lib/screens/onboarding/onboarding_page.dart`

**기능:**
- 4개의 페이지로 구성된 인터랙티브 온보딩
- 스와이프 네비게이션 + 페이지 인디케이터
- 건너뛰기 기능
- 완료 시 SharedPreferences에 저장하여 재표시 방지

**온보딩 페이지:**
1. **프리미엄 골프 경험** - 골프장 소개
2. **동문회와 함께** - 네트워킹 기능
3. **스코어 관리** - 기록 관리 기능
4. **지금 시작하세요** - CTA

**상태 관리:**
```dart
// 온보딩 완료 체크
bool hasCompletedOnboarding = Prefs.hasCompletedOnboarding;

// 온보딩 완료 마크
await Prefs.setOnboardingComplete();

// 테스트를 위한 리셋
await Prefs.reset();
```

---

### 3. 반응형 레이아웃 시스템
**위치:** `lib/core/utils/responsive.dart`

**기능:**
- 모바일 우선 반응형 디자인
- 화면 크기별 브레이크포인트 정의
- 반응형 값 계산 유틸리티

**브레이크포인트:**
```dart
- Mobile Small: 320px
- Mobile: 375px
- Mobile Large: 425px
- Tablet: 768px
- Desktop: 1024px+
```

**사용 예:**
```dart
// 화면 크기 체크
bool isMobile = Responsive.isMobile(context);

// 반응형 값 적용
double padding = Responsive.spacing(context, 16);

// 디바이스별 다른 값
Widget content = Responsive.value(
  context,
  mobile: MobileLayout(),
  tablet: TabletLayout(),
  desktop: DesktopLayout(),
);

// Extension 사용
padding: context.responsivePadding,
```

---

### 4. 모바일 최적화 네비게이션
**위치:** `lib/main.dart` - MainNavigator

**개선 사항:**
- **IndexedStack** 사용으로 탭 전환 시 상태 유지
- **Haptic Feedback** 추가 (탭 시 진동 피드백)
- **SafeArea** 적용으로 노치/홈 인디케이터 대응
- 더 큰 터치 영역 (48x48 최소 사이즈)
- 부드러운 그림자 효과

**시스템 UI 설정:**
```dart
// 상태바 투명화
SystemChrome.setSystemUIOverlayStyle(
  statusBarColor: Colors.transparent,
);

// Portrait 모드 고정
SystemChrome.setPreferredOrientations([
  DeviceOrientation.portraitUp,
  DeviceOrientation.portraitDown,
]);

// 텍스트 스케일 제한 (접근성)
textScaleFactor.clamp(0.8, 1.3)
```

---

### 5. 터치 최적화 버튼 컴포넌트
**위치:** `lib/widgets/common/mobile_button.dart`

**컴포넌트:**

#### MobileButton
```dart
MobileButton(
  label: '확인',
  icon: Icons.check,
  onPressed: () {},
  style: MobileButtonStyle.primary,
  size: MobileButtonSize.medium,
  fullWidth: true,
  isLoading: false,
)
```

**스타일:**
- `primary` - 주요 액션 (초록색)
- `secondary` - 보조 액션 (파란색)
- `outlined` - 테두리 버튼
- `ghost` - 투명 버튼
- `danger` - 위험 액션 (빨간색)

**크기:**
- `small` - 40px 높이
- `medium` - 48px 높이 (기본, 터치 최소 크기)
- `large` - 56px 높이

#### MobileIconButton
```dart
MobileIconButton(
  icon: Icons.settings,
  onPressed: () {},
  tooltip: '설정',
  color: DesignTokens.primary600,
)
```

#### MobileFAB
```dart
MobileFAB(
  icon: Icons.add,
  label: '새 라운딩',
  onPressed: () {},
  isExtended: true,
)
```

---

### 6. Pull-to-Refresh
**위치:** 이미 홈 페이지에 구현됨

**기능:**
- 아래로 당겨서 새로고침
- 로딩 인디케이터 표시
- 데이터 provider 재로딩

**사용 예:**
```dart
RefreshIndicator(
  onRefresh: () async {
    await Future.delayed(Duration(seconds: 1));
    ref.invalidate(dataProvider);
  },
  color: DesignTokens.primary600,
  child: ListView(...),
)
```

---

### 7. 이미지 캐싱 (준비 완료)
**패키지:** `cached_network_image: ^3.4.1`

**사용 예:**
```dart
CachedNetworkImage(
  imageUrl: player.avatarUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
  fadeInDuration: Duration(milliseconds: 300),
)
```

**장점:**
- 자동 디스크 캐싱
- 네트워크 사용량 감소
- 로딩 속도 향상
- 오프라인 대응

---

## 📋 구현 체크리스트

### ✅ 완료된 항목
- [x] 스플래시 스크린
- [x] 온보딩 플로우
- [x] 반응형 레이아웃 시스템
- [x] 모바일 네비게이션 최적화
- [x] Haptic Feedback
- [x] 터치 최적화 버튼 컴포넌트
- [x] Pull-to-Refresh (홈 페이지)
- [x] SharedPreferences 통합
- [x] CachedNetworkImage 패키지 추가
- [x] 시스템 UI 최적화

### 🔄 선택적 추가 작업
- [ ] 앱 아이콘 생성
- [ ] Android/iOS 런처 설정
- [ ] Deep linking 구현
- [ ] Push notification 준비
- [ ] Analytics 통합
- [ ] Crashlytics 통합
- [ ] 무한 스크롤 (Pagination)
- [ ] Swipe to delete 제스처

---

## 🚀 출시 전 체크리스트

### 앱 메타데이터
- [ ] 앱 이름 확정: "MTCN Golf"
- [ ] 번들 ID 설정
  - iOS: `com.mtcn.golf`
  - Android: `com.mtcn.golf`
- [ ] 버전 관리: `1.0.0+1`

### 아이콘 & 스플래시
- [ ] 앱 아이콘 디자인 (1024x1024)
- [ ] Android Adaptive Icon
- [ ] iOS App Icon Set
- [ ] 런처 스플래시 스크린 설정

### 권한 설정
- [ ] Android Manifest 권한 검토
- [ ] iOS Info.plist 권한 설명 추가
- [ ] 위치 권한 (골프장 찾기)
- [ ] 카메라 권한 (프로필 사진)
- [ ] 사진 라이브러리 권한

### 성능 & 최적화
- [ ] 릴리스 빌드 테스트
- [ ] ProGuard 설정 (Android)
- [ ] Bitcode 설정 (iOS)
- [ ] 앱 사이즈 최적화
- [ ] 메모리 누수 체크

### 스토어 준비
- [ ] 스크린샷 (6.5", 5.5" for iOS / Phone, Tablet for Android)
- [ ] 앱 설명 작성
- [ ] 개인정보 처리방침
- [ ] 이용약관
- [ ] 앱 미리보기 비디오 (선택)

---

## 📖 모바일 앱 개발 가이드

### 1. 버튼 사용 가이드
```dart
// ✅ Good: 모바일 최적화 버튼 사용
MobileButton(
  label: '라운딩 시작',
  onPressed: () {},
  fullWidth: true,
)

// ❌ Bad: 기본 버튼 (터치 영역 작음)
TextButton(
  onPressed: () {},
  child: Text('라운딩 시작'),
)
```

### 2. 반응형 레이아웃
```dart
// ✅ Good: 반응형 값 사용
padding: EdgeInsets.all(Responsive.spacing(context, 16))

// ❌ Bad: 고정 값
padding: EdgeInsets.all(16)
```

### 3. 이미지 로딩
```dart
// ✅ Good: 캐시된 네트워크 이미지
CachedNetworkImage(
  imageUrl: url,
  placeholder: (context, url) => ShimmerPlaceholder(),
)

// ❌ Bad: 기본 네트워크 이미지 (캐싱 없음)
Image.network(url)
```

### 4. 리스트 성능
```dart
// ✅ Good: ListView.builder (lazy loading)
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)

// ❌ Bad: ListView (전체 로딩)
ListView(
  children: items.map((item) => ItemWidget(item)).toList(),
)
```

### 5. 상태 유지
```dart
// ✅ Good: IndexedStack (상태 유지)
IndexedStack(
  index: currentIndex,
  children: pages,
)

// ❌ Bad: 직접 렌더링 (상태 손실)
pages[currentIndex]
```

---

## 🎨 디자인 토큰 활용

모든 UI 컴포넌트는 `DesignTokens`를 사용하여 일관성을 유지합니다:

```dart
// 색상
DesignTokens.primary600
DesignTokens.textPrimary
DesignTokens.surfacePrimary

// 간격
DesignTokens.spacing4
DesignTokens.spacing8

// 폰트
DesignTokens.fontBase
DesignTokens.fontBold

// 반경
DesignTokens.radiusLg
DesignTokens.radiusXl

// 그림자
boxShadow: DesignTokens.shadowMd
```

---

## 📱 테스트 가이드

### 디바이스 테스트 매트릭스

**필수 테스트:**
1. iPhone SE (Small Screen)
2. iPhone 14 Pro (Medium Screen)
3. iPhone 14 Pro Max (Large Screen)
4. iPad Pro 11" (Tablet)
5. Android Pixel 5 (Medium)
6. Android Galaxy S23 (Large)
7. Android Tablet (10")

**테스트 항목:**
- [ ] 스플래시 스크린 정상 동작
- [ ] 온보딩 플로우 (첫 실행 시)
- [ ] 온보딩 스킵 기능
- [ ] 탭 네비게이션 (상태 유지 확인)
- [ ] Pull-to-refresh
- [ ] 버튼 터치 영역 (48x48 최소)
- [ ] Haptic Feedback
- [ ] 회전 제한 (Portrait only)
- [ ] 노치/홈 인디케이터 대응
- [ ] 다크 모드 (향후 지원 시)

---

## 🔧 트러블슈팅

### Q: 온보딩을 다시 보고 싶어요
```dart
// 온보딩 리셋 (개발/테스트용)
await Prefs.reset();
```

### Q: Haptic이 작동하지 않아요
- iOS: 시뮬레이터에서는 작동하지 않습니다. 실제 기기에서 테스트하세요.
- Android: 일부 기기는 햅틱을 지원하지 않습니다.

### Q: 이미지가 캐싱되지 않아요
```dart
// 캐시 클리어
await DefaultCacheManager().emptyCache();

// 특정 이미지 캐시 제거
await DefaultCacheManager().removeFile(url);
```

---

## 📊 성능 목표

**앱 시작 시간:**
- Cold start: < 3초
- Warm start: < 1초

**메모리 사용량:**
- Idle: < 100MB
- Active use: < 250MB

**네트워크:**
- 이미지 캐싱으로 50% 이상 절감

**배터리:**
- 1시간 사용 시 < 5% 배터리 소모

---

## 🌟 다음 단계

1. **앱 아이콘 생성**
   - `flutter_launcher_icons` 패키지 사용
   - 1024x1024 마스터 이미지 준비

2. **스토어 등록**
   - Apple Developer 계정
   - Google Play Console 계정

3. **백엔드 연동**
   - API 엔드포인트 연결
   - 인증 시스템 구현

4. **고급 기능**
   - Push Notification
   - Deep Linking
   - Social Login
   - Analytics

---

**작성일:** 2025-10-05
**버전:** 1.0.0
**작성자:** MTCN Golf Development Team
