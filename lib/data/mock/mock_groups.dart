import '../../models/group.dart';
import 'mock_players.dart';

/// Mock group data for development
class MockGroups {
  static final List<Group> all = [
    Group(
      id: '1',
      name: '서울대 경영대 동문회',
      description: '서울대 경영대학원 동문 골프 모임 · 회원 300명',
      status: GroupStatus.active,
      members: MockPlayers.findByIds(['1', '2', '3', '5']),
      createdAt: DateTime.now().subtract(const Duration(days: 1200)),
      roundCount: 156,
    ),
    Group(
      id: '2',
      name: '강남 사장님 모임',
      description: '강남 지역 중소기업 대표님들의 네트워킹 · 회원 45명',
      status: GroupStatus.active,
      members: MockPlayers.findByIds(['1', '4', '5', '6']),
      createdAt: DateTime.now().subtract(const Duration(days: 380)),
      roundCount: 32,
    ),
    Group(
      id: '3',
      name: '성수동 스타트업 대표 모임',
      description: '성수동 테크 스타트업 파운더 모임 · 회원 28명',
      status: GroupStatus.active,
      members: MockPlayers.findByIds(['2', '3', '7']),
      createdAt: DateTime.now().subtract(const Duration(days: 180)),
      roundCount: 18,
    ),
    Group(
      id: '4',
      name: '주말 골프 크루',
      description: '매주 토요일 아침 라운딩하는 친구들 · 회원 8명',
      status: GroupStatus.active,
      members: MockPlayers.findByIds(['1', '2', '3', '4', '5', '6', '7', '8']),
      createdAt: DateTime.now().subtract(const Duration(days: 420)),
      roundCount: 67,
    ),
    Group(
      id: '5',
      name: '대학 동기 모임',
      description: '86학번 동기들의 골프 모임 · 회원 12명',
      status: GroupStatus.active,
      members: MockPlayers.findByIds(['2', '5', '8']),
      createdAt: DateTime.now().subtract(const Duration(days: 850)),
      roundCount: 48,
    ),
    Group(
      id: '6',
      name: '여의도 금융맨 모임',
      description: '증권사/은행 직장인 골프 모임 · 회원 56명',
      status: GroupStatus.active,
      members: MockPlayers.findByIds(['3', '6']),
      createdAt: DateTime.now().subtract(const Duration(days: 520)),
      roundCount: 41,
    ),
    Group(
      id: '7',
      name: '판교 IT 모임',
      description: '판교 테크노밸리 임직원 골프 모임 · 회원 89명',
      status: GroupStatus.active,
      members: MockPlayers.findByIds(['4', '7', '8']),
      createdAt: DateTime.now().subtract(const Duration(days: 290)),
      roundCount: 25,
    ),
  ];

  static Group findById(String id) {
    return all.firstWhere((group) => group.id == id, orElse: () => all.first);
  }

  static List<Group> activeGroups() {
    return all.where((g) => g.status == GroupStatus.active).toList();
  }

  static List<Group> newGroups() {
    return all.where((g) => g.isNew).toList();
  }
}
