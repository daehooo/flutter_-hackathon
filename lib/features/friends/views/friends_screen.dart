import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/friend_model.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _floatingAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationControllers = [];
    _floatingAnimations = [];

    for (int i = 0; i < Friend.dummyFriends.length; i++) {
      final controller = AnimationController(
        duration: Duration(milliseconds: 1800 + (i * 150)), // 더 다양한 속도
        vsync: this,
      );

      // 각 친구마다 다른 애니메이션 범위
      final animationRange = 8.0 + (i % 3) * 4.0; // 8.0, 12.0, 16.0 범위
      final animation = Tween<double>(
        begin: -animationRange,
        end: animationRange,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: i % 2 == 0 ? Curves.easeInOut : Curves.easeInOutSine, // 다양한 곡선
      ));

      _animationControllers.add(controller);
      _floatingAnimations.add(animation);

      // 시작 시간을 다르게 해서 더 자연스럽게
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) {
          controller.repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Color _getScoreColor(double score) {
    if (score >= 8.5) {
      return const Color(0xFF4CAF50); // 밝은 초록
    } else if (score >= 7.0) {
      return const Color(0xFF8BC34A); // 연한 초록
    } else if (score >= 5.5) {
      return const Color(0xFFFF9800); // 주황
    } else if (score >= 4.0) {
      return const Color(0xFFFF5722); // 진한 주황
    } else {
      return const Color(0xFFF44336); // 빨강
    }
  }
  
  String _getScoreLabel(double score) {
    if (score >= 8.0) {
      return '최고!';
    } else if (score >= 7.0) {
      return '좋음';
    } else if (score >= 5.5) {
      return '보통';
    } else if (score >= 4.0) {
      return '조금 힘듦';
    } else {
      return '힘듦';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('내친구들의 현재 무드'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: Friend.dummyFriends.asMap().entries.map((entry) {
            final index = entry.key;
            final friend = entry.value;
            
            return AnimatedBuilder(
              animation: _floatingAnimations[index],
              builder: (context, child) {
                return Positioned(
                  left: friend.x * (screenSize.width - 120),
                  top: friend.y * (screenSize.height - 200) + _floatingAnimations[index].value,
                  child: _buildFriendItem(friend),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFriendItem(Friend friend) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 말풍선 (감정 라벨 + 점수)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getScoreColor(friend.emotionScore),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                friend.mostFrequentEmotion,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(width: 4),
              Text(
                _getScoreLabel(friend.emotionScore),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        
        // 친구 아바타 원형
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _getScoreColor(friend.emotionScore).withValues(alpha: 0.8),
                _getScoreColor(friend.emotionScore),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: _getScoreColor(friend.emotionScore).withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Text(
              friend.name[0], // 이름의 첫 글자
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        
        // 친구 이름
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Text(
            friend.name.length > 4 ? '${friend.name.substring(0, 4)}...' : friend.name,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}