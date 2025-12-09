import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LearningVideo {
  final String title;
  final String description;
  final String url;

  const LearningVideo({
    required this.title,
    required this.description,
    required this.url,
  });
}

class LearningPage extends StatelessWidget {
  const LearningPage({super.key});

  final List<LearningVideo> _videos = const [
    LearningVideo(
      title: 'Fat loss basics: energy balance',
      description:
          'Understand calorie deficit, basal metabolic rate, and daily activity.',
      url: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    ),
    LearningVideo(
      title: 'How to balance macros (C/P/F)',
      description:
          'Learn the roles of carbs, protein, and fat and typical ratios.',
      url: 'https://www.youtube.com/',
    ),
    LearningVideo(
      title: 'Making healthier choices when eating out',
      description:
          'Practical tips for choosing relatively healthier options in real life.',
      url: 'https://www.bilibili.com/',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final video = _videos[index];
        return ListTile(
          title: Text(video.title),
          subtitle: Text(video.description),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => LearningVideoDetailPage(video: video),
              ),
            );
          },
        );
      },
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemCount: _videos.length,
    );
  }
}

class LearningVideoDetailPage extends StatelessWidget {
  final LearningVideo video;

  const LearningVideoDetailPage({super.key, required this.video});

  Future<void> _openUrl() async {
    final uri = Uri.parse(video.url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not open link');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(video.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              video.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(
              video.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _openUrl,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Watch video in browser'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
