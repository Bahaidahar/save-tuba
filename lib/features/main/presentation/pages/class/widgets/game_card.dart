import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../domain/models/class_models.dart';

class GameCard extends StatelessWidget {
  final GameMeta game;
  final String title;
  final bool isMastery;
  final VoidCallback onTap;

  const GameCard({
    super.key,
    required this.game,
    required this.title,
    required this.onTap,
    this.isMastery = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isMastery
              ? const Color.fromRGBO(116, 136, 21, 1).withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: isMastery
              ? Border.all(
                  color: const Color.fromRGBO(116, 136, 21, 1),
                  width: 2.w,
                )
              : null,
        ),
        child: Row(
          children: [
            // Game Icon
            Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: isMastery
                    ? const Color.fromRGBO(116, 136, 21, 1)
                    : Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  _getGameIcon(game.type),
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
            ),

            SizedBox(width: 16.w),

            // Game Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    _getGameTypeName(game.type),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  if (game.score > 0)
                    Text(
                      'Счет: ${game.score.toInt()}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                ],
              ),
            ),

            // Play Button
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getGameIcon(GameType type) {
    switch (type) {
      case GameType.openAnswer:
        return Icons.edit_note; // Улучшенная иконка для записи
      case GameType.knowledgeCheck:
        return Icons.psychology; // Мозг для проверки знаний
      case GameType.photo:
        return Icons.photo_camera; // Камера для фото
      case GameType.grouping:
        return Icons.group_work; // Групповая работа
      case GameType.quiz:
        return Icons.quiz_outlined; // Викторина
      case GameType.ordering:
        return Icons.reorder; // Переупорядочивание
      case GameType.mastery:
        return Icons.emoji_events; // Трофей для мастерства
    }
  }

  String _getGameTypeName(GameType type) {
    switch (type) {
      case GameType.openAnswer:
        return 'Открытый ответ';
      case GameType.knowledgeCheck:
        return 'Проверка знаний';
      case GameType.photo:
        return 'Сделай снимок';
      case GameType.grouping:
        return 'Группировка';
      case GameType.quiz:
        return 'Викторина';
      case GameType.ordering:
        return 'Расстановка по порядку';
      case GameType.mastery:
        return 'Мастерство';
    }
  }
}
