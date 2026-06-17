import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthlive/core/di/providers.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('我的')),
      body: ListView(
        children: [
          const SizedBox(height: 12),
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person_outline)),
            title: const Text('健康生活用户'),
            subtitle: Text(config.useMockData ? '当前：Mock 数据模式' : '当前：API 模式'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('关于 HealthLive'),
            subtitle: const Text('探索作息、运动与饮食带来的好处'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'HealthLive',
                applicationVersion: '1.0.0',
                children: const [
                  Text('生活向健康科普客户端，帮助你建立更好的日常习惯'),
                ],
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('环境信息'),
            subtitle: Text('ENV: ${config.env} · API: ${config.apiBaseUrl}'),
          ),
          ListTile(
            leading: const Icon(Icons.login_outlined),
            title: const Text('登录（预留）'),
            subtitle: const Text('账号体系将在后端 Auth 接口就绪后接入'),
            enabled: false,
          ),
        ],
      ),
    );
  }
}
