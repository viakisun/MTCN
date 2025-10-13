import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/design_tokens.dart';
import '../../models/rounding.dart';

/// 한국 주요 골프장 리스트 (검색용)
class GolfCourse {
  final String name;
  final String address;
  final String region;
  final int? avgGreenFee;

  const GolfCourse({
    required this.name,
    required this.address,
    required this.region,
    this.avgGreenFee,
  });
}

const List<GolfCourse> _koreanGolfCourses = [
  GolfCourse(
    name: '스카이72 골프클럽',
    address: '인천광역시 중구 공항동로 424번길 186',
    region: '인천',
    avgGreenFee: 180000,
  ),
  GolfCourse(
    name: '남서울 컨트리클럽',
    address: '경기도 성남시 분당구 판교로 550',
    region: '경기',
    avgGreenFee: 220000,
  ),
  GolfCourse(
    name: '레이크사이드 컨트리클럽',
    address: '경기도 용인시 처인구 양지면 남곡로 210',
    region: '경기',
    avgGreenFee: 250000,
  ),
  GolfCourse(
    name: '안양 베네스트 골프클럽',
    address: '경기도 안양시 동안구 평촌대로 389',
    region: '경기',
    avgGreenFee: 200000,
  ),
  GolfCourse(
    name: '화산 컨트리클럽',
    address: '충청북도 청주시 상당구 문의면 화산길 130',
    region: '충북',
    avgGreenFee: 170000,
  ),
  GolfCourse(
    name: '제주 핀크스 골프클럽',
    address: '제주특별자치도 서귀포시 안덕면 산록남로 863',
    region: '제주',
    avgGreenFee: 300000,
  ),
  GolfCourse(
    name: '나인브릿지 골프클럽',
    address: '제주특별자치도 서귀포시 안덕면 산록남로 711',
    region: '제주',
    avgGreenFee: 400000,
  ),
  GolfCourse(
    name: '써밋 골프 리조트',
    address: '경기도 하남시 미사강변한강로 400',
    region: '경기',
    avgGreenFee: 190000,
  ),
  GolfCourse(
    name: '블루원 용인 CC',
    address: '경기도 용인시 처인구 모현읍 능원로 285',
    region: '경기',
    avgGreenFee: 210000,
  ),
  GolfCourse(
    name: 'PGA 골프클럽',
    address: '경기도 이천시 마장면 장암리 301',
    region: '경기',
    avgGreenFee: 230000,
  ),
];

class CreateRoundingPage extends ConsumerStatefulWidget {
  const CreateRoundingPage({super.key});

  @override
  ConsumerState<CreateRoundingPage> createState() => _CreateRoundingPageState();
}

class _CreateRoundingPageState extends ConsumerState<CreateRoundingPage> {
  final TextEditingController _nameController = TextEditingController(
    text: '2월 정기 라운딩',
  );
  final TextEditingController _courseSearchController = TextEditingController();
  final TextEditingController _maxParticipantsController =
      TextEditingController(text: '24');
  final TextEditingController _feeController = TextEditingController();
  final TextEditingController _greenFeeController = TextEditingController();

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 7, minute: 0);

  String _teamAssignmentMethod = 'auto'; // auto, manual, random
  bool _enableQRCheckin = true;
  bool _enableLiveScore = true;
  bool _enableAutoReport = true;

  // Phase 2 추가 필드
  GolfCourse? _selectedCourse;
  bool _includeCaddie = false;
  bool _includeCart = true;
  bool _includeMeal = false;
  String? _mealType; // 'breakfast', 'lunch', 'dinner'
  bool _showCourseSearch = false;
  List<GolfCourse> _filteredCourses = [];

  @override
  void initState() {
    super.initState();
    _courseSearchController.addListener(_onCourseSearchChanged);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _courseSearchController.dispose();
    _maxParticipantsController.dispose();
    _feeController.dispose();
    _greenFeeController.dispose();
    super.dispose();
  }

  void _onCourseSearchChanged() {
    final query = _courseSearchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCourses = [];
      } else {
        _filteredCourses = _koreanGolfCourses
            .where(
              (course) =>
                  course.name.toLowerCase().contains(query) ||
                  course.address.toLowerCase().contains(query) ||
                  course.region.contains(query),
            )
            .toList();
      }
    });
  }

  void _selectCourse(GolfCourse course) {
    setState(() {
      _selectedCourse = course;
      _courseSearchController.text = course.name;
      _showCourseSearch = false;
      _filteredCourses = [];
      // 평균 그린피 자동 입력
      if (course.avgGreenFee != null) {
        _greenFeeController.text = course.avgGreenFee.toString();
      }
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveRounding() {
    // 입력 검증
    if (_selectedCourse == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('골프장을 선택해주세요'),
          backgroundColor: DesignTokens.error,
        ),
      );
      return;
    }

    // TODO: 실제 Provider로 저장
    final options = RoundingOptions(
      includeCaddie: _includeCaddie,
      includeCart: _includeCart,
      includeMeal: _includeMeal,
      mealType: _mealType,
    );

    // 임시로 콘솔에 출력
    debugPrint('=== 라운딩 생성 ===');
    debugPrint('이름: ${_nameController.text}');
    debugPrint('골프장: ${_selectedCourse!.name}');
    debugPrint('주소: ${_selectedCourse!.address}');
    debugPrint('날짜: ${_selectedDate.toString().split(' ')[0]}');
    debugPrint('시간: ${_selectedTime.format(context)}');
    debugPrint('최대 인원: ${_maxParticipantsController.text}');
    debugPrint('참가비: ${_feeController.text}');
    debugPrint('그린피: ${_greenFeeController.text}');
    debugPrint('옵션: ${options.toJson()}');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('라운딩이 생성되었습니다!'),
        backgroundColor: DesignTokens.success,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.neutral50,
      appBar: AppBar(
        backgroundColor: DesignTokens.neutral0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: DesignTokens.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '정기 라운딩 생성',
          style: TextStyle(
            fontSize: DesignTokens.fontBase,
            fontWeight: DesignTokens.fontSemibold,
            color: DesignTokens.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.check,
              color: DesignTokens.primary600,
              size: 24,
            ),
            onPressed: _saveRounding,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignTokens.spacing4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic Info Section
            _buildBasicInfoSection(),
            const SizedBox(height: DesignTokens.spacing4),

            // Golf Course Selection Section
            _buildGolfCourseSection(),
            const SizedBox(height: DesignTokens.spacing4),

            // Fee & Participants Section
            _buildFeeSection(),
            const SizedBox(height: DesignTokens.spacing4),

            // Options Section (Caddie, Cart, Meal)
            _buildOptionsSection(),
            const SizedBox(height: DesignTokens.spacing4),

            // Team Assignment Section
            _buildTeamAssignmentSection(),
            const SizedBox(height: DesignTokens.spacing4),

            // Feature Settings Section
            _buildFeatureSettingsSection(),
            const SizedBox(height: DesignTokens.spacing6),

            // Create Button
            _buildCreateButton(),
            const SizedBox(height: DesignTokens.spacing4),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacing4),
      decoration: BoxDecoration(
        color: DesignTokens.neutral0,
        borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
        boxShadow: DesignTokens.shadowMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('📅', style: TextStyle(fontSize: 20)),
              SizedBox(width: DesignTokens.spacing2),
              Text(
                '기본 정보',
                style: TextStyle(
                  fontSize: DesignTokens.fontLg,
                  fontWeight: DesignTokens.fontBold,
                  color: DesignTokens.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacing4),

          // Rounding Name
          const Text(
            '라운딩명',
            style: TextStyle(
              fontSize: DesignTokens.fontSm,
              fontWeight: DesignTokens.fontSemibold,
              color: DesignTokens.textPrimary,
            ),
          ),
          const SizedBox(height: DesignTokens.spacing2),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: '2월 정기 라운딩',
              filled: true,
              fillColor: DesignTokens.neutral50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
                borderSide: const BorderSide(color: DesignTokens.neutral200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
                borderSide: const BorderSide(color: DesignTokens.neutral200),
              ),
              contentPadding: const EdgeInsets.all(DesignTokens.spacing3),
            ),
          ),
          const SizedBox(height: DesignTokens.spacing4),

          // Date and Time Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '날짜',
                      style: TextStyle(
                        fontSize: DesignTokens.fontSm,
                        fontWeight: DesignTokens.fontSemibold,
                        color: DesignTokens.textPrimary,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacing2),
                    InkWell(
                      onTap: _selectDate,
                      child: Container(
                        padding: const EdgeInsets.all(DesignTokens.spacing3),
                        decoration: BoxDecoration(
                          color: DesignTokens.neutral50,
                          borderRadius: BorderRadius.circular(
                            DesignTokens.radiusLg,
                          ),
                          border: Border.all(color: DesignTokens.neutral200),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: DesignTokens.textSecondary,
                            ),
                            const SizedBox(width: DesignTokens.spacing2),
                            Text(
                              '${_selectedDate.year}.${_selectedDate.month.toString().padLeft(2, '0')}.${_selectedDate.day.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                fontSize: DesignTokens.fontSm,
                                color: DesignTokens.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: DesignTokens.spacing3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '시작 시간',
                      style: TextStyle(
                        fontSize: DesignTokens.fontSm,
                        fontWeight: DesignTokens.fontSemibold,
                        color: DesignTokens.textPrimary,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacing2),
                    InkWell(
                      onTap: _selectTime,
                      child: Container(
                        padding: const EdgeInsets.all(DesignTokens.spacing3),
                        decoration: BoxDecoration(
                          color: DesignTokens.neutral50,
                          borderRadius: BorderRadius.circular(
                            DesignTokens.radiusLg,
                          ),
                          border: Border.all(color: DesignTokens.neutral200),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 16,
                              color: DesignTokens.textSecondary,
                            ),
                            const SizedBox(width: DesignTokens.spacing2),
                            Text(
                              '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                fontSize: DesignTokens.fontSm,
                                color: DesignTokens.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildGolfCourseSection() {
    return Container(
          padding: const EdgeInsets.all(DesignTokens.spacing4),
          decoration: BoxDecoration(
            color: DesignTokens.neutral0,
            borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
            boxShadow: DesignTokens.shadowMd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Text('⛳', style: TextStyle(fontSize: 20)),
                  SizedBox(width: DesignTokens.spacing2),
                  Text(
                    '골프장 선택',
                    style: TextStyle(
                      fontSize: DesignTokens.fontLg,
                      fontWeight: DesignTokens.fontBold,
                      color: DesignTokens.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: DesignTokens.spacing4),

              // Golf Course Search
              TextField(
                controller: _courseSearchController,
                onTap: () => setState(() => _showCourseSearch = true),
                decoration: InputDecoration(
                  hintText: '골프장 검색 (이름, 지역)',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _selectedCourse != null
                      ? IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          onPressed: () {
                            setState(() {
                              _selectedCourse = null;
                              _courseSearchController.clear();
                              _greenFeeController.clear();
                            });
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: DesignTokens.neutral50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
                    borderSide: const BorderSide(
                      color: DesignTokens.neutral200,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
                    borderSide: const BorderSide(
                      color: DesignTokens.neutral200,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
                    borderSide: const BorderSide(
                      color: DesignTokens.primary600,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(DesignTokens.spacing3),
                ),
              ),

              // Search Results Dropdown
              if (_showCourseSearch && _filteredCourses.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: DesignTokens.spacing2),
                  decoration: BoxDecoration(
                    color: DesignTokens.neutral0,
                    borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
                    border: Border.all(color: DesignTokens.neutral200),
                    boxShadow: DesignTokens.shadowLg,
                  ),
                  constraints: const BoxConstraints(maxHeight: 250),
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(DesignTokens.spacing2),
                    itemCount: _filteredCourses.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final course = _filteredCourses[index];
                      return ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: DesignTokens.spacing2,
                          vertical: DesignTokens.spacing1,
                        ),
                        title: Text(
                          course.name,
                          style: const TextStyle(
                            fontSize: DesignTokens.fontSm,
                            fontWeight: DesignTokens.fontSemibold,
                          ),
                        ),
                        subtitle: Text(
                          '${course.region} · ${course.address}',
                          style: const TextStyle(
                            fontSize: DesignTokens.fontXs,
                            color: DesignTokens.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: course.avgGreenFee != null
                            ? Text(
                                '${(course.avgGreenFee! / 10000).toInt()}만원',
                                style: const TextStyle(
                                  fontSize: DesignTokens.fontXs,
                                  color: DesignTokens.primary600,
                                  fontWeight: DesignTokens.fontSemibold,
                                ),
                              )
                            : null,
                        onTap: () => _selectCourse(course),
                      );
                    },
                  ),
                ),

              // Selected Course Display
              if (_selectedCourse != null) ...[
                const SizedBox(height: DesignTokens.spacing3),
                Container(
                  padding: const EdgeInsets.all(DesignTokens.spacing3),
                  decoration: BoxDecoration(
                    color: DesignTokens.primary50,
                    borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
                    border: Border.all(color: DesignTokens.primary200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: DesignTokens.primary600,
                            size: 18,
                          ),
                          const SizedBox(width: DesignTokens.spacing2),
                          Expanded(
                            child: Text(
                              _selectedCourse!.name,
                              style: const TextStyle(
                                fontSize: DesignTokens.fontSm,
                                fontWeight: DesignTokens.fontSemibold,
                                color: DesignTokens.primary600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: DesignTokens.spacing1),
                      Text(
                        _selectedCourse!.address,
                        style: const TextStyle(
                          fontSize: DesignTokens.fontXs,
                          color: DesignTokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms, delay: 50.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildFeeSection() {
    return Container(
          padding: const EdgeInsets.all(DesignTokens.spacing4),
          decoration: BoxDecoration(
            color: DesignTokens.neutral0,
            borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
            boxShadow: DesignTokens.shadowMd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Text('💰', style: TextStyle(fontSize: 20)),
                  SizedBox(width: DesignTokens.spacing2),
                  Text(
                    '비용 및 인원',
                    style: TextStyle(
                      fontSize: DesignTokens.fontLg,
                      fontWeight: DesignTokens.fontBold,
                      color: DesignTokens.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: DesignTokens.spacing4),

              // Max Participants
              const Text(
                '최대 참가 인원',
                style: TextStyle(
                  fontSize: DesignTokens.fontSm,
                  fontWeight: DesignTokens.fontSemibold,
                  color: DesignTokens.textPrimary,
                ),
              ),
              const SizedBox(height: DesignTokens.spacing2),
              TextField(
                controller: _maxParticipantsController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: '24',
                  suffixText: '명',
                  filled: true,
                  fillColor: DesignTokens.neutral50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
                    borderSide: const BorderSide(
                      color: DesignTokens.neutral200,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
                    borderSide: const BorderSide(
                      color: DesignTokens.neutral200,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(DesignTokens.spacing3),
                ),
              ),
              const SizedBox(height: DesignTokens.spacing4),

              // Green Fee & Participation Fee Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '그린피',
                          style: TextStyle(
                            fontSize: DesignTokens.fontSm,
                            fontWeight: DesignTokens.fontSemibold,
                            color: DesignTokens.textPrimary,
                          ),
                        ),
                        const SizedBox(height: DesignTokens.spacing2),
                        TextField(
                          controller: _greenFeeController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            hintText: '180000',
                            suffixText: '원',
                            filled: true,
                            fillColor: DesignTokens.neutral50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                DesignTokens.radiusLg,
                              ),
                              borderSide: const BorderSide(
                                color: DesignTokens.neutral200,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                DesignTokens.radiusLg,
                              ),
                              borderSide: const BorderSide(
                                color: DesignTokens.neutral200,
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(
                              DesignTokens.spacing3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: DesignTokens.spacing3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '참가비',
                          style: TextStyle(
                            fontSize: DesignTokens.fontSm,
                            fontWeight: DesignTokens.fontSemibold,
                            color: DesignTokens.textPrimary,
                          ),
                        ),
                        const SizedBox(height: DesignTokens.spacing2),
                        TextField(
                          controller: _feeController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            hintText: '50000',
                            suffixText: '원',
                            filled: true,
                            fillColor: DesignTokens.neutral50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                DesignTokens.radiusLg,
                              ),
                              borderSide: const BorderSide(
                                color: DesignTokens.neutral200,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                DesignTokens.radiusLg,
                              ),
                              borderSide: const BorderSide(
                                color: DesignTokens.neutral200,
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(
                              DesignTokens.spacing3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: DesignTokens.spacing3),

              // Info Note
              Container(
                padding: const EdgeInsets.all(DesignTokens.spacing3),
                decoration: BoxDecoration(
                  color: DesignTokens.infoLight,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('💡', style: TextStyle(fontSize: 16)),
                    SizedBox(width: DesignTokens.spacing2),
                    Expanded(
                      child: Text(
                        '참가비는 그린피와 별도로 수금되며, 식사비나 경품 구입비로 사용됩니다.',
                        style: TextStyle(
                          fontSize: DesignTokens.fontXs,
                          color: DesignTokens.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms, delay: 100.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildOptionsSection() {
    return Container(
          padding: const EdgeInsets.all(DesignTokens.spacing4),
          decoration: BoxDecoration(
            color: DesignTokens.neutral0,
            borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
            boxShadow: DesignTokens.shadowMd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Text('🎯', style: TextStyle(fontSize: 20)),
                  SizedBox(width: DesignTokens.spacing2),
                  Text(
                    '라운딩 옵션',
                    style: TextStyle(
                      fontSize: DesignTokens.fontLg,
                      fontWeight: DesignTokens.fontBold,
                      color: DesignTokens.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: DesignTokens.spacing3),

              // Caddie Option
              _buildOptionToggle(
                title: '캐디 포함',
                subtitle: '캐디 비용 포함 여부',
                value: _includeCaddie,
                onChanged: (value) => setState(() => _includeCaddie = value),
              ),
              const Divider(height: DesignTokens.spacing3),

              // Cart Option
              _buildOptionToggle(
                title: '카트 포함',
                subtitle: '카트 이용 포함 여부',
                value: _includeCart,
                onChanged: (value) => setState(() => _includeCart = value),
              ),
              const Divider(height: DesignTokens.spacing3),

              // Meal Option
              _buildOptionToggle(
                title: '식사 포함',
                subtitle: '라운딩 후 식사 제공',
                value: _includeMeal,
                onChanged: (value) => setState(() => _includeMeal = value),
              ),

              // Meal Type Selection (if meal is included)
              if (_includeMeal) ...[
                const SizedBox(height: DesignTokens.spacing3),
                Container(
                  padding: const EdgeInsets.all(DesignTokens.spacing3),
                  decoration: BoxDecoration(
                    color: DesignTokens.neutral50,
                    borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '식사 종류',
                        style: TextStyle(
                          fontSize: DesignTokens.fontXs,
                          fontWeight: DesignTokens.fontSemibold,
                          color: DesignTokens.textPrimary,
                        ),
                      ),
                      const SizedBox(height: DesignTokens.spacing2),
                      Wrap(
                        spacing: DesignTokens.spacing2,
                        children: [
                          _buildMealTypeChip('조식', 'breakfast'),
                          _buildMealTypeChip('중식', 'lunch'),
                          _buildMealTypeChip('석식', 'dinner'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms, delay: 150.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildOptionToggle({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: DesignTokens.fontSm,
                  fontWeight: DesignTokens.fontSemibold,
                  color: DesignTokens.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: DesignTokens.fontXs,
                  color: DesignTokens.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: DesignTokens.primary600,
        ),
      ],
    );
  }

  Widget _buildMealTypeChip(String label, String value) {
    final isSelected = _mealType == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _mealType = selected ? value : null;
        });
      },
      selectedColor: DesignTokens.primary100,
      labelStyle: TextStyle(
        fontSize: DesignTokens.fontXs,
        color: isSelected
            ? DesignTokens.primary600
            : DesignTokens.textSecondary,
        fontWeight: isSelected
            ? DesignTokens.fontSemibold
            : DesignTokens.fontNormal,
      ),
    );
  }

  Widget _buildTeamAssignmentSection() {
    return Container(
          padding: const EdgeInsets.all(DesignTokens.spacing4),
          decoration: BoxDecoration(
            color: DesignTokens.neutral0,
            borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
            boxShadow: DesignTokens.shadowMd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Text('👥', style: TextStyle(fontSize: 20)),
                  SizedBox(width: DesignTokens.spacing2),
                  Text(
                    '팀 배정 설정',
                    style: TextStyle(
                      fontSize: DesignTokens.fontLg,
                      fontWeight: DesignTokens.fontBold,
                      color: DesignTokens.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: DesignTokens.spacing4),

              _buildAssignmentOption(
                value: 'auto',
                title: '자동 배정 (추천)',
                subtitle: 'AI가 실력과 친분도를 고려하여 최적 팀 구성',
                icon: '🤖',
              ),
              const SizedBox(height: DesignTokens.spacing2),
              _buildAssignmentOption(
                value: 'manual',
                title: '수동 배정',
                subtitle: '관리자가 직접 팀을 구성',
                icon: '✋',
              ),
              const SizedBox(height: DesignTokens.spacing2),
              _buildAssignmentOption(
                value: 'random',
                title: '랜덤 배정',
                subtitle: '완전 무작위로 팀 배정',
                icon: '🎲',
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms, delay: 200.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildAssignmentOption({
    required String value,
    required String title,
    required String subtitle,
    required String icon,
  }) {
    final isSelected = _teamAssignmentMethod == value;

    return InkWell(
      onTap: () => setState(() => _teamAssignmentMethod = value),
      borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
      child: Container(
        padding: const EdgeInsets.all(DesignTokens.spacing3),
        decoration: BoxDecoration(
          color: isSelected ? DesignTokens.primary50 : DesignTokens.neutral50,
          borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
          border: Border.all(
            color: isSelected
                ? DesignTokens.primary600
                : DesignTokens.neutral200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? DesignTokens.primary600
                      : DesignTokens.neutral300,
                  width: 2,
                ),
                color: isSelected
                    ? DesignTokens.primary600
                    : Colors.transparent,
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(
                        Icons.circle,
                        size: 10,
                        color: DesignTokens.neutral0,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: DesignTokens.spacing3),
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: DesignTokens.spacing2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: DesignTokens.fontSm,
                      fontWeight: DesignTokens.fontSemibold,
                      color: isSelected
                          ? DesignTokens.primary600
                          : DesignTokens.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: DesignTokens.fontXs,
                      color: DesignTokens.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureSettingsSection() {
    return Container(
          padding: const EdgeInsets.all(DesignTokens.spacing4),
          decoration: BoxDecoration(
            color: DesignTokens.neutral0,
            borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
            boxShadow: DesignTokens.shadowMd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Text('⚙️', style: TextStyle(fontSize: 20)),
                  SizedBox(width: DesignTokens.spacing2),
                  Text(
                    '기능 설정',
                    style: TextStyle(
                      fontSize: DesignTokens.fontLg,
                      fontWeight: DesignTokens.fontBold,
                      color: DesignTokens.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: DesignTokens.spacing3),

              _buildFeatureToggle(
                title: 'QR 코드 체크인',
                value: _enableQRCheckin,
                onChanged: (value) => setState(() => _enableQRCheckin = value),
              ),
              const Divider(height: DesignTokens.spacing3),
              _buildFeatureToggle(
                title: '라이브 스코어 + 중계 모드',
                value: _enableLiveScore,
                onChanged: (value) => setState(() => _enableLiveScore = value),
              ),
              const Divider(height: DesignTokens.spacing3),
              _buildFeatureToggle(
                title: '자동 리포트 생성',
                value: _enableAutoReport,
                onChanged: (value) => setState(() => _enableAutoReport = value),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms, delay: 250.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildFeatureToggle({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: DesignTokens.fontSm,
            color: DesignTokens.textPrimary,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: DesignTokens.primary600,
        ),
      ],
    );
  }

  Widget _buildCreateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveRounding,
        style: ElevatedButton.styleFrom(
          backgroundColor: DesignTokens.primary600,
          padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacing4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
          ),
          elevation: 0,
        ),
        child: const Text(
          '✅ 라운딩 생성 완료',
          style: TextStyle(
            fontSize: DesignTokens.fontBase,
            fontWeight: DesignTokens.fontSemibold,
            color: DesignTokens.neutral0,
          ),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 300.ms);
  }
}
