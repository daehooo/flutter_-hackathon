import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

enum EmotionCategory { positive, neutral, negative }

class EmotionModel {
  final String emoji;
  final String name;
  final EmotionCategory category;
  
  const EmotionModel({
    required this.emoji,
    required this.name,
    required this.category,
  });
  
  Color get categoryColor {
    switch (category) {
      case EmotionCategory.positive:
        return AppColors.emotionPositive;
      case EmotionCategory.neutral:
        return AppColors.emotionNeutral;
      case EmotionCategory.negative:
        return AppColors.emotionNegative;
    }
  }
  
  static const List<EmotionModel> emotions = [
    // 좋음 (Positive)
    EmotionModel(
      emoji: '😊',
      name: '행복',
      category: EmotionCategory.positive,
    ),
    EmotionModel(
      emoji: '😍',
      name: '사랑',
      category: EmotionCategory.positive,
    ),
    EmotionModel(
      emoji: '🤩',
      name: '흥미',
      category: EmotionCategory.positive,
    ),
    
    // 보통 (Neutral)
    EmotionModel(
      emoji: '😐',
      name: '평범',
      category: EmotionCategory.neutral,
    ),
    EmotionModel(
      emoji: '🤔',
      name: '생각',
      category: EmotionCategory.neutral,
    ),
    EmotionModel(
      emoji: '😌',
      name: '평온',
      category: EmotionCategory.neutral,
    ),
    
    // 안좋음 (Negative)
    EmotionModel(
      emoji: '😢',
      name: '슬픔',
      category: EmotionCategory.negative,
    ),
    EmotionModel(
      emoji: '😠',
      name: '화남',
      category: EmotionCategory.negative,
    ),
    EmotionModel(
      emoji: '😰',
      name: '불안',
      category: EmotionCategory.negative,
    ),
  ];
}

class EmotionRecord {
  final String emotionEmoji;
  final DateTime date;
  final int count;
  
  EmotionRecord({
    required this.emotionEmoji,
    required this.date,
    required this.count,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'emotionEmoji': emotionEmoji,
      'date': date.toIso8601String(),
      'count': count,
    };
  }
  
  factory EmotionRecord.fromJson(Map<String, dynamic> json) {
    return EmotionRecord(
      emotionEmoji: json['emotionEmoji'],
      date: DateTime.parse(json['date']),
      count: json['count'],
    );
  }
}