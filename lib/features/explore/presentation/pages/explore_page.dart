import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExplorePage extends ConsumerWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Khám phá'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tính năng khám phá đang được phát triển...',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Sẽ bao gồm:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ListTile(
              leading: Icon(Icons.search),
              title: Text('Tìm kiếm nâng cao'),
              subtitle: Text('Tìm kiếm theo danh mục, tags, v.v.'),
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text('Danh mục'),
              subtitle: Text('Phân loại nội dung theo chủ đề'),
            ),
            ListTile(
              leading: Icon(Icons.trending_up),
              title: Text('Xu hướng'),
              subtitle: Text('Nội dung hot và phổ biến'),
            ),
            ListTile(
              leading: Icon(Icons.filter_list),
              title: Text('Bộ lọc'),
              subtitle: Text('Lọc theo tiêu chí cụ thể'),
            ),
          ],
        ),
      ),
    );
  }
}
