import 'package:flutter/material.dart';

class NotificationListLoading extends StatelessWidget {
  final bool isLoading;
  
  const NotificationListLoading({
    Key? key,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
          const SizedBox(height: 8),
          Text(
            'Đang tải thêm...',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
