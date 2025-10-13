import '../../models/rounding.dart';
import 'mock_players.dart';

/// Mock rounding data for development
class MockRoundings {
  static final List<Rounding> all = [
    Rounding(
      id: '1',
      courseName: '남서울 컨트리클럽',
      eventName: '2024 정기 월례회',
      groupName: '서울대 경영대 동문회',
      date: '2025-10-08',
      time: '08:00',
      status: RoundingStatus.inProgress,
      greenFee: 220000,
      weather: 'sunny',
      temperature: 22,
      players: [
        MockPlayers.currentUser, // 김민수 (나)
        MockPlayers.findById('2'), // 이영희
        MockPlayers.findById('3'), // 박철수
        MockPlayers.findById('5'), // 최동현
      ],
      holes: 18,
      description: '서울대 경영대 동문회 정기 월례회 - 현재 14홀 진행 중!',
      currentHole: 14,
      totalHoles: 18,
      maxPlayers: 48,
      fee: 50000,
      options: const RoundingOptions(
        includeCaddie: true,
        includeCart: true,
        includeMeal: true,
        mealType: 'lunch',
      ),
      courseAddress: '경기도 성남시 분당구 판교로 550',
    ),
    Rounding(
      id: '2',
      courseName: '클럽나인브릿지',
      eventName: '네트워킹 라운드',
      groupName: '강남 사장님 모임',
      date: '2025-10-09',
      time: '07:30',
      status: RoundingStatus.inProgress,
      greenFee: 450000,
      weather: 'sunny',
      temperature: 20,
      players: MockPlayers.getRandomPlayers(8),
      holes: 18,
      description: '강남 지역 기업인 네트워킹 라운드',
      currentHole: 8,
      totalHoles: 18,
      maxPlayers: 16,
      fee: 80000,
      options: const RoundingOptions(
        includeCaddie: true,
        includeCart: true,
        includeMeal: true,
        mealType: 'lunch',
      ),
      courseAddress: '제주특별자치도 서귀포시 안덕면 산록남로 863',
    ),
    Rounding(
      id: '3',
      courseName: '용인 컨트리클럽',
      eventName: '주말 정기 라운딩',
      groupName: '주말 골프 크루',
      date: '2025-10-11',
      time: '09:00',
      status: RoundingStatus.upcoming,
      greenFee: 180000,
      weather: 'sunny',
      temperature: 22,
      players: MockPlayers.getRandomPlayers(4),
      holes: 18,
      description: '매주 토요일 아침 정기 라운딩',
      maxPlayers: 8,
      fee: 30000,
      options: const RoundingOptions(
        includeCaddie: true,
        includeCart: true,
        includeMeal: true,
        mealType: 'lunch',
      ),
      courseAddress: '경기도 용인시 처인구 남사면',
    ),
    Rounding(
      id: '4',
      courseName: '스카이72 골프클럽',
      eventName: '파운더 미팅 라운드',
      groupName: '성수동 스타트업 대표 모임',
      date: '2025-10-13',
      time: '06:00',
      status: RoundingStatus.upcoming,
      greenFee: 180000,
      weather: 'sunny',
      temperature: 20,
      players: MockPlayers.getRandomPlayers(8),
      holes: 18,
      description: '스타트업 파운더들의 조찬 골프 미팅',
      maxPlayers: 12,
      fee: 40000,
      options: const RoundingOptions(
        includeCaddie: true,
        includeCart: true,
        includeMeal: true,
        mealType: 'breakfast',
      ),
      courseAddress: '인천광역시 중구 공항동로 424번길 186',
    ),
    Rounding(
      id: '5',
      courseName: '에머슨 CC',
      eventName: '금융맨 친목 라운딩',
      groupName: '여의도 금융맨 모임',
      date: '2025-10-15',
      time: '14:00',
      status: RoundingStatus.upcoming,
      greenFee: 220000,
      weather: 'sunny',
      temperature: 21,
      players: MockPlayers.getRandomPlayers(12),
      holes: 18,
      description: '여의도 금융권 종사자 친목 라운딩',
      maxPlayers: 16,
      fee: 40000,
      options: const RoundingOptions(
        includeCaddie: true,
        includeCart: true,
        includeMeal: true,
        mealType: 'lunch',
      ),
      courseAddress: '경기도 파주시 탄현면 축현리 123',
    ),
    Rounding(
      id: '6',
      courseName: '레이크사이드 CC',
      eventName: '동기 친선 라운딩',
      groupName: '대학 동기 모임',
      date: '2025-10-01',
      time: '10:00',
      status: RoundingStatus.completed,
      greenFee: 250000,
      weather: 'sunny',
      temperature: 25,
      players: MockPlayers.getRandomPlayers(8),
      holes: 18,
      description: '86학번 동기 친선 라운딩',
      currentHole: 18,
      totalHoles: 18,
      maxPlayers: 12,
      fee: 50000,
      options: const RoundingOptions(
        includeCaddie: false,
        includeCart: true,
        includeMeal: true,
        mealType: 'lunch',
      ),
      courseAddress: '경기도 용인시 처인구 양지면 남곡로 210',
    ),
    Rounding(
      id: '7',
      courseName: '판교 골프존',
      eventName: 'IT 네트워킹 라운드',
      groupName: '판교 IT 모임',
      date: '2025-10-18',
      time: '13:00',
      status: RoundingStatus.upcoming,
      greenFee: 190000,
      weather: 'sunny',
      temperature: 19,
      players: MockPlayers.getRandomPlayers(16),
      holes: 18,
      description: '판교 테크노밸리 IT 기업 네트워킹',
      maxPlayers: 20,
      fee: 35000,
      options: const RoundingOptions(
        includeCaddie: true,
        includeCart: true,
        includeMeal: true,
        mealType: 'dinner',
      ),
      courseAddress: '경기도 성남시 분당구 대왕판교로 670',
    ),
  ];

  static Rounding findById(String id) {
    return all.firstWhere(
      (rounding) => rounding.id == id,
      orElse: () => all.first,
    );
  }

  static List<Rounding> getUpcoming() {
    return all.where((r) => r.status == RoundingStatus.upcoming).toList();
  }

  static List<Rounding> getInProgress() {
    return all.where((r) => r.status == RoundingStatus.inProgress).toList();
  }

  static List<Rounding> getCompleted() {
    return all.where((r) => r.status == RoundingStatus.completed).toList();
  }

  // Alias methods for compatibility
  static List<Rounding> upcomingRoundings() => getUpcoming();
  static List<Rounding> inProgressRoundings() => getInProgress();
  static List<Rounding> completedRoundings() => getCompleted();
}
