import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/localization/app_localizations.dart';

class EducationTermsSlider extends StatefulWidget {
  const EducationTermsSlider({super.key});

  @override
  State<EducationTermsSlider> createState() => _EducationTermsSliderState();
}

class _EducationTermsSliderState extends State<EducationTermsSlider>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  List<List<Map<String, dynamic>>> getRows(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return [
      // Row 1 - moves right
      [
        {'text': l10n.education, 'isHighlighted': true},
        {'text': l10n.schooling, 'isHighlighted': false},
        {'text': l10n.instruction, 'isHighlighted': false},
        {'text': l10n.teaching, 'isHighlighted': true},
        {'text': l10n.curriculum, 'isHighlighted': false},
        {'text': l10n.learning, 'isHighlighted': false},
      ],
      // Row 2 - moves left
      [
        {'text': l10n.teaching, 'isHighlighted': false},
        {'text': l10n.curriculum, 'isHighlighted': true},
        {'text': l10n.learning, 'isHighlighted': false},
        {'text': l10n.education, 'isHighlighted': false},
        {'text': l10n.schooling, 'isHighlighted': false},
        {'text': l10n.instruction, 'isHighlighted': false},
      ],
      // Row 3 - moves right
      [
        {'text': l10n.learning, 'isHighlighted': false},
        {'text': l10n.education, 'isHighlighted': true},
        {'text': l10n.teaching, 'isHighlighted': false},
        {'text': l10n.curriculum, 'isHighlighted': false},
        {'text': l10n.schooling, 'isHighlighted': false},
        {'text': l10n.instruction, 'isHighlighted': true},
      ],
      // Row 4 - moves left
      [
        {'text': l10n.schooling, 'isHighlighted': false},
        {'text': l10n.learning, 'isHighlighted': false},
        {'text': l10n.instruction, 'isHighlighted': false},
        {'text': l10n.teaching, 'isHighlighted': true},
        {'text': l10n.education, 'isHighlighted': false},
        {'text': l10n.curriculum, 'isHighlighted': false},
      ],
    ];
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildOptimizedTerm(Map<String, dynamic> term) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: term['isHighlighted']
            ? Border.all(
                color: const Color.fromRGBO(200, 220, 60, 1), width: 1.5)
            : null,
      ),
      child: Text(
        term['text'],
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: term['isHighlighted'] ? Colors.black87 : Colors.grey[700],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rows = getRows(context);
    return Stack(
      children: List.generate(4, (rowIndex) {
        final rowTerms = rows[rowIndex];
        final isMovingRight = rowIndex % 2 == 0;

        return Positioned(
          top: 100.0 + (rowIndex * 85.0),
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _slideAnimation,
              builder: (context, child) {
                final screenWidth = MediaQuery.of(context).size.width;
                final termWidth = 100.0;
                final totalWidth = rowTerms.length * termWidth;

                // Optimized offset calculation
                double offset;
                if (isMovingRight) {
                  offset =
                      (_slideAnimation.value * (totalWidth + screenWidth)) -
                          totalWidth;
                } else {
                  offset = screenWidth -
                      (_slideAnimation.value * (totalWidth + screenWidth));
                }

                return Transform.translate(
                  offset: Offset(offset, 0),
                  child: Row(
                    children: List.generate(rowTerms.length * 2, (termIndex) {
                      final term = rowTerms[termIndex % rowTerms.length];
                      return _buildOptimizedTerm(term);
                    }),
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
