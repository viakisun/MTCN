# 🚀 몇타치니(MTCN) 빠른 시작 가이드

이 가이드는 프로그래밍을 한 번도 해본 적이 없는 분들도 몇타치니 앱을 자신의 컴퓨터에서 실행할 수 있도록 도와드립니다!

## 📋 준비물

- 컴퓨터 (Windows 또는 Mac)
- 인터넷 연결
- 약 30분~1시간의 시간

> 💡 **팁**: 이 가이드의 모든 명령어는 복사해서 붙여넣기만 하면 됩니다!

---

## 🪟 Windows 사용자를 위한 완벽 가이드

### 1단계: Flutter 다운로드 및 설치

Flutter는 앱을 만들 수 있게 해주는 도구입니다.

1. **웹 브라우저를 열고** 이 주소로 이동하세요:
   ```
   https://flutter.dev/docs/get-started/install/windows
   ```

2. **파란색 "Download Flutter SDK" 버튼**을 클릭하세요
   - `flutter_windows_3.x.x-stable.zip` 같은 파일이 다운로드됩니다

3. **다운로드한 파일의 압축을 풀어주세요**:
   - 다운로드한 파일을 찾으세요 (보통 "다운로드" 폴더에 있습니다)
   - 파일을 **오른쪽 클릭** → **압축 풀기** 선택
   - 압축을 풀 위치를 `C:\flutter`로 지정하세요
   - ⚠️ **중요**: 경로에 띄어쓰기나 한글이 없어야 합니다!

4. **Flutter를 시스템에 등록하기** (PATH 추가):
   
   **방법 1 - 그래픽 인터페이스 사용 (추천)**:
   - `Windows 키 + R`을 누르세요
   - `sysdm.cpl`을 입력하고 Enter를 누르세요
   - "환경 변수" 버튼을 클릭하세요
   - "사용자 변수" 아래에서 "Path"를 찾아 선택하고 "편집" 클릭
   - "새로 만들기" 클릭
   - `C:\flutter\bin`을 입력하세요 (여러분이 압축을 푼 경로에 맞게 수정)
   - 모든 창에서 "확인" 클릭

5. **제대로 설치되었는지 확인하기**:
   - `Windows 키 + R`을 누르세요
   - `cmd`를 입력하고 Enter를 누르세요 (검은 창이 열립니다)
   - 다음을 입력하고 Enter를 누르세요:
     ```cmd
     flutter --version
     ```
   - Flutter 버전 정보가 나오면 성공입니다! 🎉

### 2단계: Android Studio 설치

Android Studio는 앱을 테스트할 수 있는 가상 휴대폰을 제공합니다.

1. **Android Studio 다운로드**:
   - 웹 브라우저에서 이 주소로 이동: https://developer.android.com/studio
   - "Download Android Studio" 버튼 클릭

2. **설치 파일 실행**:
   - 다운로드한 `.exe` 파일을 더블클릭
   - 설치 마법사가 나타나면 **모든 기본 설정을 그대로** 두고 "다음" 클릭
   - 설치가 완료될 때까지 기다리세요 (시간이 좀 걸립니다)

3. **Android Studio 설정**:
   - Android Studio를 실행하세요
   - "More Actions" (또는 "추가 작업") → "SDK Manager" 클릭
   - "SDK Tools" 탭으로 이동
   - "Android SDK Command-line Tools (latest)" 항목을 체크
   - "Apply" (또는 "적용") 클릭하고 설치가 완료될 때까지 기다리세요

4. **가상 휴대폰 만들기** (AVD - Android Virtual Device):
   - Android Studio에서 "More Actions" → "AVD Manager" 클릭
   - "Create Virtual Device" (또는 "가상 기기 만들기") 클릭
   - "Phone" → "Pixel 4" 선택 → "Next" 클릭
   - "API 33" (Android 13) 다운로드하고 선택 → "Next" → "Finish" 클릭

### 3단계: Git 설치 (코드 다운로드 도구)

1. **Git 다운로드**: https://git-scm.com/download/win
2. **설치 파일 실행**: 다운로드한 파일을 더블클릭하고 **모든 기본 설정 그대로** 진행
3. **설치 확인**: 
   - 명령 프롬프트(cmd)를 열고 다음을 입력:
     ```cmd
     git --version
     ```
   - 버전 정보가 나오면 성공!

### 4단계: 몇타치니 앱 다운로드

1. **명령 프롬프트 열기**:
   - `Windows 키 + R` 누르기
   - `cmd` 입력하고 Enter

2. **작업할 폴더 만들기**:
   다음 명령어를 **하나씩** 복사해서 붙여넣고 Enter를 누르세요:
   ```cmd
   cd C:\
   mkdir projects
   cd projects
   ```

3. **앱 코드 다운로드**:
   ```cmd
   git clone https://github.com/your-username/mtcn-golf.git
   cd mtcn-golf
   ```
   > 📝 **참고**: 실제 저장소 주소로 변경해야 합니다

### 5단계: 앱 설정하기

1. **필요한 파일들 다운로드**:
   ```cmd
   flutter pub get
   ```
   - 이 과정은 몇 분 정도 걸립니다. 기다려주세요!

2. **모든 것이 제대로 설정되었는지 확인**:
   ```cmd
   flutter doctor
   ```
   - 체크마크(✓)가 많이 보이면 좋습니다
   - ❌ 표시가 있으면 화면에 나오는 해결 방법을 따라하세요

### 6단계: 앱 실행하기! 🎉

1. **가상 휴대폰 켜기**:
   - Android Studio를 실행하세요
   - "More Actions" → "AVD Manager" 클릭
   - 만들어둔 가상 기기 옆의 **재생 버튼(▶️)** 클릭
   - 가상 휴대폰이 켜질 때까지 기다리세요 (처음엔 시간이 좀 걸립니다)

2. **앱 실행**:
   - 명령 프롬프트(cmd)로 돌아가서:
     ```cmd
     flutter run
     ```
   - 앱이 빌드되고 가상 휴대폰에 설치됩니다
   - 몇타치니 앱이 실행되는 것을 보실 수 있습니다! 🎊

---

## 🍎 Mac 사용자를 위한 완벽 가이드

### 1단계: Homebrew 설치 (프로그램 설치 도구)

Homebrew는 Mac에서 프로그램을 쉽게 설치할 수 있게 해주는 도구입니다.

1. **터미널 열기**:
   - `Cmd + Space`를 누르세요
   - "터미널" 또는 "Terminal"을 입력하고 Enter

2. **Homebrew 설치**:
   - 다음 명령어를 **복사해서 붙여넣고** Enter를 누르세요:
     ```bash
     /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
     ```
   - 비밀번호를 입력하라고 하면 Mac 로그인 비밀번호를 입력하세요
   - 설치가 완료될 때까지 기다리세요

### 2단계: Flutter 설치

1. **Flutter 설치**:
   ```bash
   brew install --cask flutter
   ```

2. **설치 확인**:
   ```bash
   flutter --version
   ```
   - Flutter 버전 정보가 나오면 성공! 🎉

### 3단계: Xcode 설치 (iPhone 시뮬레이터용)

1. **App Store 열기**:
   - 화면 상단의 Apple 메뉴 → "App Store" 클릭

2. **Xcode 검색 및 설치**:
   - 검색창에 "Xcode" 입력
   - "받기" 또는 "설치" 클릭
   - ⚠️ **주의**: 파일이 매우 큽니다 (약 10GB). 시간이 오래 걸립니다!

3. **Xcode 설정**:
   - 설치가 완료되면 터미널에서 다음 명령어 실행:
     ```bash
     sudo xcodebuild -license accept
     sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
     ```
   - 비밀번호를 입력하라고 하면 Mac 로그인 비밀번호를 입력하세요

### 4단계: Android Studio 설치 (선택사항)

Android 휴대폰에서도 테스트하고 싶다면:

1. **Android Studio 다운로드**: https://developer.android.com/studio
2. **설치**: 다운로드한 파일을 Applications 폴더로 드래그
3. **실행 및 설정**: Android Studio를 열고 설정 마법사 진행
4. **가상 기기 만들기**: "More Actions" → "AVD Manager"에서 Pixel 4 생성

### 5단계: 몇타치니 앱 다운로드

1. **터미널 열기** (아직 안 열었다면)

2. **작업할 폴더 만들기**:
   ```bash
   cd ~
   mkdir -p projects
   cd projects
   ```

3. **앱 코드 다운로드**:
   ```bash
   git clone https://github.com/your-username/mtcn-golf.git
   cd mtcn-golf
   ```

### 6단계: 앱 설정하기

1. **필요한 파일들 다운로드**:
   ```bash
   flutter pub get
   ```

2. **모든 것이 제대로 설정되었는지 확인**:
   ```bash
   flutter doctor
   ```

### 7단계: 앱 실행하기! 🎉

#### 방법 A: iPhone 시뮬레이터에서 실행 (추천)

1. **시뮬레이터 열기**:
   ```bash
   open -a Simulator
   ```

2. **앱 실행**:
   ```bash
   flutter run
   ```

#### 방법 B: Android 에뮬레이터에서 실행

1. **에뮬레이터 시작**: Android Studio에서 AVD Manager로 시작
2. **앱 실행**:
   ```bash
   flutter run
   ```

---

## 🎯 앱 실행하기 (모든 플랫폼 공통)

한 번 설정이 끝나면, 다음부터는 이렇게만 하면 됩니다:

```bash
# 프로젝트 폴더로 이동
cd mtcn-golf

# 앱 실행
flutter run
```

### 사용 가능한 기기 확인

```bash
flutter devices
```

### 특정 기기에서 실행

```bash
# iPhone 시뮬레이터에서 실행
flutter run -d ios

# Android 에뮬레이터에서 실행
flutter run -d android

# 웹 브라우저에서 실행
flutter run -d web
```

---

## 🔧 문제가 생겼을 때 해결 방법

### "flutter: 명령을 찾을 수 없습니다" 오류

**Windows**:
- Flutter를 PATH에 제대로 추가했는지 확인하세요
- 명령 프롬프트를 다시 열어보세요
- 임시 해결책:
  ```cmd
  set PATH=%PATH%;C:\flutter\bin
  ```

**Mac**:
- 터미널을 다시 열어보세요
- 임시 해결책:
  ```bash
  export PATH="$PATH:/opt/homebrew/bin"
  ```

### "기기를 찾을 수 없습니다" 오류

1. **에뮬레이터/시뮬레이터가 실행 중인지 확인**:
   - Android: Android Studio의 AVD Manager에서 시작
   - iOS: `open -a Simulator` 명령어 실행

2. **기기 목록 확인**:
   ```bash
   flutter devices
   ```

### "Flutter doctor에서 문제가 표시됩니다"

`flutter doctor` 명령어를 실행하고 화면에 나오는 해결 방법을 따라하세요:

```bash
# Android 라이선스 동의
flutter doctor --android-licenses

# 자세한 정보 보기
flutter doctor -v
```

### "빌드 실패" 오류

1. **프로젝트 정리하고 다시 시도**:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **Flutter 업데이트**:
   ```bash
   flutter upgrade
   ```

### "권한 거부" 오류 (Mac)

```bash
sudo chown -R $(whoami) /usr/local/bin
```

### 앱이 시작하자마자 종료됩니다

1. **로그 확인**:
   ```bash
   flutter logs
   ```

2. **디버그 모드로 실행**:
   ```bash
   flutter run --debug
   ```

---

## 💡 유용한 팁

### 앱 실행 중 코드 수정하기

앱이 실행 중일 때 코드를 수정하면:
- 터미널에서 `r`을 누르면 앱이 다시 로드됩니다 (Hot Reload)
- `R`을 누르면 앱이 완전히 재시작됩니다 (Hot Restart)

### 앱 종료하기

터미널에서 `q`를 누르면 앱이 종료됩니다.

### 앱 업데이트하기

최신 코드를 받으려면:

```bash
cd mtcn-golf
git pull
flutter pub get
flutter run
```

---

## 🎉 성공했습니다!

에뮬레이터나 시뮬레이터에서 몇타치니 앱이 실행되는 것을 보셨다면, 축하합니다! 🎊

이제 앱을 탐색하고, 코드를 수정하고, 골프 앱 개발을 시작할 수 있습니다!

---

## 📚 다음 단계

앱이 실행되었다면:

1. **앱 둘러보기**: 다양한 화면을 탐색해보세요
2. **코드 수정해보기**: 텍스트나 색상을 바꿔보세요
3. **실시간 변경 확인**: `r` 키로 Hot Reload 사용하기
4. **문제 해결 연습**: 에러가 나면 로그를 읽어보세요

---

## 🆘 도움이 필요하신가요?

문제가 계속 발생한다면:

1. **Flutter 공식 문서**: https://flutter.dev/docs
2. **에러 메시지 검색**: Google이나 Stack Overflow에서 검색
3. **프로젝트 이슈 페이지**: GitHub에서 이슈 생성
4. **시스템 요구사항 확인**: https://flutter.dev/docs/get-started/install

---

## 📝 용어 설명

처음 보는 용어들이 많으셨죠? 간단히 설명드립니다:

- **Flutter**: 앱을 만드는 도구 (프레임워크)
- **터미널/명령 프롬프트**: 컴퓨터에 명령을 내리는 검은 화면
- **SDK**: 소프트웨어 개발 키트 (Software Development Kit)
- **에뮬레이터/시뮬레이터**: 컴퓨터에서 실행되는 가짜 휴대폰
- **PATH**: 컴퓨터가 프로그램을 찾을 수 있는 경로 목록
- **Git**: 코드를 다운로드하고 관리하는 도구
- **빌드**: 코드를 실행 가능한 앱으로 만드는 과정

---

**즐거운 개발 되세요! 🏌️‍♂️✨**

궁금한 점이 있으시면 언제든지 물어보세요!