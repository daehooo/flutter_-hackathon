import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../models/emotion_model.dart';
import '../controllers/emotion_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final EmotionController _emotionController = EmotionController();
  final Map<String, AnimationController> _animationControllers = {};
  final Map<String, Animation<double>> _opacityAnimations = {};
  final Map<String, Animation<double>> _shadowAnimations = {};

  @override
  void initState() {
    super.initState();
    _initializeController();
    for (var emotion in EmotionModel.emotions) {
      _animationControllers[emotion.emoji] = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      );
      
      _opacityAnimations[emotion.emoji] = Tween<double>(
        begin: 0.3,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationControllers[emotion.emoji]!,
        curve: Curves.easeInOut,
      ));
      
      _shadowAnimations[emotion.emoji] = Tween<double>(
        begin: 0.0,
        end: 12.0,
      ).animate(CurvedAnimation(
        parent: _animationControllers[emotion.emoji]!,
        curve: Curves.easeInOut,
      ));
    }
  }
  
  Future<void> _initializeController() async {
    await _emotionController.initialize();
    setState(() {
      // Update animations based on loaded data
      for (var emotion in EmotionModel.emotions) {
        double progress = (_emotionController.getEmotionCount(emotion.emoji) / 100).clamp(0.0, 1.0);
        _animationControllers[emotion.emoji]!.animateTo(progress);
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _animationControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    final weekday = weekdays[now.weekday - 1];
    return '${now.month}월${now.day}일($weekday)';
  }

  void _onEmotionTap(String emoji) async {
    await _emotionController.tapEmotion(emoji);
    
    setState(() {
      double progress = (_emotionController.getEmotionCount(emoji) / 100).clamp(0.0, 1.0);
      _animationControllers[emoji]!.animateTo(progress);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;
    final gridPadding = isSmallScreen ? 12.0 : 20.0;
    final crossAxisSpacing = isSmallScreen ? 12.0 : 16.0;
    final mainAxisSpacing = isSmallScreen ? 12.0 : 16.0;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_getFormattedDate()),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(gridPadding),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  AppStrings.selectEmotionMessage,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Calculate optimal grid dimensions to prevent overflow
                    final availableWidth = constraints.maxWidth;
                    final itemWidth = (availableWidth - (2 * crossAxisSpacing)) / 3;
                    final aspectRatio = itemWidth / (itemWidth * 1.1); // Slightly taller for better text layout
                    
                    return GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: crossAxisSpacing,
                        mainAxisSpacing: mainAxisSpacing,
                        childAspectRatio: aspectRatio,
                      ),
                      itemCount: EmotionModel.emotions.length,
                      itemBuilder: (context, index) {
                        final emotion = EmotionModel.emotions[index];
                        
                        return AnimatedBuilder(
                          animation: Listenable.merge([
                            _opacityAnimations[emotion.emoji]!,
                            _shadowAnimations[emotion.emoji]!,
                          ]),
                          builder: (context, child) {
                            final count = _emotionController.getEmotionCount(emotion.emoji);
                            return GestureDetector(
                              onTap: () => _onEmotionTap(emotion.emoji),
                              child: AnimatedScale(
                                scale: _shadowAnimations[emotion.emoji]!.value > 6 ? 1.05 : 1.0,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeOutBack,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: emotion.categoryColor.withValues(
                                      alpha: _opacityAnimations[emotion.emoji]!.value,
                                    ),
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      if (_shadowAnimations[emotion.emoji]!.value > 0) ...[
                                        BoxShadow(
                                          color: emotion.categoryColor.withValues(alpha: 0.4),
                                          blurRadius: _shadowAnimations[emotion.emoji]!.value,
                                          offset: const Offset(0, 6),
                                          spreadRadius: _shadowAnimations[emotion.emoji]!.value * 0.3,
                                        ),
                                        BoxShadow(
                                          color: emotion.categoryColor.withValues(alpha: 0.2),
                                          blurRadius: _shadowAnimations[emotion.emoji]!.value * 2,
                                          offset: const Offset(0, 12),
                                          spreadRadius: _shadowAnimations[emotion.emoji]!.value * 0.1,
                                        ),
                                      ]
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          flex: 3,
                                          child: FittedBox(
                                            fit: BoxFit.contain,
                                            child: Text(
                                              emotion.emoji,
                                              style: TextStyle(
                                                fontSize: isSmallScreen ? 48 : 56,
                                                height: 1.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Flexible(
                                          flex: 1,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              emotion.name,
                                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.textPrimary,
                                                height: 1.0,
                                              ),
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withValues(alpha: 0.9),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                '$count${AppStrings.clickCount}',
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.textSecondary,
                                                  fontSize: 10,
                                                ),
                                                maxLines: 1,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}