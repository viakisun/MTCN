import '../../data/models/rounding.dart';
import '../../core/enums/rounding_enums.dart';

/// 라운딩 데이터 접근 인터페이스
///
/// Clean Architecture의 Repository 패턴을 적용하여
/// 데이터 소스와 비즈니스 로직을 분리합니다.
abstract class IRoundingRepository {
  /// 라운딩 목록 조회 (MockDatabaseService 호환)
  Future<List<Rounding>> getRoundings({
    String? statusFilter,
    String? searchKeyword,
    int? limit,
    int? offset,
  });

  /// 라운딩 상세 정보 조회
  Future<Rounding?> getRoundingById(String id);

  /// 라운딩 생성
  Future<Rounding> createRounding(Rounding rounding);

  /// 라운딩 수정
  Future<Rounding> updateRounding(Rounding rounding);

  /// 라운딩 삭제
  Future<void> deleteRounding(String id);

  /// 라운딩 상태 변경
  Future<Rounding> updateRoundingStatus(String id, RoundingStatus status);
}
