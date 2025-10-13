import 'dart:io';
import 'package:flutter/foundation.dart';

/// 파일 업로드 결과
class UploadResult {
  final bool success;
  final String? url;
  final String? fileName;
  final int? fileSize;
  final String? error;

  const UploadResult({
    required this.success,
    this.url,
    this.fileName,
    this.fileSize,
    this.error,
  });

  factory UploadResult.success({
    required String url,
    required String fileName,
    required int fileSize,
  }) {
    return UploadResult(
      success: true,
      url: url,
      fileName: fileName,
      fileSize: fileSize,
    );
  }

  factory UploadResult.failure(String error) {
    return UploadResult(success: false, error: error);
  }
}

/// 스토리지 서비스
///
/// 이미지, 비디오, 문서 등 파일 업로드/다운로드를 처리합니다.
/// 실제 구현 시 Firebase Storage 또는 Supabase Storage를 사용하세요.
class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  /// 이미지 업로드
  ///
  /// TODO: Firebase Storage 또는 Supabase Storage 연동
  /// - Firebase: https://pub.dev/packages/firebase_storage
  /// - Supabase: https://pub.dev/packages/supabase_flutter
  Future<UploadResult> uploadImage({
    required File file,
    required String folder, // 'chat', 'profile', 'rounding', etc.
    String? userId,
  }) async {
    try {
      debugPrint('=== Image Upload ===');
      debugPrint('Folder: $folder');
      debugPrint('File: ${file.path}');
      debugPrint('User ID: $userId');

      // Mock 업로드 (2초 지연)
      await Future.delayed(const Duration(seconds: 2));

      // Mock 성공 (95% 확률)
      final success = DateTime.now().millisecond % 100 > 5;

      if (success) {
        final fileName = file.path.split('/').last;
        final fileSize = await file.length();
        final timestamp = DateTime.now().millisecondsSinceEpoch;

        // Mock URL 생성
        final url =
            'https://storage.example.com/$folder/${userId ?? 'guest'}/$timestamp-$fileName';

        debugPrint('Upload Success!');
        debugPrint('URL: $url');
        debugPrint('Size: ${(fileSize / 1024).toStringAsFixed(2)} KB');

        return UploadResult.success(
          url: url,
          fileName: fileName,
          fileSize: fileSize,
        );
      } else {
        debugPrint('Upload Failed: Network error');
        return UploadResult.failure('네트워크 오류가 발생했습니다');
      }
    } catch (e) {
      debugPrint('Upload Error: $e');
      return UploadResult.failure('파일 업로드 중 오류가 발생했습니다');
    }
  }

  /// 파일 업로드 (문서, 비디오 등)
  Future<UploadResult> uploadFile({
    required File file,
    required String folder,
    String? userId,
    int? maxSizeInMB = 10, // 최대 파일 크기 (MB)
  }) async {
    try {
      debugPrint('=== File Upload ===');
      debugPrint('Folder: $folder');
      debugPrint('File: ${file.path}');

      // 파일 크기 체크
      final fileSize = await file.length();
      final fileSizeInMB = fileSize / (1024 * 1024);

      if (maxSizeInMB != null && fileSizeInMB > maxSizeInMB) {
        debugPrint(
          'Upload Failed: File too large (${fileSizeInMB.toStringAsFixed(2)} MB)',
        );
        return UploadResult.failure('파일 크기가 너무 큽니다 (최대 $maxSizeInMB MB)');
      }

      // Mock 업로드 (2초 지연)
      await Future.delayed(const Duration(seconds: 2));

      // Mock 성공 (95% 확률)
      final success = DateTime.now().millisecond % 100 > 5;

      if (success) {
        final fileName = file.path.split('/').last;
        final timestamp = DateTime.now().millisecondsSinceEpoch;

        // Mock URL 생성
        final url =
            'https://storage.example.com/$folder/${userId ?? 'guest'}/$timestamp-$fileName';

        debugPrint('Upload Success!');
        debugPrint('URL: $url');
        debugPrint('Size: ${fileSizeInMB.toStringAsFixed(2)} MB');

        return UploadResult.success(
          url: url,
          fileName: fileName,
          fileSize: fileSize,
        );
      } else {
        debugPrint('Upload Failed: Network error');
        return UploadResult.failure('네트워크 오류가 발생했습니다');
      }
    } catch (e) {
      debugPrint('Upload Error: $e');
      return UploadResult.failure('파일 업로드 중 오류가 발생했습니다');
    }
  }

  /// 여러 이미지 업로드
  Future<List<UploadResult>> uploadMultipleImages({
    required List<File> files,
    required String folder,
    String? userId,
  }) async {
    debugPrint('=== Multiple Image Upload ===');
    debugPrint('Files count: ${files.length}');

    final results = <UploadResult>[];

    for (final file in files) {
      final result = await uploadImage(
        file: file,
        folder: folder,
        userId: userId,
      );
      results.add(result);
    }

    final successCount = results.where((r) => r.success).length;
    debugPrint('Upload complete: $successCount/${files.length} succeeded');

    return results;
  }

  /// 파일 삭제
  ///
  /// TODO: Firebase Storage 또는 Supabase Storage에서 파일 삭제
  Future<bool> deleteFile(String url) async {
    try {
      debugPrint('=== File Delete ===');
      debugPrint('URL: $url');

      // Mock 삭제 (1초 지연)
      await Future.delayed(const Duration(seconds: 1));

      debugPrint('Delete Success!');
      return true;
    } catch (e) {
      debugPrint('Delete Error: $e');
      return false;
    }
  }

  /// 파일 다운로드 URL 생성
  ///
  /// 보안을 위해 임시 다운로드 URL을 생성합니다 (예: signed URL)
  Future<String?> getDownloadUrl(String storagePath) async {
    try {
      debugPrint('=== Get Download URL ===');
      debugPrint('Path: $storagePath');

      // Mock URL 생성 (0.5초 지연)
      await Future.delayed(const Duration(milliseconds: 500));

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final url =
          'https://storage.example.com/download/$storagePath?token=$timestamp';

      debugPrint('Download URL: $url');
      return url;
    } catch (e) {
      debugPrint('Get URL Error: $e');
      return null;
    }
  }

  /// 파일 유형 판별
  String getFileType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();

    // 이미지
    if (['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'].contains(extension)) {
      return 'image';
    }

    // 비디오
    if (['mp4', 'mov', 'avi', 'mkv', 'webm'].contains(extension)) {
      return 'video';
    }

    // 문서
    if ([
      'pdf',
      'doc',
      'docx',
      'xls',
      'xlsx',
      'ppt',
      'pptx',
      'txt',
    ].contains(extension)) {
      return 'document';
    }

    // 기타
    return 'file';
  }

  /// 파일 크기를 읽기 쉬운 형식으로 변환
  String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }
}
