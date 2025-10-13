# 몇타치니(MTCN) 🏌️

골프를 사랑하는 사람들을 위한 프리미엄 모바일 애플리케이션입니다. 라운딩 관리, 스코어 추적, 그리고 골프 친구들과의 소통을 한 곳에서!

## 🎯 주요 기능

### 핵심 기능
- **라운딩 관리**: 친구들과 함께 골프 라운딩을 만들고 참여하세요
- **스코어 추적**: 라운딩 중 실시간으로 스코어를 입력하고 확인하세요
- **그룹 관리**: 골프 모임을 만들고 멤버들과 함께 관리하세요
- **실시간 리더보드**: 라운딩 중 실시간으로 순위를 확인하세요
- **스코어 기록**: 개인 성적을 상세한 분석과 함께 추적하세요
- **채팅 시스템**: 그룹 채팅으로 라운딩 중 소통하세요

### 고급 기능
- **AI 인사이트**: 개인화된 골프 팁과 성적 분석
- **GPS 추적**: 코스 지도와 거리 측정
- **QR 코드 체크인**: 빠르고 쉬운 라운딩 체크인
- **업적 시스템**: 업적을 달성하고 마일스톤을 축하하세요
- **프리미엄 기능**: 고급 분석과 독점 콘텐츠

## 📱 지원 플랫폼

- **Android**: API 레벨 21 이상 (Android 5.0 이상)
- **iOS**: iOS 12.0 이상
- **웹**: 최신 브라우저
- **데스크톱**: Windows, macOS, Linux (실험적)

## 🚀 빠른 시작

### 초보자를 위한 가이드

프로그래밍이 처음이신가요? 걱정하지 마세요! [QUICK_START.md](QUICK_START.md) 파일을 열어보세요.

이 가이드는:
- ✅ 컴퓨터에 필요한 프로그램 설치하기
- ✅ 앱 다운로드하고 설정하기
- ✅ 앱을 내 컴퓨터에서 실행하기
- ✅ 문제가 생겼을 때 해결하기

모든 과정을 **복사-붙여넣기**만 하면 되도록 친절하게 설명되어 있습니다!

### 개발자를 위한 빠른 시작

이미 Flutter를 사용해보신 분이라면:

```bash
# 저장소 복제
git clone https://github.com/your-username/mtcn-golf.git
cd mtcn-golf

# 의존성 설치
flutter pub get

# 앱 실행
flutter run
```

## 📁 프로젝트 구조

```
mtcn-golf/
├── lib/                          # Flutter 앱 코드
│   ├── core/                     # 핵심 유틸리티와 설정
│   │   ├── config/               # 앱 설정
│   │   ├── theme/                # 앱 테마와 디자인 토큰
│   │   └── utils/                # 유틸리티 함수
│   ├── data/                     # 데이터 레이어
│   │   ├── mock/                 # 개발용 모의 데이터
│   │   └── repositories/         # 데이터 저장소
│   ├── models/                   # 데이터 모델
│   ├── providers/                # Riverpod 상태 관리
│   ├── screens/                  # UI 화면
│   │   ├── groups/               # 그룹 관련 화면
│   │   ├── home/                 # 홈 화면
│   │   ├── profile/              # 프로필 화면
│   │   ├── rounding/             # 라운딩 관리 화면
│   │   ├── score/                # 스코어 추적 화면
│   │   └── splash/               # 스플래시 화면
│   ├── services/                 # 비즈니스 로직 서비스
│   ├── widgets/                  # 재사용 가능한 UI 컴포넌트
│   │   ├── cards/                # 카드 컴포넌트
│   │   ├── charts/               # 차트 컴포넌트
│   │   ├── common/               # 공통 UI 컴포넌트
│   │   └── live/                 # 실시간 기능 컴포넌트
│   └── main.dart                 # 앱 진입점
├── test/                         # 테스트 파일
├── assets/                       # 앱 에셋
│   ├── icons/                    # 앱 아이콘
│   └── images/                   # 이미지와 그래픽
├── android/                      # Android 전용 코드
├── ios/                          # iOS 전용 코드
├── web/                          # 웹 전용 코드
├── backend/                      # FastAPI 백엔드 서버
├── ui-mockups/                   # UI 디자인 참고 자료
├── pubspec.yaml                  # Flutter 의존성
├── analysis_options.yaml         # Dart 분석 규칙
├── lefthook.yml                  # 커밋 전 훅 설정
└── README.md                     # 이 파일
```

## 🛠️ 개발 환경 설정

### 필수 요구사항

앱을 실행하기 전에 다음 프로그램들이 필요합니다:

#### 모든 플랫폼 공통
- **Flutter SDK**: 버전 3.9.2 이상
- **Dart SDK**: Flutter에 포함되어 있음
- **IDE**: VS Code 또는 Android Studio (권장)
- **Git**: 버전 관리용

#### Android 개발용 (선택)
- **Android Studio**: 최신 버전
- **Android SDK**: API 레벨 33 이상
- **Java Development Kit (JDK)**: 버전 17 이상

#### iOS 개발용 (macOS만 해당)
- **Xcode**: 버전 15.0 이상
- **iOS 시뮬레이터**: Xcode에 포함
- **CocoaPods**: iOS 의존성 관리용

#### 백엔드 개발용 (선택)
- **Python**: 버전 3.10 이상
- **pip**: Python 패키지 관리자

### 설치 가이드

자세한 설치 방법은 [QUICK_START.md](QUICK_START.md)를 참고하세요!

## 🔧 개발 워크플로우

### 코드 품질 관리

이 프로젝트는 자동화된 코드 품질 도구를 사용합니다:

- **커밋 전 훅**: 자동 코드 포맷팅과 분석
- **Dart 분석**: 커스텀 규칙을 사용한 정적 코드 분석
- **테스트**: 유닛 테스트와 위젯 테스트

### 커밋 전 훅 설정

프로젝트는 [Lefthook](https://github.com/evilmartians/lefthook)을 사용합니다:

```bash
# Lefthook 설치 (macOS)
brew install lefthook

# Git 훅 활성화
lefthook install
```

훅은 자동으로:
1. `dart format`으로 Dart 코드 포맷팅
2. `flutter analyze`로 정적 분석 실행
3. `flutter test`로 테스트 실행

### 테스트 실행

```bash
# 모든 테스트 실행
flutter test

# 커버리지와 함께 테스트 실행
flutter test --coverage

# 특정 테스트 파일 실행
flutter test test/widget_test.dart
```

### 프로덕션 빌드

#### Android APK
```bash
flutter build apk --release
```

#### iOS 앱
```bash
flutter build ios --release
```

#### 웹 앱
```bash
flutter build web --release
```

## 🔌 백엔드 연동

앱에는 데이터 관리를 위한 FastAPI 백엔드가 포함되어 있습니다:

- **API 문서**: 로컬 실행 시 `/docs`에서 확인 가능
- **모의 데이터**: 한국어 골프 데이터로 미리 채워져 있음
- **엔드포인트**: 플레이어, 그룹, 라운딩, 스코어에 대한 전체 CRUD 작업

자세한 백엔드 설정과 API 문서는 [backend/README.md](backend/README.md)를 참고하세요.

## 🎨 디자인 시스템

앱은 포괄적인 디자인 시스템을 사용합니다:

- **디자인 토큰**: 일관된 간격, 색상, 타이포그래피
- **반응형 디자인**: 다양한 화면 크기에 적응하는 레이아웃
- **Material Design 3**: 최신 Material Design 원칙
- **커스텀 컴포넌트**: 재사용 가능한 UI 컴포넌트

## 🐛 문제 해결

### 자주 발생하는 문제

#### Flutter Doctor 문제
```bash
flutter doctor
```
권장 사항을 따라 문제를 해결하세요.

#### Android 빌드 문제
- Android SDK가 제대로 설치되었는지 확인
- `ANDROID_HOME` 환경 변수가 설정되었는지 확인
- 필요시 Android SDK 도구 업데이트

#### iOS 빌드 문제 (macOS)
- Xcode가 최신 버전인지 확인
- `ios/` 디렉토리에서 `pod install` 실행
- iOS 배포 타겟 호환성 확인

#### 의존성 문제
```bash
flutter clean
flutter pub get
```

### 성능 최적화

- 성능 테스트를 위해 `flutter run --profile` 사용
- Flutter Inspector로 메모리 사용량 모니터링
- 이미지와 에셋 최적화
- 가능한 곳에 `const` 생성자 사용

## 🤝 기여하기

기여를 환영합니다! 다음 가이드라인을 따라주세요:

1. **저장소 포크하기**
2. **기능 브랜치 생성**: `git checkout -b feature/멋진-기능`
3. **변경사항 커밋**: `git commit -m '멋진 기능 추가'`
4. **브랜치에 푸시**: `git push origin feature/멋진-기능`
5. **Pull Request 열기**

### 코드 스타일

- Dart/Flutter 스타일 가이드 준수
- 의미 있는 변수명과 함수명 사용
- 복잡한 로직에 주석 추가
- 새로운 기능에 테스트 작성

### 커밋 메시지

컨벤셔널 커밋 형식 사용:
- `feat:` 새로운 기능
- `fix:` 버그 수정
- `docs:` 문서 변경
- `style:` 포맷팅 변경
- `refactor:` 코드 리팩토링

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다 - 자세한 내용은 [LICENSE](LICENSE) 파일을 참고하세요.

## 🙏 감사의 말

- Flutter 팀의 놀라운 프레임워크
- Riverpod의 상태 관리
- FastAPI의 백엔드 프레임워크
- 모든 기여자와 테스터 분들

## 📞 지원

문제가 발생하거나 질문이 있으시면:

1. [Issues](https://github.com/your-username/mtcn-golf/issues) 페이지 확인
2. 상세한 정보와 함께 새 이슈 생성
3. 커뮤니티 토론에 참여

---

**즐거운 골프 되세요! 🏌️‍♂️⛳**