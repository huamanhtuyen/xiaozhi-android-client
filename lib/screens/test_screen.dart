import 'package:flutter/material.dart';
import 'package:ai_assistant/providers/config_provider.dart';
import 'package:ai_assistant/services/dify_service.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math' as math;

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  TestScreenState createState() => TestScreenState();
}

class TestScreenState extends State<TestScreen> {
  final _logs = <String>[];
  bool _isTesting = false;
  final ScrollController _scrollController = ScrollController();
  static const String _conversationMapKey = 'dify_conversation_map';

  void _addLog(String log) {
    setState(() {
      _logs.add('${DateTime.now().toString().substring(11, 19)}: $log');
      // Giới hạn số dòng log
      if (_logs.length > 100) {
        _logs.removeRange(0, _logs.length - 100);
      }
    });

    // 滚动到底部
    Future.delayed(const Duration(milliseconds: 10), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _testConsistentSession() async {
    final config = Provider.of<ConfigProvider>(context, listen: false);

    if (config.difyConfig == null) {
      _addLog('Lỗi: Cấu hình Dify API chưa được thiết lập!');
      return;
    }

    setState(() {
      _isTesting = true;
      _logs.clear();
    });

    _addLog('Bắt đầu kiểm tra tính nhất quán phiên...');

    try {
      // Tạo một ID phiên kiểm tra
      final sessionId = const Uuid().v4();
      _addLog('Sử dụng ID phiên: $sessionId');

      final difyService = await DifyService.create(
        apiKey: config.difyConfig!.apiKey,
        apiUrl: config.difyConfig!.apiUrl,
      );

      // Gửi tin nhắn đầu tiên
      _addLog('Gửi tin nhắn đầu tiên');
      final response1 = await difyService.sendMessage(
        'Đây là tin nhắn kiểm tra 1',
        sessionId: sessionId,
      );
      _addLog(
        'Nhận phản hồi: ${response1.substring(0, math.min(20, response1.length))}...',
      );
      await _printCurrentSessions();

      // Chờ một giây
      await Future.delayed(const Duration(seconds: 1));

      // Gửi tin nhắn thứ hai
      _addLog('Gửi tin nhắn thứ hai');
      final response2 = await difyService.sendMessage(
        'Đây là tin nhắn kiểm tra 2',
        sessionId: sessionId,
      );
      _addLog(
        'Nhận phản hồi: ${response2.substring(0, math.min(20, response2.length))}...',
      );
      await _printCurrentSessions();

      // Chờ một giây
      await Future.delayed(const Duration(seconds: 1));

      // Gửi tin nhắn thứ ba
      _addLog('Gửi tin nhắn thứ ba');
      final response3 = await difyService.sendMessage(
        'Đây là tin nhắn kiểm tra 3',
        sessionId: sessionId,
      );
      _addLog(
        'Nhận phản hồi: ${response3.substring(0, math.min(20, response3.length))}...',
      );

      // In kết quả
      await _printCurrentSessions();

      _addLog('Kiểm tra hoàn thành');
    } catch (e) {
      _addLog('Kiểm tra thất bại: $e');
    } finally {
      setState(() {
        _isTesting = false;
      });
    }
  }

  Future<void> _testResetSession() async {
    final config = Provider.of<ConfigProvider>(context, listen: false);

    if (config.difyConfig == null) {
      _addLog('错误: Dify API配置未设置!');
      return;
    }

    setState(() {
      _isTesting = true;
      _logs.clear();
    });

    _addLog('Bắt đầu kiểm tra đặt lại phiên...');

    try {
      // Tạo một ID phiên kiểm tra
      final sessionId = const Uuid().v4();
      _addLog('Sử dụng ID phiên: $sessionId');

      final difyService = await DifyService.create(
        apiKey: config.difyConfig!.apiKey,
        apiUrl: config.difyConfig!.apiUrl,
      );

      // Gửi tin nhắn trước khi đặt lại
      _addLog('Gửi tin nhắn trước khi đặt lại');
      final response1 = await difyService.sendMessage(
        'Đây là tin nhắn trước khi đặt lại',
        sessionId: sessionId,
      );
      _addLog(
        'Nhận phản hồi: ${response1.substring(0, math.min(20, response1.length))}...',
      );

      // In ID phiên hiện tại
      await _printCurrentSessions();

      // Đặt lại phiên
      _addLog('Đặt lại phiên');
      await difyService.clearConversation(sessionId);

      // In ID phiên sau khi đặt lại
      await _printCurrentSessions();

      // Gửi tin nhắn sau khi đặt lại
      _addLog('Gửi tin nhắn sau khi đặt lại');
      final response2 = await difyService.sendMessage(
        'Đây là tin nhắn sau khi đặt lại',
        sessionId: sessionId,
      );
      _addLog(
        'Nhận phản hồi: ${response2.substring(0, math.min(20, response2.length))}...',
      );

      // In ID phiên cuối cùng
      await _printCurrentSessions();

      _addLog('Kiểm tra hoàn thành');
    } catch (e) {
      _addLog('Kiểm tra thất bại: $e');
    } finally {
      setState(() {
        _isTesting = false;
      });
    }
  }

  Future<void> _printStoredSessions() async {
    setState(() {
      _isTesting = true;
      _logs.clear();
    });

    _addLog('Lấy ID phiên đã lưu...');

    try {
      await _printCurrentSessions();
      _addLog('Hoàn thành');
    } catch (e) {
      _addLog('Thất bại: $e');
    } finally {
      setState(() {
        _isTesting = false;
      });
    }
  }

  Future<void> _printCurrentSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final mapJson = prefs.getString(_conversationMapKey);
    if (mapJson == null || mapJson.isEmpty) {
      _addLog('没有存储的会话ID');
      return;
    }

    final Map<String, dynamic> loadedMap = jsonDecode(mapJson);
    _addLog('ID phiên đã lưu:');
    loadedMap.forEach((sessionId, conversationId) {
      _addLog('- Phiên: $sessionId => ID cuộc trò chuyện: $conversationId');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kiểm tra ID phiên Dify'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed:
                _logs.isEmpty ? null : () => setState(() => _logs.clear()),
            tooltip: 'Xóa log',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isTesting ? null : _testConsistentSession,
                    child: const Text('Kiểm tra tính nhất quán phiên'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isTesting ? null : _testResetSession,
                    child: const Text('Kiểm tra đặt lại phiên'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isTesting ? null : _printStoredSessions,
                    child: const Text('Xem phiên đã lưu'),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(child: _buildLogView()),
        ],
      ),
    );
  }

  Widget _buildLogView() {
    if (_logs.isEmpty) {
      return const Center(
        child: Text('Không có log, chạy kiểm tra để xem kết quả.'),
      );
    }

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _logs.length,
            itemBuilder: (context, index) {
              return Text(
                _logs[index],
                style: TextStyle(
                  fontFamily: 'monospace',
                  color: _getLogColor(_logs[index]),
                ),
              );
            },
          ),
        ),
        if (_isTesting)
          const Positioned.fill(
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  Color _getLogColor(String log) {
    if (log.contains('Lỗi') || log.contains('Thất bại')) {
      return Colors.red;
    } else if (log.contains('Hoàn thành') || log.contains('Thành công')) {
      return Colors.green;
    } else if (log.contains('Phiên') || log.contains('ID cuộc trò chuyện')) {
      return Colors.blue;
    } else {
      return Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    }
  }
}
