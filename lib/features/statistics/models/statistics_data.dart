import 'dart:math';

class EmotionData {
  final DateTime date;
  final String emoji;
  final int count;
  final String name;

  EmotionData({
    required this.date,
    required this.emoji,
    required this.count,
    required this.name,
  });
}

class StatisticsData {
  static const Map<String, String> emotionMap = {
    '😊': '행복',
    '😍': '사랑',
    '🤗': '흥미',
    '😐': '평범',
    '🤔': '생각',
    '😌': '평온',
    '😢': '슬픔',
    '😡': '화남',
    '😰': '불안',
  };

  static List<EmotionData> generateDummyData() {
    final List<EmotionData> data = [];
    final random = Random();
    
    // 현실적인 감정 패턴 정의
    final weekdayEmotions = ['😊', '🤔', '😐', '😌']; // 평일에 많이 나타나는 감정
    final weekendEmotions = ['😍', '🤗', '😊', '😌']; // 주말에 많이 나타나는 감정
    final stressfulEmotions = ['😰', '😡', '😢']; // 스트레스 받는 날의 감정
    
    // 10월 데이터 생성 (더 현실적인 패턴)
    for (int day = 1; day <= 31; day++) {
      final date = DateTime(2024, 10, day);
      final weekday = date.weekday;
      
      // 주말 vs 평일에 따른 감정 패턴
      final isWeekend = weekday == 6 || weekday == 7;
      final primaryEmotions = isWeekend ? weekendEmotions : weekdayEmotions;
      
      // 각 날짜에 1-3개의 감정 (더 현실적)
      final emotionCount = random.nextInt(3) + 1;
      
      for (int i = 0; i < emotionCount; i++) {
        String emoji;
        int count;
        
        if (random.nextDouble() < 0.8) {
          // 80% 확률로 일반적인 감정
          emoji = primaryEmotions[random.nextInt(primaryEmotions.length)];
          count = random.nextInt(5) + 1; // 1-5회
        } else {
          // 20% 확률로 스트레스 감정
          emoji = stressfulEmotions[random.nextInt(stressfulEmotions.length)];
          count = random.nextInt(3) + 1; // 1-3회
        }
        
        // 특별한 날 패턴 (예: 1일, 15일, 31일에 더 긍정적)
        if (day == 1 || day == 15 || day == 31) {
          emoji = ['😊', '😍', '🤗'][random.nextInt(3)];
          count = random.nextInt(8) + 3; // 3-10회
        }
        
        data.add(EmotionData(
          date: date,
          emoji: emoji,
          count: count,
          name: emotionMap[emoji]!,
        ));
      }
    }
    
    // 9월 데이터 생성 (비슷한 패턴)
    for (int day = 1; day <= 30; day++) {
      final date = DateTime(2024, 9, day);
      final weekday = date.weekday;
      
      final isWeekend = weekday == 6 || weekday == 7;
      final primaryEmotions = isWeekend ? weekendEmotions : weekdayEmotions;
      
      final emotionCount = random.nextInt(3) + 1;
      
      for (int i = 0; i < emotionCount; i++) {
        String emoji;
        int count;
        
        if (random.nextDouble() < 0.75) {
          emoji = primaryEmotions[random.nextInt(primaryEmotions.length)];
          count = random.nextInt(4) + 1; // 1-4회
        } else {
          emoji = stressfulEmotions[random.nextInt(stressfulEmotions.length)];
          count = random.nextInt(2) + 1; // 1-2회
        }
        
        // 9월 개학 시즌 스트레스 반영
        if (day >= 1 && day <= 7) {
          if (random.nextDouble() < 0.3) {
            emoji = '😰';
            count = random.nextInt(4) + 2; // 2-5회
          }
        }
        
        data.add(EmotionData(
          date: date,
          emoji: emoji,
          count: count,
          name: emotionMap[emoji]!,
        ));
      }
    }
    
    return data;
  }
  
  static List<EmotionData> getDataForMonth(int year, int month) {
    final allData = generateDummyData();
    return allData.where((data) => 
      data.date.year == year && data.date.month == month
    ).toList();
  }
}