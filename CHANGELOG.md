# Changelog

All notable changes to this project will be documented in this file.

## [0.1.1] - 2025-01-14

### 🐛 Bug Fixes
- **CORS 에러 해결**: `pravatar.cc` 이미지 로딩 문제를 `via.placeholder.com`으로 해결
- **MockDatabaseService 인덱스 에러**: `players[3]` 접근 문제 해결을 위해 4번째 플레이어 추가
- **변수 스코프 에러**: `player.name`을 `name`으로 수정하여 컴파일 에러 해결
- **Import 참조 오류**: `.bak` 파일들 삭제 및 존재하지 않는 파일 참조 제거

### 🔧 Technical Improvements
- **Clean Architecture 적용**: Core, Domain, Data, Presentation 레이어 분리
- **MockDatabaseService 구현**: 완전한 CRUD 기능을 가진 모킹 서비스 구현
- **Enum 구조화**: Group, Chat, Score, Rounding 관련 enum들을 별도 파일로 분리
- **Model 통합**: 중복 모델 정의 제거 및 `lib/data/models/` 구조로 통일

### 🎨 UI/UX Enhancements
- **GroupCard 복원**: 임시 Container를 실제 GroupCard 위젯으로 교체
- **아바타 시스템 개선**: CORS 안전한 플레이스홀더 이미지 시스템 구현
- **프리미엄 그룹 표시**: isPremium 필드 추가 및 UI 반영
- **그룹 크기 등급**: GroupSizeTier enum을 통한 그룹 분류 시스템

### 📱 App Features
- **버전 정보 표시**: 프로필 페이지에서 앱 버전 정보 확인 가능
- **앱 정보 다이얼로그**: "몇타치니(MTCN)" 앱 소개 및 버전 정보 표시
- **동적 플레이스홀더**: 사용자 이름 기반 커스텀 아바타 생성

### 🏗️ Architecture Changes
- **Service Locator 패턴**: 의존성 주입을 위한 서비스 로케이터 구현
- **Repository 패턴**: 데이터 접근 계층 추상화
- **Result 타입**: 성공/실패 처리를 위한 타입 안전한 결과 처리
- **Provider 최적화**: Riverpod 기반 상태 관리 개선

### 📊 Data Structure
- **Player 모델 확장**: firstName, lastName 필드 추가
- **Group 모델 확장**: isPremium, image, roundCount 필드 추가
- **GroupMember 모델**: Player 참조 및 추가 필드들 구현
- **Mock 데이터 풍부화**: 4명의 플레이어, 3개의 그룹, 다양한 라운딩 데이터

### 🧪 Quality Assurance
- **에러 제거**: 339개 → 0개 컴파일 에러로 100% 해결
- **빌드 안정성**: 모든 플랫폼에서 정상 빌드 확인
- **웹 호환성**: Flutter 웹에서 CORS 문제 해결
- **코드 품질**: 린트 규칙 준수 및 코드 포맷팅 개선

### 🔄 Migration Notes
- **Import 경로 변경**: `lib/models/` → `lib/data/models/` 경로 통일
- **Provider 업데이트**: 새로운 MockDatabaseService와 호환되도록 업데이트
- **Enum 사용법**: 새로운 enum 구조에 맞게 코드 업데이트

---

## [0.1.0] - 2025-01-14

### 🎉 Initial Release
- **기본 앱 구조**: Flutter 프로젝트 초기 설정
- **기본 UI 컴포넌트**: 기본적인 화면 및 위젯 구현
- **초기 모델 정의**: Player, Group, Rounding 등 기본 모델
- **기본 네비게이션**: 앱 내 화면 간 이동 구조

### 📱 Core Features
- **홈 화면**: 라운딩 및 그룹 정보 표시
- **프로필 화면**: 사용자 정보 및 설정
- **그룹 관리**: 그룹 생성 및 관리 기능
- **라운딩 관리**: 골프 라운딩 생성 및 추적

### 🎨 UI Components
- **Design Tokens**: 일관된 디자인 시스템
- **Avatar 시스템**: 사용자 아바타 표시
- **Card 컴포넌트**: 그룹, 라운딩, 스코어 카드
- **버튼 및 입력**: 다양한 UI 컴포넌트

### 🛠️ Development Setup
- **Git Hooks**: Lefthook을 통한 자동 코드 품질 관리
- **CI/CD**: GitHub Actions 워크플로우 설정
- **문서화**: README 및 QUICK_START 가이드
- **이슈 템플릿**: GitHub Issues 관리 시스템
