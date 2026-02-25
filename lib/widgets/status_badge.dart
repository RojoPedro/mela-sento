import 'package:flutter/material.dart';
import '../core/theme.dart';

enum BetStatus { none, table, live, ended }

class StatusBadge extends StatelessWidget {
  final BetStatus status;

  const StatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    if (status == BetStatus.none) return const SizedBox.shrink();

    Color color;
    String label;

    switch (status) {
      case BetStatus.table:
        color = AppColors.accentYellow;
        label = 'TABLE';
        break;
      case BetStatus.live:
        color = AppColors.accentBlue;
        label = 'LIVE';
        break;
      case BetStatus.ended:
        color = AppColors.accentOrange;
        label = 'ENDED';
        break;
      default:
        return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
