# Phase 2 빠른 시작 가이드 - MTCN Golf App

## 📋 Phase 1 완료 요약

✅ 인증 시스템 (이메일, 소셜 로그인)
✅ 푸시 알림 기반
✅ 실시간 데이터 동기화 Provider
✅ 네비게이션 서비스

자세한 내용은 `PHASE1_IMPLEMENTATION_SUMMARY.md` 참고

## 🚀 Phase 2 시작하기

### 1. 현재 상태 확인

```bash
cd mtcn_flutter
flutter pub get
flutter run
```

### 2. Phase 2 주요 작업 항목

#### A. 라운딩 생성/참가 플로우 (우선순위: 높음)

**작업 1: 라운딩 생성 페이지 고도화**

`lib/screens/rounding/create_rounding_page.dart` 업데이트:

```dart
// 추가할 기능:
1. 골프장 검색 (autocomplete)
2. 지도에서 골프장 선택
3. 참가비 입력 필드
4. 캐디/카트 옵션 선택
5. 식사 포함 옵션
6. 최대 참가 인원 설정
```

**필요한 패키지:**
```yaml
# pubspec.yaml에 추가
dependencies:
  google_maps_flutter: ^2.5.0
  geolocator: ^10.1.0
  geocoding: ^2.1.1
```

**작업 2: 라운딩 참가 신청 페이지**

`lib/screens/rounding/join_rounding_page.dart` 생성:

```dart
class JoinRoundingPage extends ConsumerStatefulWidget {
  final Rounding rounding;

  // 기능:
  // - 라운딩 정보 표시
  // - 참가비 확인
  // - 결제 옵션 선택
  // - 참가 신청 제출
}
```

**작업 3: 결제 시스템 연동**

`lib/services/payment_service.dart` 생성:

```dart
class PaymentService {
  // 아임포트 또는 토스페이먼츠 연동
  Future<PaymentResult> processPayment({
    required String roundingId,
    required int amount,
    required PaymentMethod method,
  });
}
```

**필요한 패키지:**
```yaml
# 아임포트 사용 시
dependencies:
  iamport_flutter: ^0.10.0

# 또는 토스페이먼츠
dependencies:
  tosspayments_flutter: ^1.0.0
```

#### B. 실시간 채팅 고도화 (우선순위: 높음)

**작업 1: 메시지 반응(Reaction) 기능**

`lib/widgets/chat/message_reactions.dart` 생성:

```dart
class MessageReactions extends StatelessWidget {
  final String messageId;
  final Map<String, List<String>> reactions; // emoji: [userId1, userId2]

  // 기능:
  // - 이모지 선택 바텀시트
  // - 반응 추가/제거
  // - 반응한 사용자 목록 표시
}
```

**작업 2: 이미지/파일 공유**

`lib/services/storage_service.dart` 생성:

```dart
class StorageService {
  // Firebase Storage 또는 Cloudinary 연동
  Future<String> uploadImage(File image);
  Future<String> uploadVideo(File video);
  Future<void> deleteFile(String url);
}
```

**필요한 패키지:**
```yaml
dependencies:
  image_picker: ^1.0.4
  file_picker: ^6.1.1
  video_player: ^2.8.1
  cloudinary_public: ^0.21.0  # 또는 firebase_storage: ^11.5.0
```

**작업 3: 답글 기능**

`lib/models/chat_message.dart` 업데이트:

```dart
class ChatMessage {
  // 기존 필드 +
  final String? replyToMessageId;
  final ChatMessage? replyToMessage;
}
```

#### C. 멤버 관리 시스템 (우선순위: 중간)

**작업 1: 권한 시스템**

`lib/models/member_role.dart` 생성:

```dart
enum MemberRole {
  president,    // 회장
  vicePresident, // 부회장
  treasurer,    // 총무
  member,       // 일반 멤버
}

class MemberPermissions {
  static bool canCreateRounding(MemberRole role);
  static bool canManageMembers(MemberRole role);
  static bool canManageFinances(MemberRole role);
}
```

**작업 2: 멤버 승인/거절**

`lib/screens/groups/member_approval_page.dart` 생성:

```dart
class MemberApprovalPage extends ConsumerWidget {
  // 가입 신청 목록
  // 승인/거절 버튼
  // 신청자 프로필 보기
}
```

#### D. 라이브 게임 기능 (우선순위: 높음)

**작업 1: 실시간 스코어보드**

`lib/screens/game/live_scoreboard_page.dart` 생성:

```dart
class LiveScoreboardPage extends ConsumerWidget {
  final String roundingId;

  // 기능:
  // - 실시간 스코어 업데이트 (Realtime DB)
  // - 리더보드 자동 정렬
  // - 홀별 스코어 입력
  // - 통계 요약
}
```

**작업 2: GPS 트래킹**

`lib/services/gps_service.dart` 생성:

```dart
class GPSService {
  // 현재 위치 추적
  // 골프장 내 홀 자동 감지
  // 거리 측정

  Future<Position> getCurrentPosition();
  Future<int?> detectCurrentHole(Position position, String courseId);
  double calculateDistance(Position from, Position to);
}
```

**필요한 패키지:**
```yaml
dependencies:
  geolocator: ^10.1.0
  location: ^5.0.3
```

**작업 3: 응원 시스템**

`lib/widgets/game/cheer_widget.dart` 생성:

```dart
class CheerWidget extends StatelessWidget {
  // 이모지 응원 보내기
  // 실시간 응원 애니메이션
  // 버디/이글 축하 이펙트
}
```

## 🛠 Phase 2 작업 순서 추천

### Week 1: 라운딩 생성 및 참가
1. 골프장 선택 UI (지도 또는 검색)
2. 라운딩 생성 폼 완성
3. 참가 신청 페이지
4. 결제 시스템 Mock 연동 (실제 결제는 나중)

### Week 2: 실시간 채팅 고도화
1. 메시지 반응 기능
2. 이미지 업로드 및 표시
3. 답글 기능

### Week 3: 라이브 게임
1. 실시간 스코어보드 UI
2. 스코어 입력 및 업데이트
3. GPS 기능 (옵션)
4. 응원 시스템

### Week 4: 멤버 관리 및 완성도
1. 권한 시스템 구현
2. 멤버 승인/거절
3. 프로필 편집
4. 버그 수정 및 UI 개선

## 📝 코드 예시

### 1. 라운딩 생성 with 결제

```dart
// lib/screens/rounding/create_rounding_page.dart

Future<void> _createRounding() async {
  final rounding = Rounding(
    id: '',
    courseName: _courseController.text,
    date: _selectedDate,
    fee: _feeController.text.isNotEmpty
        ? int.parse(_feeController.text)
        : 0,
    maxPlayers: _maxPlayers,
    options: RoundingOptions(
      includeCaddie: _includeCaddie,
      includeCart: _includeCart,
      includeMeal: _includeMeal,
    ),
  );

  // 라운딩 생성
  final roundingId = await ref
      .read(realtimeDataServiceProvider)
      .createRounding(rounding);

  // 생성자 자동 참가
  if (_feeController.text.isNotEmpty) {
    // 결제 처리
    final result = await PaymentService().processPayment(
      roundingId: roundingId,
      amount: int.parse(_feeController.text),
      method: PaymentMethod.card,
    );

    if (result.success) {
      NavigationService().showSuccessSnackBar('라운딩이 생성되었습니다!');
      Navigator.pop(context);
    }
  }
}
```

### 2. 실시간 채팅 with 반응

```dart
// lib/widgets/chat/chat_message_item.dart

class ChatMessageItem extends ConsumerWidget {
  final ChatMessage message;

  void _addReaction(String emoji) async {
    await ref.read(realtimeDataServiceProvider)
        .addReaction(
          messageId: message.id,
          emoji: emoji,
          userId: currentUser.id,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // 메시지 내용
        Text(message.text),

        // 반응 표시
        if (message.reactions.isNotEmpty)
          Wrap(
            children: message.reactions.entries.map((entry) {
              return Chip(
                label: Text('${entry.key} ${entry.value.length}'),
                onPressed: () => _addReaction(entry.key),
              );
            }).toList(),
          ),

        // 반응 추가 버튼
        IconButton(
          icon: Icon(Icons.add_reaction),
          onPressed: () => _showReactionPicker(),
        ),
      ],
    );
  }
}
```

### 3. 라이브 스코어보드

```dart
// lib/screens/game/live_scoreboard_page.dart

class LiveScoreboardPage extends ConsumerWidget {
  final String roundingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveScoreAsync = ref.watch(
      realtimeLiveScoreProvider(roundingId)
    );

    return liveScoreAsync.when(
      data: (rounding) {
        if (rounding == null) return Text('라운딩을 찾을 수 없습니다');

        return Column(
          children: [
            // 리더보드
            _buildLeaderboard(rounding.players),

            // 홀별 스코어
            _buildHoleScores(rounding),

            // 스코어 입력
            _buildScoreInput(rounding),
          ],
        );
      },
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('에러: $err'),
    );
  }

  Widget _buildScoreInput(Rounding rounding) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
      ),
      itemCount: 18,
      itemBuilder: (context, index) {
        final hole = index + 1;
        return GestureDetector(
          onTap: () => _showScoreInputDialog(hole),
          child: Card(
            child: Center(
              child: Text('H$hole'),
            ),
          ),
        );
      },
    );
  }
}
```

## 🎯 성능 최적화 팁

1. **이미지 최적화**
   ```dart
   // cached_network_image 사용
   CachedNetworkImage(
     imageUrl: url,
     placeholder: (context, url) => CircularProgressIndicator(),
     errorWidget: (context, url, error) => Icon(Icons.error),
   )
   ```

2. **무한 스크롤**
   ```dart
   // 채팅 메시지 페이지네이션
   ListView.builder(
     controller: _scrollController,
     itemCount: messages.length + 1,
     itemBuilder: (context, index) {
       if (index == messages.length) {
         return _buildLoadMoreButton();
       }
       return MessageItem(message: messages[index]);
     },
   )
   ```

3. **Debounce 검색**
   ```dart
   Timer? _debounce;

   void _onSearchChanged(String query) {
     if (_debounce?.isActive ?? false) _debounce!.cancel();
     _debounce = Timer(const Duration(milliseconds: 500), () {
       _performSearch(query);
     });
   }
   ```

## 📚 참고 자료

- [Google Maps Flutter](https://pub.dev/packages/google_maps_flutter)
- [Image Picker](https://pub.dev/packages/image_picker)
- [아임포트 Flutter](https://github.com/iamport/iamport_flutter)
- [Firebase Realtime Database](https://firebase.google.com/docs/database/flutter/start)

## 🤝 협업 가이드

Git 브랜치 전략:
```bash
main (프로덕션)
├── develop (개발)
    ├── feature/rounding-creation
    ├── feature/chat-reactions
    ├── feature/live-score
    └── feature/payment-integration
```

커밋 메시지 규칙:
```
feat: 새로운 기능 추가
fix: 버그 수정
refactor: 코드 리팩토링
style: UI/스타일 변경
docs: 문서 업데이트
test: 테스트 추가
```

## ✅ Phase 2 완료 체크리스트

- [ ] 라운딩 생성 폼 (골프장 선택, 옵션 설정)
- [ ] 참가 신청 페이지
- [ ] 결제 시스템 Mock
- [ ] 메시지 반응 기능
- [ ] 이미지 업로드
- [ ] 답글 기능
- [ ] 실시간 스코어보드
- [ ] GPS 트래킹 (옵션)
- [ ] 응원 시스템
- [ ] 권한 관리
- [ ] 멤버 승인/거절
- [ ] UI/UX 개선

---

**질문이나 도움이 필요하면 `PHASE1_IMPLEMENTATION_SUMMARY.md`와 코드 주석을 참고하세요!** 🚀
