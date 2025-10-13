/// Result 타입 - 함수형 프로그래밍 패턴
///
/// 성공 또는 실패를 나타내는 타입 안전한 결과 객체입니다.
/// 예외 처리 대신 명시적인 성공/실패 상태를 관리합니다.

/// 성공 또는 실패를 나타내는 결과
class Result<T> {
  final T? _data;
  final Failure? _failure;

  const Result._(this._data, this._failure);

  /// 성공 결과 생성
  factory Result.success(T data) => Result._(data, null);

  /// 실패 결과 생성
  factory Result.failure(Failure failure) => Result._(null, failure);

  /// 성공 여부 확인
  bool get isSuccess => _data != null && _failure == null;

  /// 실패 여부 확인
  bool get isFailure => _failure != null;

  /// 데이터 가져오기 (성공시에만)
  T get data {
    if (isSuccess) return _data as T;
    throw StateError('Result is in failure state');
  }

  /// 실패 정보 가져오기 (실패시에만)
  Failure get failure {
    if (isFailure) return _failure!;
    throw StateError('Result is in success state');
  }

  /// 성공시 콜백 실행
  Result<R> map<R>(R Function(T) mapper) {
    if (isSuccess) {
      try {
        return Result.success(mapper(data));
      } catch (e) {
        return Result.failure(UnknownFailure(e.toString()));
      }
    }
    return Result.failure(failure);
  }

  /// 실패시 콜백 실행
  Result<T> mapFailure(Failure Function(Failure) mapper) {
    if (isFailure) {
      return Result.failure(mapper(failure));
    }
    return this;
  }

  /// 성공시 콜백 실행하고 결과 반환
  Future<Result<R>> mapAsync<R>(Future<R> Function(T) mapper) async {
    if (isSuccess) {
      try {
        final result = await mapper(data);
        return Result.success(result);
      } catch (e) {
        return Result.failure(UnknownFailure(e.toString()));
      }
    }
    return Result.failure(failure);
  }

  /// fold 패턴 - 성공/실패 모두 처리
  R fold<R>(R Function(Failure) onFailure, R Function(T) onSuccess) {
    if (isFailure) {
      return onFailure(failure);
    }
    return onSuccess(data);
  }

  /// 성공시 값 반환, 실패시 기본값 반환
  T getOrElse(T defaultValue) {
    return isSuccess ? data : defaultValue;
  }

  /// 성공시 값 반환, 실패시 null 반환
  T? getOrNull() {
    return isSuccess ? data : null;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Result<T> &&
        other._data == _data &&
        other._failure == _failure;
  }

  @override
  int get hashCode => Object.hash(_data, _failure);

  @override
  String toString() {
    if (isSuccess) {
      return 'Result.success($data)';
    }
    return 'Result.failure($failure)';
  }
}

/// 실패를 나타내는 추상 클래스
abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

/// 네트워크 관련 실패
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// 검증 실패
class ValidationFailure extends Failure {
  final Map<String, String> errors;

  const ValidationFailure(super.message, this.errors);

  @override
  String toString() => '$message: $errors';
}

/// 권한 실패
class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}

/// 인증 실패
class AuthenticationFailure extends Failure {
  const AuthenticationFailure(super.message);
}

/// 알 수 없는 실패
class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}

/// 비즈니스 로직 실패
class BusinessLogicFailure extends Failure {
  const BusinessLogicFailure(super.message);
}

/// 데이터베이스 실패
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

/// 파일 처리 실패
class FileFailure extends Failure {
  const FileFailure(super.message);
}

/// Result 확장 메서드들
extension ResultExtensions<T> on Result<T> {
  /// 결과가 성공인지 확인하고 데이터 반환
  T? get dataOrNull => isSuccess ? data : null;

  /// 결과가 성공인지 확인하고 데이터 반환, 실패시 예외 발생
  T get dataOrThrow {
    if (isSuccess) return data;
    throw Exception(failure.message);
  }

  /// 결과를 Future로 변환
  Future<T> toFuture() {
    if (isSuccess) {
      return Future.value(data);
    }
    return Future.error(failure);
  }

  /// 결과를 Stream으로 변환
  Stream<T> toStream() {
    if (isSuccess) {
      return Stream.value(data);
    }
    return Stream.error(failure);
  }
}
