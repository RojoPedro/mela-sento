import 'dart:ui';
import 'package:flutter/material.dart';
import 'glass_card.dart';
import 'status_badge.dart';
import '../core/theme.dart';

class BetCard extends StatelessWidget {
  final String? groupName;
  final BetStatus? status;
  final String? timeRemaining;
  final VoidCallback onTap;
  final bool isEmpty;

  const BetCard({
    super.key,
    this.groupName,
    this.status,
    this.timeRemaining,
    required this.onTap,
    this.isEmpty = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
            ),
            child: CustomPaint(
              painter: DashedBorderPainter(color: Colors.white24),
              child: const Center(
                child: Icon(
                  Icons.add_circle_outline_rounded,
                  size: 32,
                  color: Colors.white24,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Hero(
        tag: 'bet_card_$groupName',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            child: GlassCard(
              borderRadius: BorderRadius.circular(24),
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          groupName ?? '',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                        ),
                        if (status == BetStatus.table && timeRemaining != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Time left: $timeRemaining',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.accentYellow,
                                  fontFamily: 'RobotoMono',
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (status != null && status != BetStatus.none)
                    StatusBadge(status: status!),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;

  DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(30),
      ));

    final dashWidth = 8.0;
    final dashSpace = 6.0;

    Path dashPath = Path();
    for (PathMetric pathMetric in path.computeMetrics()) {
      double distance = 0;
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
