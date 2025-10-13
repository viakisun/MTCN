import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/theme/design_tokens.dart';
import '../../services/gps_tracking_service.dart';

/// GPS 트래킹 지도 위젯
///
/// 실시간으로 플레이어의 위치를 추적하고 이동 거리를 표시합니다.
class GpsTrackingMapWidget extends ConsumerStatefulWidget {
  final String roundingId;
  final String playerName;

  const GpsTrackingMapWidget({
    super.key,
    required this.roundingId,
    required this.playerName,
  });

  @override
  ConsumerState<GpsTrackingMapWidget> createState() =>
      _GpsTrackingMapWidgetState();
}

class _GpsTrackingMapWidgetState extends ConsumerState<GpsTrackingMapWidget> {
  final GpsTrackingService _gpsService = GpsTrackingService.instance;
  GoogleMapController? _mapController;

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  bool _isTracking = false;
  LocationData? _currentLocation;
  double _totalDistance = 0.0;
  List<LatLng> _pathPoints = [];

  @override
  void initState() {
    super.initState();
    _initializeTracking();
  }

  @override
  void dispose() {
    if (_isTracking) {
      _gpsService.stopTracking();
    }
    super.dispose();
  }

  Future<void> _initializeTracking() async {
    // Get current location first
    final location = await _gpsService.getCurrentLocation();
    if (location != null && mounted) {
      setState(() {
        _currentLocation = location;
        _updateMarker(location);
        _moveCameraToCurrentLocation(location);
      });
    }

    // Listen to location updates
    _gpsService.locationStream.listen((location) {
      if (mounted) {
        setState(() {
          _currentLocation = location;
          _totalDistance = _gpsService.totalDistance;
          _updateMarker(location);
          _updatePath(location);
          _moveCameraToCurrentLocation(location);
        });
      }
    });
  }

  void _updateMarker(LocationData location) {
    _markers.clear();
    _markers.add(
      Marker(
        markerId: const MarkerId('current_location'),
        position: LatLng(location.latitude, location.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: InfoWindow(title: widget.playerName, snippet: '현재 위치'),
      ),
    );
  }

  void _updatePath(LocationData location) {
    _pathPoints.add(LatLng(location.latitude, location.longitude));

    _polylines.clear();
    if (_pathPoints.length > 1) {
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('path'),
          points: _pathPoints,
          color: DesignTokens.primary600,
          width: 4,
        ),
      );
    }
  }

  void _moveCameraToCurrentLocation(LocationData location) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(LatLng(location.latitude, location.longitude)),
    );
  }

  Future<void> _toggleTracking() async {
    if (_isTracking) {
      await _gpsService.stopTracking();
      setState(() {
        _isTracking = false;
      });
    } else {
      final started = await _gpsService.startTracking();
      if (started && mounted) {
        setState(() {
          _isTracking = true;
        });
      }
    }
  }

  void _resetTracking() {
    _gpsService.resetTracking();
    setState(() {
      _pathPoints.clear();
      _polylines.clear();
      _totalDistance = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Default location (Seoul Golf Club as example)
    final initialLocation = _currentLocation != null
        ? LatLng(_currentLocation!.latitude, _currentLocation!.longitude)
        : const LatLng(37.5665, 126.9780);

    return Container(
      height: 500,
      decoration: const BoxDecoration(
        color: DesignTokens.neutral0,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DesignTokens.radiusXl),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(DesignTokens.spacing4),
            decoration: const BoxDecoration(
              color: DesignTokens.neutral0,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(DesignTokens.radiusXl),
              ),
              border: Border(
                bottom: BorderSide(color: DesignTokens.neutral200),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.my_location,
                  color: DesignTokens.primary600,
                  size: 24,
                ),
                const SizedBox(width: DesignTokens.spacing2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'GPS 트래킹',
                        style: TextStyle(
                          fontSize: DesignTokens.fontLg,
                          fontWeight: DesignTokens.fontBold,
                          color: DesignTokens.textPrimary,
                        ),
                      ),
                      Text(
                        widget.playerName,
                        style: const TextStyle(
                          fontSize: DesignTokens.fontXs,
                          color: DesignTokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Map
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: initialLocation,
                    zoom: 16,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  markers: _markers,
                  polylines: _polylines,
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                ),

                // Stats overlay
                Positioned(
                  top: DesignTokens.spacing3,
                  left: DesignTokens.spacing3,
                  right: DesignTokens.spacing3,
                  child: Container(
                    padding: const EdgeInsets.all(DesignTokens.spacing3),
                    decoration: BoxDecoration(
                      color: DesignTokens.neutral0.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radiusLg,
                      ),
                      boxShadow: DesignTokens.shadowMd,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          Icons.straighten,
                          '이동거리',
                          _gpsService.formatDistance(_totalDistance),
                          DesignTokens.primary600,
                        ),
                        _buildStatItem(
                          Icons.speed,
                          '평균속도',
                          _gpsService.getAverageSpeed() != null
                              ? _gpsService.formatSpeed(
                                  _gpsService.getAverageSpeed()!,
                                )
                              : '0.0 km/h',
                          DesignTokens.success,
                        ),
                        _buildStatItem(
                          Icons.location_on,
                          '추적중',
                          _isTracking ? 'ON' : 'OFF',
                          _isTracking
                              ? DesignTokens.success
                              : DesignTokens.error,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Controls
          Container(
            padding: const EdgeInsets.all(DesignTokens.spacing4),
            decoration: const BoxDecoration(
              color: DesignTokens.neutral0,
              border: Border(top: BorderSide(color: DesignTokens.neutral200)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _toggleTracking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isTracking
                            ? DesignTokens.error
                            : DesignTokens.primary600,
                        padding: const EdgeInsets.symmetric(
                          vertical: DesignTokens.spacing3,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            DesignTokens.radiusLg,
                          ),
                        ),
                      ),
                      icon: Icon(
                        _isTracking ? Icons.stop : Icons.play_arrow,
                        color: DesignTokens.neutral0,
                      ),
                      label: Text(
                        _isTracking ? '추적 중지' : '추적 시작',
                        style: const TextStyle(
                          fontSize: DesignTokens.fontBase,
                          fontWeight: DesignTokens.fontSemibold,
                          color: DesignTokens.neutral0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: DesignTokens.spacing2),
                  OutlinedButton.icon(
                    onPressed: _resetTracking,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: DesignTokens.spacing3,
                        horizontal: DesignTokens.spacing4,
                      ),
                      side: const BorderSide(color: DesignTokens.neutral300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusLg,
                        ),
                      ),
                    ),
                    icon: const Icon(
                      Icons.refresh,
                      color: DesignTokens.textPrimary,
                    ),
                    label: const Text(
                      '리셋',
                      style: TextStyle(
                        fontSize: DesignTokens.fontBase,
                        fontWeight: DesignTokens.fontSemibold,
                        color: DesignTokens.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: DesignTokens.fontXs,
            color: DesignTokens.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: DesignTokens.fontSm,
            fontWeight: DesignTokens.fontBold,
            color: color,
          ),
        ),
      ],
    );
  }
}
