import 'dart:async';
import 'package:flutter/foundation.dart';

/// 응원 타입
enum CheerType {
  applause, // 박수 👏
  fighting, // 파이팅 💪
  goodShot, // 굿샷 ⛳
  amazing, // 대단해요 🎉
  heart, // 좋아요 ❤️
  fire, // 불타요 🔥
}

/// 응원 메시지
class CheerMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String targetPlayerId;
  final String targetPlayerName;
  final CheerType type;
  final String? customMessage;
  final DateTime timestamp;
  final String? roundingId;
  final int? holeNumber;

  const CheerMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.targetPlayerId,
    required this.targetPlayerName,
    required this.type,
    this.customMessage,
    required this.timestamp,
    this.roundingId,
    this.holeNumber,
  });

  String get emoji {
    switch (type) {
      case CheerType.applause:
        return '👏';
      case CheerType.fighting:
        return '💪';
      case CheerType.goodShot:
        return '⛳';
      case CheerType.amazing:
        return '🎉';
      case CheerType.heart:
        return '❤️';
      case CheerType.fire:
        return '🔥';
    }
  }

  String get defaultMessage {
    switch (type) {
      case CheerType.applause:
        return '박수!';
      case CheerType.fighting:
        return '파이팅!';
      case CheerType.goodShot:
        return '굿샷!';
      case CheerType.amazing:
        return '대단해요!';
      case CheerType.heart:
        return '좋아요!';
      case CheerType.fire:
        return '불타요!';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'targetPlayerId': targetPlayerId,
      'targetPlayerName': targetPlayerName,
      'type': type.name,
      'customMessage': customMessage,
      'timestamp': timestamp.toIso8601String(),
      'roundingId': roundingId,
      'holeNumber': holeNumber,
    };
  }

  factory CheerMessage.fromJson(Map<String, dynamic> json) {
    return CheerMessage(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      targetPlayerId: json['targetPlayerId'] as String,
      targetPlayerName: json['targetPlayerName'] as String,
      type: CheerType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => CheerType.applause,
      ),
      customMessage: json['customMessage'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      roundingId: json['roundingId'] as String?,
      holeNumber: json['holeNumber'] as int?,
    );
  }
}

/// 응원 통계
class CheerStats {
  final String playerId;
  final Map<CheerType, int> cheerCounts;
  final int totalCheers;
  final DateTime? lastCheerTime;

  const CheerStats({
    required this.playerId,
    required this.cheerCounts,
    required this.totalCheers,
    this.lastCheerTime,
  });

  factory CheerStats.empty(String playerId) {
    return CheerStats(playerId: playerId, cheerCounts: {}, totalCheers: 0);
  }
}

/// 응원 서비스
///
/// 실시간 응원 메시지 전송 및 수신, 응원 통계 관리
/// 실제 구현 시 Firebase Firestore 또는 Supabase Realtime을 사용하세요.
class CheerService {
  CheerService._();
  static final CheerService instance = CheerService._();

  // 응원 메시지 스트림 컨트롤러
  final _cheerController = StreamController<CheerMessage>.broadcast();
  Stream<CheerMessage> get cheerStream => _cheerController.stream;

  // 응원 메시지 저장소 (라운딩별)
  final Map<String, List<CheerMessage>> _cheersByRounding = {};

  // 응원 통계 (플레이어별)
  final Map<String, CheerStats> _cheerStats = {};

  /// 응원 보내기
  Future<CheerMessage?> sendCheer({
    required String senderId,
    required String senderName,
    required String targetPlayerId,
    required String targetPlayerName,
    required CheerType type,
    String? customMessage,
    String? roundingId,
    int? holeNumber,
  }) async {
    try {
      debugPrint('=== Send Cheer ===');
      debugPrint('From: $senderName');
      debugPrint('To: $targetPlayerName');
      debugPrint('Type: ${type.name}');

      // Mock 지연
      await Future.delayed(const Duration(milliseconds: 300));

      // 응원 메시지 생성
      final cheer = CheerMessage(
        id: 'cheer_${DateTime.now().millisecondsSinceEpoch}',
        senderId: senderId,
        senderName: senderName,
        targetPlayerId: targetPlayerId,
        targetPlayerName: targetPlayerName,
        type: type,
        customMessage: customMessage,
        timestamp: DateTime.now(),
        roundingId: roundingId,
        holeNumber: holeNumber,
      );

      // 저장소에 추가
      if (roundingId != null) {
        if (!_cheersByRounding.containsKey(roundingId)) {
          _cheersByRounding[roundingId] = [];
        }
        _cheersByRounding[roundingId]!.add(cheer);
      }

      // 통계 업데이트
      _updateCheerStats(targetPlayerId, type);

      // 스트림에 전송
      _cheerController.add(cheer);

      debugPrint(
        'Cheer sent successfully: ${cheer.emoji} ${cheer.defaultMessage}',
      );
      return cheer;
    } catch (e) {
      debugPrint('Error sending cheer: $e');
      return null;
    }
  }

  /// 라운딩의 응원 메시지 조회
  Future<List<CheerMessage>> getRoundingCheers({
    required String roundingId,
    String? targetPlayerId,
  }) async {
    try {
      debugPrint('=== Get Rounding Cheers ===');
      debugPrint('Rounding ID: $roundingId');

      // Mock 지연
      await Future.delayed(const Duration(milliseconds: 300));

      final cheers = _cheersByRounding[roundingId] ?? [];

      // 특정 플레이어만 필터링
      if (targetPlayerId != null) {
        return cheers.where((c) => c.targetPlayerId == targetPlayerId).toList()
          ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
      }

      // 최신순 정렬
      return List.from(cheers)
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (e) {
      debugPrint('Error getting rounding cheers: $e');
      return [];
    }
  }

  /// 플레이어 응원 통계 조회
  Future<CheerStats> getPlayerCheerStats(String playerId) async {
    try {
      debugPrint('=== Get Player Cheer Stats ===');
      debugPrint('Player ID: $playerId');

      // Mock 지연
      await Future.delayed(const Duration(milliseconds: 200));

      return _cheerStats[playerId] ?? CheerStats.empty(playerId);
    } catch (e) {
      debugPrint('Error getting player cheer stats: $e');
      return CheerStats.empty(playerId);
    }
  }

  /// 응원 통계 업데이트
  void _updateCheerStats(String playerId, CheerType type) {
    final currentStats = _cheerStats[playerId];

    if (currentStats == null) {
      _cheerStats[playerId] = CheerStats(
        playerId: playerId,
        cheerCounts: {type: 1},
        totalCheers: 1,
        lastCheerTime: DateTime.now(),
      );
    } else {
      final updatedCounts = Map<CheerType, int>.from(currentStats.cheerCounts);
      updatedCounts[type] = (updatedCounts[type] ?? 0) + 1;

      _cheerStats[playerId] = CheerStats(
        playerId: playerId,
        cheerCounts: updatedCounts,
        totalCheers: currentStats.totalCheers + 1,
        lastCheerTime: DateTime.now(),
      );
    }
  }

  /// 홀별 응원 순위 조회
  Future<Map<String, int>> getHoleCheerRanking({
    required String roundingId,
    required int holeNumber,
  }) async {
    try {
      debugPrint('=== Get Hole Cheer Ranking ===');
      debugPrint('Rounding ID: $roundingId, Hole: $holeNumber');

      // Mock 지연
      await Future.delayed(const Duration(milliseconds: 200));

      final cheers = _cheersByRounding[roundingId] ?? [];
      final holeCheers = cheers.where((c) => c.holeNumber == holeNumber);

      // 플레이어별 응원 수 집계
      final ranking = <String, int>{};
      for (final cheer in holeCheers) {
        ranking[cheer.targetPlayerId] =
            (ranking[cheer.targetPlayerId] ?? 0) + 1;
      }

      return ranking;
    } catch (e) {
      debugPrint('Error getting hole cheer ranking: $e');
      return {};
    }
  }

  /// 최근 응원 메시지 조회
  Future<List<CheerMessage>> getRecentCheers({
    String? roundingId,
    int limit = 10,
  }) async {
    try {
      debugPrint('=== Get Recent Cheers ===');
      debugPrint('Limit: $limit');

      // Mock 지연
      await Future.delayed(const Duration(milliseconds: 200));

      List<CheerMessage> allCheers;

      if (roundingId != null) {
        allCheers = _cheersByRounding[roundingId] ?? [];
      } else {
        allCheers = _cheersByRounding.values
            .expand((cheers) => cheers)
            .toList();
      }

      // 최신순 정렬
      allCheers.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      // 제한
      return allCheers.take(limit).toList();
    } catch (e) {
      debugPrint('Error getting recent cheers: $e');
      return [];
    }
  }

  /// 응원 통계 초기화
  void resetStats(String playerId) {
    _cheerStats.remove(playerId);
    debugPrint('Cheer stats reset for player: $playerId');
  }

  /// 리소스 정리
  Future<void> dispose() async {
    await _cheerController.close();
    debugPrint('Cheer Service disposed');
  }
}
