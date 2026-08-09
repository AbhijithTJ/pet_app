import 'package:flutter/material.dart';
import 'package:pet_app/theme/app_colors.dart';

class PawLoader extends StatefulWidget {
  final Color color;
  final double size;

  const PawLoader({
    super.key,
    this.color = AppColors.primaryOrange,
    this.size = 30.0,
  });

  @override
  State<PawLoader> createState() => _PawLoaderState();
}

class _PawLoaderState extends State<PawLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        const int count = 3;
        
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(count, (index) {
            double currentIndex = _controller.value * count;
            
            // Calculate distance for the trailing fade effect
            double distance = currentIndex - index;
            if (distance < 0) {
              distance += count; // Wrap around
            }
            
            double opacity = 0.1;
            if (distance <= 1.0) {
              // Just passed: Fade from 1.0 to 0.4
              opacity = 1.0 - (distance * 0.6);
            } else if (distance <= 2.0) {
              // Older: Fade from 0.4 to 0.1
              opacity = 0.4 - ((distance - 1.0) * 0.3);
            } else {
              // Oldest: Stay faded
              opacity = 0.1;
            }
            
            // Alternate vertical position to simulate left/right footsteps
            final yOffset = index.isEven ? 6.0 : -6.0;
            
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Transform.translate(
                offset: Offset(0, yOffset),
                child: Opacity(
                  opacity: opacity,
                  child: Icon(
                    Icons.pets,
                    color: widget.color,
                    size: widget.size,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
