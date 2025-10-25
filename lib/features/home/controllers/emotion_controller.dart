import '../models/emotion_model.dart';
import '../../../core/services/storage_service.dart';

class EmotionController {
  final Map<String, int> _emotionCounts = {};
  final Map<String, List<EmotionRecord>> _emotionHistory = {};
  bool _isInitialized = false;
  
  // 초기화 메소드
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    final savedCounts = await StorageService.loadEmotionCounts();
    final savedHistory = await StorageService.loadEmotionHistory();
    
    _emotionCounts.clear();
    _emotionCounts.addAll(savedCounts);
    
    _emotionHistory.clear();
    _emotionHistory.addAll(savedHistory);
    
    _isInitialized = true;
  }
  
  // 감정 클릭 수 가져오기
  int getEmotionCount(String emoji) {
    return _emotionCounts[emoji] ?? 0;
  }
  
  // 감정 클릭하기
  Future<void> tapEmotion(String emoji) async {
    final currentCount = _emotionCounts[emoji] ?? 0;
    _emotionCounts[emoji] = currentCount + 1;
    
    // 날짜별 기록 저장
    final today = DateTime.now();
    final todayKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    
    if (_emotionHistory[todayKey] == null) {
      _emotionHistory[todayKey] = [];
    }
    
    // 기존 기록 찾기
    final existingRecordIndex = _emotionHistory[todayKey]!
        .indexWhere((record) => record.emotionEmoji == emoji);
    
    if (existingRecordIndex != -1) {
      // 기존 기록 업데이트
      final existingRecord = _emotionHistory[todayKey]![existingRecordIndex];
      _emotionHistory[todayKey]![existingRecordIndex] = EmotionRecord(
        emotionEmoji: emoji,
        date: existingRecord.date,
        count: existingRecord.count + 1,
      );
    } else {
      // 새 기록 추가
      _emotionHistory[todayKey]!.add(EmotionRecord(
        emotionEmoji: emoji,
        date: today,
        count: 1,
      ));
    }
    
    // 데이터 저장
    await _saveData();
  }
  
  // 데이터 저장 메소드
  Future<void> _saveData() async {
    await StorageService.saveEmotionCounts(_emotionCounts);
    await StorageService.saveEmotionHistory(_emotionHistory);
  }
  
  // Opacity 값 계산 (0.3 ~ 1.0)
  double getOpacity(String emoji) {
    final count = getEmotionCount(emoji);
    const minOpacity = 0.3;
    const maxOpacity = 1.0;
    const maxCount = 100;
    
    final progress = (count / maxCount).clamp(0.0, 1.0);
    return minOpacity + (maxOpacity - minOpacity) * progress;
  }
  
  // Shadow 크기 계산
  double getShadowBlurRadius(String emoji) {
    final count = getEmotionCount(emoji);
    const minBlur = 0.0;
    const maxBlur = 12.0;
    const maxCount = 100;
    
    final progress = (count / maxCount).clamp(0.0, 1.0);
    return minBlur + (maxBlur - minBlur) * progress;
  }
  
  // Drop Shadow 여부 확인
  bool hasDropShadow(String emoji) {
    return getEmotionCount(emoji) >= 100;
  }
  
  // 날짜별 감정 기록 가져오기
  List<EmotionRecord> getEmotionRecordsByDate(DateTime date) {
    final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return _emotionHistory[dateKey] ?? [];
  }
  
  // 전체 감정 기록 가져오기
  Map<String, List<EmotionRecord>> getAllEmotionHistory() {
    return Map.from(_emotionHistory);
  }
  
  // 특정 기간의 감정 통계 가져오기
  Map<String, int> getEmotionStatsByDateRange(DateTime startDate, DateTime endDate) {
    final Map<String, int> stats = {};
    
    for (var date = startDate; date.isBefore(endDate.add(const Duration(days: 1))); date = date.add(const Duration(days: 1))) {
      final records = getEmotionRecordsByDate(date);
      for (var record in records) {
        stats[record.emotionEmoji] = (stats[record.emotionEmoji] ?? 0) + record.count;
      }
    }
    
    return stats;
  }
  
  // 오늘의 총 감정 클릭 수
  int getTotalTodayClicks() {
    final today = DateTime.now();
    final todayRecords = getEmotionRecordsByDate(today);
    return todayRecords.fold<int>(0, (sum, record) => sum + record.count);
  }
  
  // 가장 많이 클릭된 감정
  String? getMostClickedEmotion() {
    if (_emotionCounts.isEmpty) return null;
    
    var maxCount = 0;
    String? mostClicked;
    
    _emotionCounts.forEach((emoji, count) {
      if (count > maxCount) {
        maxCount = count;
        mostClicked = emoji;
      }
    });
    
    return mostClicked;
  }
}