import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/design_tokens.dart';
import '../../providers/rounding_provider.dart';
import '../../providers/group_provider.dart';
import '../../providers/player_provider.dart';
import '../../providers/score_provider.dart';

/// MockDatabaseService 데이터 테스트 페이지
class DataTestPage extends ConsumerWidget {
  const DataTestPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roundings = ref.watch(roundingListProvider);
    final groups = ref.watch(groupListProvider);
    final players = ref.watch(playerListProvider);
    final scores = ref.watch(scoreListProvider);

    return Scaffold(
      backgroundColor: DesignTokens.neutral50,
      appBar: AppBar(
        title: const Text('데이터 테스트'),
        backgroundColor: DesignTokens.primary600,
        foregroundColor: DesignTokens.neutral0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignTokens.spacing4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 플레이어 데이터
            _buildSection(
              '플레이어 데이터',
              players.isLoading
                  ? '로딩 중...'
                  : players.error != null
                  ? '에러: ${players.error}'
                  : '${players.players.length}명의 플레이어',
              players.players
                  .take(3)
                  .map((p) => '• ${p.name} (${p.averageScore}타 평균)')
                  .toList(),
            ),
            const SizedBox(height: DesignTokens.spacing4),

            // 그룹 데이터
            _buildSection(
              '그룹 데이터',
              groups.isLoading
                  ? '로딩 중...'
                  : groups.error != null
                  ? '에러: ${groups.error}'
                  : '${groups.groups.length}개의 그룹',
              groups.groups
                  .take(3)
                  .map((g) => '• ${g.name} (${g.members.length}명)')
                  .toList(),
            ),
            const SizedBox(height: DesignTokens.spacing4),

            // 라운딩 데이터
            _buildSection(
              '라운딩 데이터',
              roundings.isLoading
                  ? '로딩 중...'
                  : roundings.error != null
                  ? '에러: ${roundings.error}'
                  : '${roundings.roundings.length}개의 라운딩',
              roundings.roundings
                  .take(3)
                  .map((r) => '• ${r.title} (${r.courseName})')
                  .toList(),
            ),
            const SizedBox(height: DesignTokens.spacing4),

            // 스코어 데이터
            _buildSection(
              '스코어 데이터',
              scores.isLoading
                  ? '로딩 중...'
                  : scores.error != null
                  ? '에러: ${scores.error}'
                  : '${scores.scores.length}개의 스코어',
              scores.scores
                  .take(3)
                  .map((s) => '• ${s.totalScore}타 (${s.quality.displayName})')
                  .toList(),
            ),
            const SizedBox(height: DesignTokens.spacing4),

            // 새로고침 버튼
            Center(
              child: ElevatedButton(
                onPressed: () {
                  ref.invalidate(roundingListProvider);
                  ref.invalidate(groupListProvider);
                  ref.invalidate(playerListProvider);
                  ref.invalidate(scoreListProvider);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: DesignTokens.primary600,
                  foregroundColor: DesignTokens.neutral0,
                ),
                child: const Text('데이터 새로고침'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String status, List<String> items) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DesignTokens.spacing4),
      decoration: BoxDecoration(
        color: DesignTokens.neutral0,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        border: Border.all(color: DesignTokens.borderDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: DesignTokens.fontLg,
              fontWeight: DesignTokens.fontBold,
              color: DesignTokens.textPrimary,
            ),
          ),
          const SizedBox(height: DesignTokens.spacing2),
          Text(
            status,
            style: const TextStyle(
              fontSize: DesignTokens.fontSm,
              color: DesignTokens.textSecondary,
            ),
          ),
          if (items.isNotEmpty) ...[
            const SizedBox(height: DesignTokens.spacing2),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(left: DesignTokens.spacing2),
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: DesignTokens.fontSm,
                    color: DesignTokens.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
