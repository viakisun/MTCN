import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/design_tokens.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/home/home_page.dart';
import 'screens/rounding/rounding_page.dart';
import 'screens/groups/groups_page.dart';
import 'screens/score/score_page.dart';
import 'screens/profile/profile_page.dart';
import 'screens/test/data_test_page.dart';
import 'services/chat_service_new.dart';
import 'data/services/mock_database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null);

  // 라이브 라운딩 채팅 초기화 (Rounding ID: '2')
  final mockDb = MockDatabaseService();
  final players = await mockDb.getPlayers();
  ChatServiceNew.instance.initializeLiveRoundingChat(
    '2',
    players.take(4).toList(),
  );

  // 그룹 채팅 초기화 - 데모용으로 일부 그룹 ID를 미리 초기화
  // 실제로는 MockDataService에서 생성된 그룹 ID를 사용해야 하지만,
  // 데모를 위해 일반적인 그룹 ID 패턴으로 초기화
  // 그룹 채팅은 그룹 페이지에서 그룹을 탭하면 동적으로 초기화됩니다.

  // Set system UI overlay style for mobile
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: DesignTokens.neutral0,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Lock orientation to portrait on mobile
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const ProviderScope(child: MTCNGolfApp()));
}

class MTCNGolfApp extends StatelessWidget {
  const MTCNGolfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MTCN Golf',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: const Locale('ko', 'KR'),
      home: const SplashScreen(),
      builder: (context, child) {
        // Ensure text scale factor doesn't go beyond reasonable limits
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.3),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}

// Active tab provider
final activeTabProvider = StateProvider<int>((ref) => 0);

class MainNavigator extends ConsumerWidget {
  const MainNavigator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = ref.watch(activeTabProvider);

    final List<Widget> pages = const [
      HomePage(),
      RoundingPage(),
      GroupsPage(),
      ScorePage(),
      ProfilePage(),
      DataTestPage(),
    ];

    return Scaffold(
      body: IndexedStack(index: activeTab, children: pages),
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: DesignTokens.neutral0,
            border: Border(
              top: BorderSide(color: DesignTokens.neutral200, width: 0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 8,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: activeTab,
            onTap: (index) {
              // Haptic feedback on tap
              HapticFeedback.lightImpact();
              ref.read(activeTabProvider.notifier).state = index;
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: DesignTokens.primary600,
            unselectedItemColor: DesignTokens.textSecondary,
            selectedFontSize: 11,
            unselectedFontSize: 11,
            selectedLabelStyle: const TextStyle(
              fontWeight: DesignTokens.fontSemibold,
              height: 1.5,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: DesignTokens.fontNormal,
              height: 1.5,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.home_outlined, size: 24),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.home, size: 24),
                ),
                label: '홈',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.calendar_today_outlined, size: 24),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.calendar_today, size: 24),
                ),
                label: '라운딩',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.groups_outlined, size: 24),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.groups, size: 24),
                ),
                label: '모임',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.bar_chart_outlined, size: 24),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.bar_chart, size: 24),
                ),
                label: '스코어',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.person_outline, size: 24),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.person, size: 24),
                ),
                label: '프로필',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.data_usage_outlined, size: 24),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.data_usage, size: 24),
                ),
                label: '테스트',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
