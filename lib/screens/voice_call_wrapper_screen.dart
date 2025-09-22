import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_assistant/providers/config_provider.dart';
import 'package:ai_assistant/providers/conversation_provider.dart';
import 'package:ai_assistant/models/conversation.dart';
import 'package:ai_assistant/screens/voice_call_screen.dart';
import 'package:ai_assistant/models/xiaozhi_config.dart';

class VoiceCallWrapperScreen extends StatefulWidget {
  const VoiceCallWrapperScreen({super.key});

  @override
  State<VoiceCallWrapperScreen> createState() => _VoiceCallWrapperScreenState();
}

class _VoiceCallWrapperScreenState extends State<VoiceCallWrapperScreen> {
  @override
  void initState() {
    super.initState();
    // Tự động điều hướng sau khi build xong và đảm bảo ConversationProvider đã load xong
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Thêm delay nhỏ để đảm bảo ConversationProvider đã hoàn tất việc load
      Future.delayed(const Duration(milliseconds: 100), () {
        _navigateToVoiceCall();
      });
    });
  }

  Future<void> _navigateToVoiceCall() async {
    final configProvider = Provider.of<ConfigProvider>(context, listen: false);
    final xiaozhiConfigs = configProvider.xiaozhiConfigs;

    // Nếu chưa có cấu hình, tạo cấu hình mặc định
    if (xiaozhiConfigs.isEmpty) {
      await _createDefaultConfig();
    }

    // Lấy lại danh sách cấu hình sau khi tạo
    final updatedConfigs = configProvider.xiaozhiConfigs;

    if (updatedConfigs.isEmpty) {
      // Nếu vẫn không có cấu hình, hiển thị lỗi
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không thể tạo cấu hình mặc định'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Tạo conversation mới
    final conversationProvider = Provider.of<ConversationProvider>(context, listen: false);
    final conversation = await conversationProvider.createConversation(
      title: 'Cuộc gọi thoại với ${updatedConfigs.first.name}',
      type: ConversationType.xiaozhi,
      configId: updatedConfigs.first.id,
    );

    // Điều hướng đến VoiceCallScreen
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => VoiceCallScreen(
            conversation: conversation,
            xiaozhiConfig: updatedConfigs.first,
          ),
        ),
      );
    }
  }

  Future<void> _createDefaultConfig() async {
    final configProvider = Provider.of<ConfigProvider>(context, listen: false);

    try {
      // Tạo cấu hình mặc định với thông tin được cung cấp
      await configProvider.addXiaozhiConfig(
        'beeng', // Tên cấu hình
        'wss://api.tenclass.net/xiaozhi/v1/', // Địa chỉ WSS
      );

      // Cập nhật cấu hình đầu tiên với thông tin cụ thể
      final defaultConfigs = configProvider.xiaozhiConfigs;
      if (defaultConfigs.isNotEmpty) {
        final defaultConfig = defaultConfigs.first;
        final updatedConfig = XiaozhiConfig(
          id: defaultConfig.id,
          name: 'beeng',
          websocketUrl: 'wss://api.tenclass.net/xiaozhi/v1/',
          macAddress: '0e:8b:9f:1c:5b:e5', // Device ID
          token: 'test-token', // Auth token
        );

        await configProvider.updateXiaozhiConfig(updatedConfig);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã tạo cấu hình mặc định "beeng"'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Lỗi khi tạo cấu hình mặc định: $e');

      // Thử tạo lại cấu hình với thông tin khác nếu có lỗi
      try {
        // Tạo cấu hình với ID cụ thể để tránh xung đột
        final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        final fallbackConfig = XiaozhiConfig(
          id: timestamp,
          name: 'beeng',
          websocketUrl: 'wss://api.tenclass.net/xiaozhi/v1/',
          macAddress: '0e:8b:9f:1c:5b:e5',
          token: 'test-token',
        );

        // Thêm trực tiếp vào danh sách cấu hình
        configProvider.xiaozhiConfigs.add(fallbackConfig);
        // Lưu cấu hình
        await configProvider.saveConfigs();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đã tạo cấu hình mặc định "beeng" (fallback)'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } catch (fallbackError) {
        print('Lỗi khi tạo cấu hình fallback: $fallbackError');

        // Nếu vẫn không tạo được, hiển thị thông báo lỗi và thử lại sau
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Không thể tạo cấu hình mặc định. Thử lại sau...'),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'Thử lại',
                onPressed: () {
                  _navigateToVoiceCall();
                },
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2),
              ),
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Đang khởi động...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}