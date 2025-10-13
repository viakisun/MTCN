/// 의존성 주입을 위한 서비스 로케이터
///
/// 앱 전체에서 사용되는 서비스들의 싱글톤 인스턴스를 관리합니다.
/// 실제 프로덕션에서는 GetIt, Provider, 또는 다른 DI 프레임워크를 사용할 수 있습니다.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/mock_database_service.dart';
import '../../domain/repositories/rounding_repository.dart';
import '../../domain/repositories/group_repository.dart';
import '../../domain/repositories/player_repository.dart';
import '../../domain/repositories/score_repository.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../data/repositories/rounding_repository.dart';
import '../../data/repositories/group_repository.dart';
import '../../data/repositories/player_repository.dart';
import '../../data/repositories/score_repository.dart';
import '../../data/repositories/chat_repository.dart';
import '../../domain/services/validation_service.dart';
import '../../domain/services/notification_service.dart';
import '../../domain/usecases/rounding/create_rounding_usecase.dart';

/// 서비스 로케이터 클래스
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal() {
    // Initialize services
    _databaseService = MockDatabaseService();
    _roundingRepository = MockRoundingRepository(_databaseService);
    _groupRepository = MockGroupRepository(_databaseService);
    _playerRepository = MockPlayerRepository(_databaseService);
    _scoreRepository = MockScoreRepository(_databaseService);
    _chatRepository = MockChatRepository(_databaseService);
    _validationService = ValidationService();
    _notificationService = NotificationService();

    // Use Cases 초기화
    _createRoundingUseCase = CreateRoundingUseCase();
  }

  // Private fields
  late final IDatabaseService _databaseService;
  late final IRoundingRepository _roundingRepository;
  late final IGroupRepository _groupRepository;
  late final IPlayerRepository _playerRepository;
  late final IScoreRepository _scoreRepository;
  late final IChatRepository _chatRepository;
  late final IValidationService _validationService;
  late final INotificationService _notificationService;
  late final CreateRoundingUseCase _createRoundingUseCase;

  // Getters
  IDatabaseService get databaseService => _databaseService;
  IValidationService get validationService => _validationService;
  INotificationService get notificationService => _notificationService;
  IRoundingRepository get roundingRepository => _roundingRepository;
  IGroupRepository get groupRepository => _groupRepository;
  IPlayerRepository get playerRepository => _playerRepository;
  IScoreRepository get scoreRepository => _scoreRepository;
  IChatRepository get chatRepository => _chatRepository;
  CreateRoundingUseCase get createRoundingUseCase => _createRoundingUseCase;
}

/// ServiceLocator Provider
final serviceLocatorProvider = Provider<ServiceLocator>((ref) {
  return ServiceLocator();
});
