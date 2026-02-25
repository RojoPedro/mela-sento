import 'package:flutter/material.dart';
import '../core/theme.dart';

class BalanceHeader extends StatelessWidget {
  final double balance;
  final double frozenCredits;

  const BalanceHeader({
    super.key,
    required this.balance,
    required this.frozenCredits,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AVAILABLE BALANCE',
            style: textTheme.labelSmall?.copyWith(
              color: AppColors.electricCyan.withOpacity(0.7),
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                balance.toInt().toString(),
                style: textTheme.displayLarge?.copyWith(
                  fontSize: 56,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -2,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'CREDITI',
                style: textTheme.labelLarge?.copyWith(
                  fontSize: 18,
                  color: AppColors.electricCyan,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock_clock_outlined,
                  size: 14,
                  color: AppColors.accentOrange,
                ),
                const SizedBox(width: 8),
                Text(
                  '${frozenCredits.toInt()} crediti "congelati" in scommesse aperte',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
