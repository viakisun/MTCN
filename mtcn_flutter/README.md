# mtcn_golf

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Development Setup

### Pre-commit Hooks

이 프로젝트는 [Lefthook](https://github.com/evilmartians/lefthook)을 사용하여 커밋 전 자동으로 코드 품질을 검사합니다.

#### Lefthook 설치

**macOS (Homebrew):**
```bash
brew install lefthook
```

**다른 플랫폼:**
- **Linux/WSL:** `curl -1sLf 'https://dl.cloudsmith.io/public/evilmartians/lefthook/setup.deb.sh' | sudo -E bash && sudo apt install lefthook`
- **직접 다운로드:** [Releases 페이지](https://github.com/evilmartians/lefthook/releases)에서 다운로드

#### Git Hooks 활성화

Lefthook 설치 후 프로젝트 루트에서 다음 명령어를 실행하세요:

```bash
cd /Users/adminvia/devwork/_evt/MTCN
lefthook install
```

#### Pre-commit Hook 동작

커밋 시 자동으로 다음 작업이 순차적으로 실행됩니다:

1. **자동 포맷팅** (`dart format`): staged된 Dart 파일을 자동으로 포맷팅하고 변경사항을 다시 stage합니다.
2. **정적 분석** (`flutter analyze`): 코드 오류, 경고, 린트 문제를 검사합니다.
3. **테스트 실행** (`flutter test`): 모든 테스트를 실행하여 기능 회귀를 방지합니다.

#### 유용한 명령어

```bash
# Pre-commit hook 수동 실행
lefthook run pre-commit

# 특정 커밋에서 hook 비활성화
LEFTHOOK=0 git commit -m "message"

# Hook 상태 확인
lefthook version
```

#### 참고사항

- 첫 커밋 시 테스트 실행으로 인해 시간이 소요될 수 있습니다.
- 포맷팅 오류는 자동으로 수정되며, 분석 오류나 테스트 실패 시 커밋이 차단됩니다.
- Flutter SDK가 설치되어 있어야 합니다.
