/// 라운딩 생성 Use Case (간단 버전)

class CreateRoundingUseCase {
  /// 라운딩 생성 실행
  Future<String> execute(String title) async {
    // 시뮬레이션된 처리
    await Future.delayed(const Duration(milliseconds: 500));
    return '라운딩이 생성되었습니다: $title';
  }
}
