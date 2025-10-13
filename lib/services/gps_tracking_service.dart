import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

/// GPS 위치 정보
class LocationData {
  final double latitude;
  final double longitude;
  final double? altitude;
  final double? speed; // m/s
  final double? accuracy;
  final DateTime timestamp;

  const LocationData({
    required this.latitude,
    required this.longitude,
    this.altitude,
    this.speed,
    this.accuracy,
    required this.timestamp,
  });

  factory LocationData.fromPosition(Position position) {
    return LocationData(
      latitude: position.latitude,
      longitude: position.longitude,
      altitude: position.altitude,
      speed: position.speed,
      accuracy: position.accuracy,
      timestamp: position.timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
      'speed': speed,
      'accuracy': accuracy,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

/// GPS 트래킹 서비스
///
/// 위치 추적, 거리 계산, 속도 계산 등을 제공합니다.
/// 실제 구현 시 백그라운드 위치 추적도 고려하세요.
class GpsTrackingService {
  GpsTrackingService._();
  static final GpsTrackingService instance = GpsTrackingService._();

  StreamSubscription<Position>? _positionStreamSubscription;
  final _locationController = StreamController<LocationData>.broadcast();

  // 위치 스트림
  Stream<LocationData> get locationStream => _locationController.stream;

  // 현재 위치
  LocationData? _currentLocation;
  LocationData? get currentLocation => _currentLocation;

  // 추적 중인지 여부
  bool _isTracking = false;
  bool get isTracking => _isTracking;

  // 이동 거리 (미터)
  double _totalDistance = 0.0;
  double get totalDistance => _totalDistance;

  // 이동 경로
  final List<LocationData> _locationHistory = [];
  List<LocationData> get locationHistory => List.unmodifiable(_locationHistory);

  /// 위치 권한 확인
  Future<bool> checkPermission() async {
    try {
      // 위치 서비스가 활성화되어 있는지 확인
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('Location services are disabled');
        return false;
      }

      // 위치 권한 확인
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('Location permissions are denied');
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('Location permissions are permanently denied');
        return false;
      }

      debugPrint('Location permission granted');
      return true;
    } catch (e) {
      debugPrint('Error checking location permission: $e');
      return false;
    }
  }

  /// 현재 위치 가져오기 (1회)
  Future<LocationData?> getCurrentLocation() async {
    try {
      final hasPermission = await checkPermission();
      if (!hasPermission) return null;

      debugPrint('Getting current location...');

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final location = LocationData.fromPosition(position);
      _currentLocation = location;

      debugPrint(
        'Current location: ${location.latitude}, ${location.longitude}',
      );
      return location;
    } catch (e) {
      debugPrint('Error getting current location: $e');
      return null;
    }
  }

  /// GPS 추적 시작
  Future<bool> startTracking() async {
    if (_isTracking) {
      debugPrint('GPS tracking is already running');
      return true;
    }

    try {
      final hasPermission = await checkPermission();
      if (!hasPermission) return false;

      debugPrint('Starting GPS tracking...');

      // 추적 상태 초기화
      _isTracking = true;
      _totalDistance = 0.0;
      _locationHistory.clear();

      // 위치 스트림 시작
      const locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // 10m 이상 이동시 업데이트
      );

      _positionStreamSubscription =
          Geolocator.getPositionStream(
            locationSettings: locationSettings,
          ).listen(
            (Position position) {
              final location = LocationData.fromPosition(position);

              // 이전 위치와의 거리 계산
              if (_currentLocation != null) {
                final distance = Geolocator.distanceBetween(
                  _currentLocation!.latitude,
                  _currentLocation!.longitude,
                  location.latitude,
                  location.longitude,
                );
                _totalDistance += distance;
              }

              _currentLocation = location;
              _locationHistory.add(location);
              _locationController.add(location);

              debugPrint(
                'Location updated: ${location.latitude}, ${location.longitude} | Total distance: ${_totalDistance.toStringAsFixed(1)}m',
              );
            },
            onError: (error) {
              debugPrint('Error in location stream: $error');
            },
          );

      debugPrint('GPS tracking started');
      return true;
    } catch (e) {
      debugPrint('Error starting GPS tracking: $e');
      _isTracking = false;
      return false;
    }
  }

  /// GPS 추적 중지
  Future<void> stopTracking() async {
    debugPrint('Stopping GPS tracking...');

    _isTracking = false;
    await _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;

    debugPrint(
      'GPS tracking stopped | Total distance: ${_totalDistance.toStringAsFixed(1)}m',
    );
  }

  /// 두 지점 사이의 거리 계산 (미터)
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  /// 두 지점 사이의 방위각 계산 (도)
  double calculateBearing(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.bearingBetween(lat1, lon1, lat2, lon2);
  }

  /// 평균 속도 계산 (km/h)
  double? getAverageSpeed() {
    if (_locationHistory.length < 2) return null;

    final firstLocation = _locationHistory.first;
    final lastLocation = _locationHistory.last;

    final duration = lastLocation.timestamp.difference(firstLocation.timestamp);
    if (duration.inSeconds == 0) return null;

    // m/s -> km/h
    final avgSpeed = (_totalDistance / duration.inSeconds) * 3.6;
    return avgSpeed;
  }

  /// 현재 속도 (km/h)
  double? getCurrentSpeed() {
    if (_currentLocation?.speed == null) return null;
    // m/s -> km/h
    return _currentLocation!.speed! * 3.6;
  }

  /// 추적 데이터 리셋
  void resetTracking() {
    _totalDistance = 0.0;
    _locationHistory.clear();
    _currentLocation = null;
    debugPrint('GPS tracking data reset');
  }

  /// 거리를 읽기 쉬운 형식으로 변환
  String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toStringAsFixed(0)}m';
    } else {
      return '${(meters / 1000).toStringAsFixed(2)}km';
    }
  }

  /// 속도를 읽기 쉬운 형식으로 변환
  String formatSpeed(double kmPerHour) {
    return '${kmPerHour.toStringAsFixed(1)} km/h';
  }

  /// 리소스 정리
  Future<void> dispose() async {
    await stopTracking();
    await _locationController.close();
    debugPrint('GPS Tracking Service disposed');
  }
}
