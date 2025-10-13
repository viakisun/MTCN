import '../../data/models/rounding.dart';

/// 라운딩 데이터 접근 인터페이스
///
/// Clean Architecture의 Repository 패턴을 적용하여
/// 데이터 소스와 비즈니스 로직을 분리합니다.
abstract class IRoundingRepository {
  /// 사용자의 라운딩 목록 조회
  Future<List<Rounding>> getUserRoundings(String userId);

  /// 라운딩 상세 정보 조회
  Future<Rounding?> getRounding(String id);

  /// 라운딩 생성
  Future<Rounding> createRounding(Rounding rounding);

  /// 라운딩 수정
  Future<Rounding> updateRounding(Rounding rounding);

  /// 라운딩 삭제
  Future<void> deleteRounding(String id);

  /// 그룹의 라운딩 목록 조회
  Future<List<Rounding>> getGroupRoundings(String groupId);

  /// 골프장별 라운딩 목록 조회
  Future<List<Rounding>> getRoundingsByCourse(String courseName);

  /// 날짜 범위별 라운딩 조회
  Future<List<Rounding>> getRoundingsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  /// 라운딩 참가
  Future<Rounding> joinRounding(String roundingId, String playerId);

  /// 라운딩 탈퇴
  Future<Rounding> leaveRounding(String roundingId, String playerId);

  /// 라운딩 상태 변경
  Future<Rounding> updateRoundingStatus(String id, RoundingStatus status);
}
