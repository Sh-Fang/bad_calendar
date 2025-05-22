import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutButton extends StatelessWidget {
  // GitHub Release 页面地址
  final String githubReleaseUrl =
      'https://github.com/Sh-Fang/bad_calendar/releases/latest';

  const AboutButton({super.key});

  Future<void> _launchUrl() async {
    final Uri uri = Uri.parse(githubReleaseUrl);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('无法打开链接: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        HapticFeedback.lightImpact();

        final packageInfo = await PackageInfo.fromPlatform();
        final version = 'v${packageInfo.version}';

        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('关于'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text('当前版本：$version')],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('下载更新'),
                ),
              ],
            );
          },
        );

        if (confirmed == true) {
          _launchUrl();
        }
      },
      icon: const Icon(Icons.info, color: Colors.blue),
      label: const Text('关于'),
    );
  }
}
