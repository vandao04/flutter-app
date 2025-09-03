import 'package:flutter/material.dart';
import 'dart:ui';

class FullScreenLoadingOverlay extends StatelessWidget {
  final Color? backgroundColor;
  final Color? loadingColor;
  final String? message;
  final bool blur;

  const FullScreenLoadingOverlay({
    super.key,
    this.backgroundColor,
    this.loadingColor,
    this.message,
    this.blur = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background overlay
        blur 
          ? BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                color: backgroundColor ?? Colors.black.withOpacity(0.3),
              ),
            )
          : Container(
              color: backgroundColor ?? Colors.black.withOpacity(0.3),
            ),
        
        // Loading indicator
        Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.symmetric(horizontal: 32),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: loadingColor ?? Theme.of(context).colorScheme.primary,
                ),
                if (message != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    message!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
