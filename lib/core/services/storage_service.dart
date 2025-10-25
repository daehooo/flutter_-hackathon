import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/home/models/emotion_model.dart';

class StorageService {
  static const String _emotionCountsKey = 'emotion_counts';
  static const String _emotionHistoryKey = 'emotion_history';
  
  static Future<void> saveEmotionCounts(Map<String, int> emotionCounts) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(emotionCounts);
    await prefs.setString(_emotionCountsKey, jsonString);
  }
  
  static Future<Map<String, int>> loadEmotionCounts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_emotionCountsKey);
    
    if (jsonString == null) {
      return {};
    }
    
    final Map<String, dynamic> decoded = jsonDecode(jsonString);
    return decoded.map((key, value) => MapEntry(key, value as int));
  }
  
  static Future<void> saveEmotionHistory(Map<String, List<EmotionRecord>> history) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Convert to JSON-serializable format
    final Map<String, List<Map<String, dynamic>>> jsonHistory = {};
    
    history.forEach((date, records) {
      jsonHistory[date] = records.map((record) => {
        'emotionEmoji': record.emotionEmoji,
        'date': record.date.millisecondsSinceEpoch,
        'count': record.count,
      }).toList();
    });
    
    final jsonString = jsonEncode(jsonHistory);
    await prefs.setString(_emotionHistoryKey, jsonString);
  }
  
  static Future<Map<String, List<EmotionRecord>>> loadEmotionHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_emotionHistoryKey);
    
    if (jsonString == null) {
      return {};
    }
    
    final Map<String, dynamic> decoded = jsonDecode(jsonString);
    final Map<String, List<EmotionRecord>> history = {};
    
    decoded.forEach((date, recordsJson) {
      final List<dynamic> recordsList = recordsJson as List<dynamic>;
      history[date] = recordsList.map((recordJson) {
        final Map<String, dynamic> recordMap = recordJson as Map<String, dynamic>;
        return EmotionRecord(
          emotionEmoji: recordMap['emotionEmoji'] as String,
          date: DateTime.fromMillisecondsSinceEpoch(recordMap['date'] as int),
          count: recordMap['count'] as int,
        );
      }).toList();
    });
    
    return history;
  }
}