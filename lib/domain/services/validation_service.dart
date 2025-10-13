import '../../core/constants/app_constants.dart';
import '../../core/constants/golf_courses.dart';
import '../../core/enums/rounding_enums.dart';
import '../utils/result.dart';
import '../usecases/rounding/create_rounding_usecase.dart';

/// 검증 서비스 인터페이스
abstract class IValidationService {
  Future<ValidationResult> validateRoundingData(CreateRoundingParams params);
  ValidationResult validateEmail(String email);
  ValidationResult validatePhoneNumber(String phone);
  ValidationResult validatePassword(String password);
  ValidationResult validateGroupName(String name);
  ValidationResult validatePlayerName(String name);
}

/// 검증 결과
class ValidationResult {
  final bool isValid;
  final Map<String, String> errors;

  const ValidationResult({required this.isValid, required this.errors});

  ValidationResult.success() : this(isValid: true, errors: {});
  ValidationResult.failure(this.errors) : isValid = false;
}

/// 검증 서비스 구현
class ValidationService implements IValidationService {
  @override
  Future<ValidationResult> validateRoundingData(
    CreateRoundingParams params,
  ) async {
    final errors = <String, String>{};

    // 제목 검증
    if (params.title.trim().isEmpty) {
      errors['title'] = '제목을 입력해주세요';
    } else if (params.title.length > 50) {
      errors['title'] = '제목은 50자 이하로 입력해주세요';
    }

    // 골프장 검증
    final courseExists = GolfCourseConstants.koreanCourses.any(
      (course) => course.name == params.golfCourse.name,
    );
    if (!courseExists) {
      errors['golfCourse'] = '유효한 골프장을 선택해주세요';
    }

    // 날짜 검증
    final now = DateTime.now();
    if (params.date.isBefore(now.subtract(const Duration(days: 1)))) {
      errors['date'] = '과거 날짜는 선택할 수 없습니다';
    }

    // 플레이어 수 검증
    if (params.playerIds.isEmpty) {
      errors['players'] = '최소 1명의 플레이어가 필요합니다';
    } else if (params.playerIds.length > params.maxPlayers) {
      errors['players'] = '최대 참가 인원을 초과했습니다';
    }

    // 설명 검증 (선택사항)
    if (params.description != null && params.description!.length > 500) {
      errors['description'] = '설명은 500자 이하로 입력해주세요';
    }

    // 참가비 검증 (선택사항)
    if (params.fee != null && params.fee! < 0) {
      errors['fee'] = '참가비는 0 이상이어야 합니다';
    }

    return errors.isEmpty
        ? ValidationResult.success()
        : ValidationResult.failure(errors);
  }

  @override
  ValidationResult validateEmail(String email) {
    final errors = <String, String>{};

    if (email.trim().isEmpty) {
      errors['email'] = '이메일을 입력해주세요';
    } else {
      final emailRegex = RegExp(AppConstants.emailRegex);
      if (!emailRegex.hasMatch(email)) {
        errors['email'] = '유효한 이메일 형식이 아닙니다';
      }
    }

    return errors.isEmpty
        ? ValidationResult.success()
        : ValidationResult.failure(errors);
  }

  @override
  ValidationResult validatePhoneNumber(String phone) {
    final errors = <String, String>{};

    if (phone.trim().isEmpty) {
      errors['phone'] = '전화번호를 입력해주세요';
    } else {
      final phoneRegex = RegExp(AppConstants.phoneRegex);
      if (!phoneRegex.hasMatch(phone)) {
        errors['phone'] = '유효한 전화번호 형식이 아닙니다';
      }
    }

    return errors.isEmpty
        ? ValidationResult.success()
        : ValidationResult.failure(errors);
  }

  @override
  ValidationResult validatePassword(String password) {
    final errors = <String, String>{};

    if (password.isEmpty) {
      errors['password'] = '비밀번호를 입력해주세요';
    } else if (password.length < AppConstants.passwordMinLength) {
      errors['password'] = '비밀번호는 ${AppConstants.passwordMinLength}자 이상이어야 합니다';
    }

    return errors.isEmpty
        ? ValidationResult.success()
        : ValidationResult.failure(errors);
  }

  @override
  ValidationResult validateGroupName(String name) {
    final errors = <String, String>{};

    if (name.trim().isEmpty) {
      errors['name'] = '그룹명을 입력해주세요';
    } else if (name.length > AppConstants.maxGroupNameLength) {
      errors['name'] = '그룹명은 ${AppConstants.maxGroupNameLength}자 이하로 입력해주세요';
    }

    return errors.isEmpty
        ? ValidationResult.success()
        : ValidationResult.failure(errors);
  }

  @override
  ValidationResult validatePlayerName(String name) {
    final errors = <String, String>{};

    if (name.trim().isEmpty) {
      errors['name'] = '플레이어명을 입력해주세요';
    } else if (name.length > AppConstants.maxNameLength) {
      errors['name'] = '플레이어명은 ${AppConstants.maxNameLength}자 이하로 입력해주세요';
    }

    return errors.isEmpty
        ? ValidationResult.success()
        : ValidationResult.failure(errors);
  }
}
