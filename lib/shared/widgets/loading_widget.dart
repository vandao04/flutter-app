import 'package:flutter/material.dart';

class AppLoadingWidget extends StatelessWidget {
  final String? message;
  final double size;
  final Color? color;
  final bool showMessage;

  const AppLoadingWidget({
    super.key,
    this.message,
    this.size = 40.0,
    this.color,
    this.showMessage = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultColor = color ?? theme.colorScheme.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: 3.0,
            valueColor: AlwaysStoppedAnimation<Color>(defaultColor),
          ),
        ),
        if (showMessage && message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

class ShimmerLoadingWidget extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;

  const ShimmerLoadingWidget({
    super.key,
    this.height = 20.0,
    this.width = double.infinity,
    this.borderRadius = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class ListLoadingWidget extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final EdgeInsets? padding;

  const ListLoadingWidget({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 80.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              ShimmerLoadingWidget(
                height: itemHeight,
                width: itemHeight,
                borderRadius: 8,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerLoadingWidget(height: 16, width: double.infinity),
                    const SizedBox(height: 8),
                    ShimmerLoadingWidget(height: 14, width: 200),
                    const SizedBox(height: 8),
                    ShimmerLoadingWidget(height: 14, width: 150),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CardLoadingWidget extends StatelessWidget {
  final double height;
  final EdgeInsets? padding;

  const CardLoadingWidget({
    super.key,
    this.height = 120.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding ?? const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerLoadingWidget(height: 20, width: 150),
          const SizedBox(height: 12),
          ShimmerLoadingWidget(height: 16, width: double.infinity),
          const SizedBox(height: 8),
          ShimmerLoadingWidget(height: 16, width: 200),
          const SizedBox(height: 16),
          Row(
            children: [
              ShimmerLoadingWidget(height: 32, width: 80),
              const SizedBox(width: 12),
              ShimmerLoadingWidget(height: 32, width: 80),
            ],
          ),
        ],
      ),
    );
  }
}

class FullScreenLoadingWidget extends StatelessWidget {
  final String? message;
  final Color? backgroundColor;

  const FullScreenLoadingWidget({
    super.key,
    this.message,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Colors.black54,
      child: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: AppLoadingWidget(
              message: message ?? 'Đang tải...',
              size: 48,
            ),
          ),
        ),
      ),
    );
  }
}
