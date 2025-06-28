import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final Color? color;
  final bool showRating;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 20,
    this.color,
    this.showRating = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          final starRating = index + 1;
          return Icon(
            starRating <= rating
                ? Icons.star
                : starRating - 0.5 <= rating
                    ? Icons.star_half
                    : Icons.star_border,
            color: color ?? Colors.amber,
            size: size,
          );
        }),
        if (showRating) ...[
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: size * 0.8,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
