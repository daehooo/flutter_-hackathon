class Friend {
  final String name;
  final String mostFrequentEmotion;
  final double emotionScore;
  final double x;
  final double y;

  const Friend({
    required this.name,
    required this.mostFrequentEmotion,
    required this.emotionScore,
    required this.x,
    required this.y,
  });

  static List<Friend> dummyFriends = [
    Friend(
      name: '김수현',
      mostFrequentEmotion: '😊',
      emotionScore: 8.7,
      x: 0.15,
      y: 0.25,
    ),
    Friend(
      name: '이민준',
      mostFrequentEmotion: '🤔',
      emotionScore: 6.8,
      x: 0.75,
      y: 0.15,
    ),
    Friend(
      name: '박지은',
      mostFrequentEmotion: '😍',
      emotionScore: 9.2,
      x: 0.45,
      y: 0.55,
    ),
    Friend(
      name: '최현우',
      mostFrequentEmotion: '😌',
      emotionScore: 7.5,
      x: 0.85,
      y: 0.65,
    ),
    Friend(
      name: '정예린',
      mostFrequentEmotion: '😢',
      emotionScore: 4.6,
      x: 0.05,
      y: 0.75,
    ),
    Friend(
      name: '강태준',
      mostFrequentEmotion: '😡',
      emotionScore: 3.9,
      x: 0.65,
      y: 0.35,
    ),
    Friend(
      name: '윤서연',
      mostFrequentEmotion: '😰',
      emotionScore: 5.4,
      x: 0.25,
      y: 0.05,
    ),
    Friend(
      name: '임도현',
      mostFrequentEmotion: '🤗',
      emotionScore: 8.1,
      x: 0.55,
      y: 0.85,
    ),
    Friend(
      name: '한지우',
      mostFrequentEmotion: '😐',
      emotionScore: 6.3,
      x: 0.35,
      y: 0.45,
    ),
    Friend(
      name: '조민서',
      mostFrequentEmotion: '😊',
      emotionScore: 7.9,
      x: 0.95,
      y: 0.25,
    ),
  ];
}