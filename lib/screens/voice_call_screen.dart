import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ai_assistant/models/conversation.dart';
import 'package:ai_assistant/models/message.dart';
import 'package:ai_assistant/models/xiaozhi_config.dart';
import 'package:ai_assistant/providers/conversation_provider.dart';
import 'package:ai_assistant/services/xiaozhi_service.dart';
import 'dart:async';

class VoiceCallScreen extends StatefulWidget {
  final Conversation conversation;
  final XiaozhiConfig xiaozhiConfig;

  const VoiceCallScreen({
    super.key,
    required this.conversation,
    required this.xiaozhiConfig,
  });

  @override
  State<VoiceCallScreen> createState() => _VoiceCallScreenState();
}

class _VoiceCallScreenState extends State<VoiceCallScreen>
    with SingleTickerProviderStateMixin {
  late XiaozhiService _xiaozhiService;
  bool _isConnected = false;
  bool _isSpeaking = false;
  String _statusText = 'Đang kết nối...';
  Timer? _callTimer;
  Duration _callDuration = Duration.zero;
  bool _serverReady = false;
  String _currentText = ''; // Text từ server (TTS, conversation text, etc.)
  String _currentEmotion = ''; // Emotion từ server

  late AnimationController _animationController;
  final List<double> _audioLevels = List.filled(30, 0.05);
  Timer? _audioVisualizerTimer;

  @override
  void initState() {
    super.initState();

    // Đặt thanh trạng thái trong suốt và biểu tượng màu trắng
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );

    // Sau khi vẽ khung, đặt lại kiểu UI hệ thống để tránh bị ghi đè
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
      );
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    // Lấy instance XiaozhiService
    _xiaozhiService = XiaozhiService(
      websocketUrl: widget.xiaozhiConfig.websocketUrl,
      macAddress: widget.xiaozhiConfig.macAddress,
      token: widget.xiaozhiConfig.token,
      sessionId: widget.conversation.id,
    );

    // Thiết lập trình nghe tin nhắn
    _xiaozhiService.setMessageListener(_handleServerMessage);

    // Khởi tạo audio visualizer trước
    _startAudioVisualizer();

    // Kết nối và chuyển sang chế độ gọi thoại
    _connectToVoiceService();
  }

  void _handleServerMessage(dynamic message) {
    // Xử lý tin nhắn từ server
    if (message is Map<String, dynamic>) {
      print('Nhận tin nhắn từ server: $message');

      if (message['type'] == 'hello') {
        print('Nhận tin nhắn hello từ server: $message');
        if (mounted) {
          setState(() {
            _serverReady = true;
          });
        }

        // Sau khi server sẵn sàng, trì hoãn ngắn để tự động bắt đầu ghi âm
        // Điều này đảm bảo ID phiên đã được đặt đúng
        if (_isConnected && !_isSpeaking) {
          // Trì hoãn 1 giây, đảm bảo server và client đã sẵn sàng
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (mounted && _isConnected && !_isSpeaking) {
              print('Chuẩn bị bắt đầu ghi âm...');
              _startSpeaking();
            }
          });
        }
      } else if (message['type'] == 'llm' && message['text'] != null) {
        // Xử lý tin nhắn llm có cả text và emotion
        final String text = message['text'];
        final String? emotion = message['emotion'];
        print('Nhận tin nhắn llm - Text: $text, Emotion: $emotion');
        if (mounted) {
          setState(() {
            _currentText = text;
            if (emotion != null) {
              _currentEmotion = emotion;
            }
          });


          // Tự động xóa emotion sau 3 giây
          if (emotion != null) {
            Future.delayed(const Duration(seconds: 3), () {
              if (mounted) {
                setState(() {
                  _currentEmotion = '';
                });
              }
            });
          }
        }
      } else if (message['type'] == 'tts' && message['text'] != null) {
        // Xử lý tin nhắn TTS với các state khác nhau
        final String state = message['state'] ?? '';
        final String text = message['text'];
        print('Nhận tin nhắn TTS ($state): $text');

        // Chỉ hiển thị text khi state là sentence_start
        if (state == 'sentence_start') {
          if (mounted) {
            setState(() {
              _currentText = text;
            });

          }
        }
      } else if (message['type'] == 'emotion' && message['emotion'] != null) {
        // Xử lý tin nhắn emotion riêng lẻ
        final String emotion = message['emotion'];
        print('Nhận tin nhắn emotion: $emotion');
        if (mounted) {
          setState(() {
            _currentEmotion = emotion;
          });

          // Tự động xóa emotion sau 3 giây
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              setState(() {
                _currentEmotion = '';
              });
            }
          });
        }
      } else if (message['type'] == 'stt' && message['text'] != null) {
        // Xử lý tin nhắn STT (speech-to-text)
        final String text = message['text'];
        print('Nhận tin nhắn STT: $text');
        if (mounted) {
          setState(() {
            _currentText = text;
          });

        }
      }
  }
  }

  @override
  void dispose() {
    // Chuyển về chế độ chat thông thường
    _xiaozhiService.switchToChatMode();
    _callTimer?.cancel();
    _audioVisualizerTimer?.cancel();
    _animationController.dispose();

    // Đảm bảo dừng tất cả phát âm thanh
    _xiaozhiService.stopPlayback();

    super.dispose();
  }

  void _connectToVoiceService() async {
    if (mounted) {
      setState(() {
        _statusText = 'Đang chuẩn bị...';
      });
    }

    try {
      print('VoiceCallScreen: Bắt đầu kết nối voice service...');

      // Kết nối WebSocket trước
      print('VoiceCallScreen: Đang kết nối WebSocket...');
      await _xiaozhiService.connect();
      print('VoiceCallScreen: WebSocket kết nối thành công');

      // Sau đó chuyển sang chế độ gọi thoại
      print('VoiceCallScreen: Chuyển sang chế độ gọi thoại...');
      await _xiaozhiService.switchToVoiceCallMode();
      print('VoiceCallScreen: Đã chuyển sang chế độ gọi thoại thành công');

      if (mounted) {
        setState(() {
          _statusText = 'Đã kết nối';
          _isConnected = true;
        });
      }

      // Hiển thị thông báo kết nối thành công
      if (mounted) {
        _showCustomSnackbar(
          message: 'Đã vào chế độ gọi thoại',
          icon: Icons.check_circle,
          iconColor: Colors.greenAccent,
        );
      }

      _startCallTimer();

      // Thêm tin nhắn phiên
      Provider.of<ConversationProvider>(context, listen: false).addMessage(
        conversationId: widget.conversation.id,
        role: MessageRole.assistant,
        content: 'Gọi thoại đã bắt đầu',
      );

      // Bắt đầu ghi âm trực tiếp
      _startSpeaking();
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusText = 'Chuẩn bị thất bại';
          _isConnected = false;
        });
      }
      print('Chuẩn bị thất bại: $e');

      if (mounted) {
        _showCustomSnackbar(
          message: 'Vào chế độ gọi thoại thất bại: $e',
          icon: Icons.error_outline,
          iconColor: Colors.redAccent,
        );
      }
    }
  }

  void _startCallTimer() {
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _callDuration = Duration(seconds: timer.tick);
        });
      }
    });
  }

  void _startAudioVisualizer() {
    _audioVisualizerTimer = Timer.periodic(const Duration(milliseconds: 100), (
      timer,
    ) {
      if (mounted && _isConnected) {
        setState(() {
          // Simulate audio levels
          for (int i = 0; i < _audioLevels.length - 1; i++) {
            _audioLevels[i] = _audioLevels[i + 1];
          }

          if (_isSpeaking) {
            _audioLevels[_audioLevels.length - 1] =
                0.05 + (0.6 * (0.5 + 0.5 * _animationController.value));
          } else {
            _audioLevels[_audioLevels.length - 1] =
                0.05 + (0.1 * (0.5 + 0.5 * _animationController.value));
          }
        });
      }
    });
  }

  // Bắt đầu ghi âm
  void _startSpeaking() {
    if (!_isSpeaking) {
      if (mounted) {
        setState(() {
          _isSpeaking = true;
        });
      }

      try {
        // Bắt đầu ghi âm và đăng ký luồng âm thanh
        _xiaozhiService
            .startListeningCall()
            .then((_) {
              if (mounted) {
                _showCustomSnackbar(
                  message: 'Đang ghi âm...',
                  icon: Icons.mic,
                  iconColor: Colors.greenAccent,
                );
              }
            })
            .catchError((e) {
              print('Bắt đầu ghi âm thất bại: $e');
              // Nếu thất bại, khôi phục trạng thái
              if (mounted) {
                setState(() {
                  _isSpeaking = false;
                });

                _showCustomSnackbar(
                  message: 'Bắt đầu ghi âm thất bại: $e',
                  icon: Icons.error,
                  iconColor: Colors.redAccent,
                );
              }
            });
      } catch (e) {
        print('Bắt đầu ghi âm thất bại: $e');
        // Nếu thất bại, khôi phục trạng thái
        if (mounted) {
          setState(() {
            _isSpeaking = false;
          });
        }

        if (mounted) {
          _showCustomSnackbar(
            message: 'Bắt đầu ghi âm thất bại: $e',
            icon: Icons.error,
            iconColor: Colors.redAccent,
          );
        }
      }
    }
  }

  // Gửi tin nhắn ngắt
  void _sendAbortMessage() {
    // Gửi tin nhắn ngắt
    _xiaozhiService.sendAbortMessage();

    if (mounted) {
      _showCustomSnackbar(
        message: 'Đã gửi tín hiệu ngắt',
        icon: Icons.pan_tool,
        iconColor: Colors.orangeAccent,
      );
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    // Đảm bảo cài đặt thanh trạng thái đúng
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        leading: Container(
          margin: const EdgeInsets.only(left: 8, top: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
            onPressed: () {
              // Dừng phát trước khi quay về
              _xiaozhiService.stopPlayback();
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Nền gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  Theme.of(context).colorScheme.primary.withOpacity(0.6),
                ],
              ),
            ),
          ),

          // Nền hình sóng
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'assets/images/wave_pattern.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Nội dung chính
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Avatar hình tròn
                Hero(
                  tag: 'avatar_${widget.conversation.id}',
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.9),
                          Theme.of(context).colorScheme.primaryContainer,
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 名称显示
                Text(
                  widget.conversation.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Hiển thị trạng thái - sử dụng kiểu skeuomorphic
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color:
                        _isConnected
                            ? Colors.green.withOpacity(0.2)
                            : Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color:
                          _isConnected
                              ? Colors.green.withOpacity(0.6)
                              : Colors.red.withOpacity(0.6),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            _isConnected
                                ? Colors.green.withOpacity(0.2)
                                : Colors.red.withOpacity(0.2),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isConnected ? Icons.check_circle : Icons.error_outline,
                        color: _isConnected ? Colors.green : Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isSpeaking ? '$_statusText (Đang ghi âm)' : _statusText,
                        style: TextStyle(
                          color: _isConnected ? Colors.green : Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Thời lượng cuộc gọi
                Text(
                  'Thời lượng cuộc gọi: ${_formatDuration(_callDuration)}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 40),

                // Hiển thị text từ server
                if (_currentText.isNotEmpty)
                  _buildServerTextDisplay(),

                // Hiển thị emotion từ server
                if (_currentEmotion.isNotEmpty)
                  _buildEmotionDisplay(),

                const SizedBox(height: 20),

                // Trực quan hóa âm thanh
                _buildAudioVisualizer(),
                const SizedBox(height: 60),

                // Nút điều khiển cuộc gọi
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildEndCallButton(),
                      const SizedBox(width: 40),
                      _buildControlButton(
                        icon:
                            Icons
                                .pan_tool, // Đổi thành biểu tượng bàn tay chỉ ngắt
                        color: Colors.white,
                        backgroundColor: Colors.orange,
                        onPressed: _sendAbortMessage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioVisualizer() {
    return Container(
      width: 240,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(
          _audioLevels.length,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 50),
            curve: Curves.easeInOut,
            width: 4,
            height: 80 * _audioLevels[index],
            decoration: BoxDecoration(
              color: _getBarColor(index, _audioLevels[index]),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }

  Color _getBarColor(int index, double level) {
    if (_isSpeaking) {
      // Gradient từ xanh dương sang xanh lá
      double position = index / _audioLevels.length;
      return Color.lerp(
        Colors.blue.shade400,
        Colors.green.shade400,
        position,
      )!.withOpacity(0.7 + 0.3 * level);
    } else {
      // Sử dụng màu xanh dương nhạt khi không nói
      return Colors.blue.shade200.withOpacity(0.3 + 0.4 * level);
    }
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required Color backgroundColor,
    double size = 56,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: backgroundColor.withOpacity(0.4),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Center(child: Icon(icon, color: color, size: size * 0.45)),
        ),
      ),
    );
  }

  Widget _buildEndCallButton() {
    return GestureDetector(
      onTap: () async {
        // Kết thúc cuộc gọi và thoát ứng dụng
        await _endCallAndExit();
      },
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.red.shade400.withOpacity(0.3),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Icon(
          Icons.call_end_rounded,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }

  Future<void> _endCallAndExit() async {
    try {
      // Hiển thị thông báo đang kết thúc
      if (mounted) {
        _showCustomSnackbar(
          message: 'Đang kết thúc cuộc gọi...',
          icon: Icons.call_end,
          iconColor: Colors.redAccent,
        );
      }

      // Dừng tất cả hoạt động âm thanh
      _xiaozhiService.stopPlayback();

      // Ngắt kết nối WebSocket
      await _xiaozhiService.disconnect();

      // Hủy tất cả timer
      _callTimer?.cancel();
      _audioVisualizerTimer?.cancel();

      // Chờ một chút để đảm bảo ngắt kết nối hoàn tất
      await Future.delayed(const Duration(milliseconds: 500));

      // Thoát ứng dụng hoàn toàn
      if (mounted) {
        Navigator.of(context).pop(); // Quay về trang trước
      }

      // Thoát ứng dụng
      await Future.delayed(const Duration(milliseconds: 100));
      SystemNavigator.pop();

    } catch (e) {
      print('Lỗi khi kết thúc cuộc gọi: $e');

      // Ngay cả khi có lỗi, vẫn cố gắng thoát ứng dụng
      if (mounted) {
        Navigator.of(context).pop();
      }
      SystemNavigator.pop();
    }
  }

  // Widget hiển thị text từ server
  Widget _buildServerTextDisplay() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.smart_toy,
                color: Colors.blue.shade200,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'AI đang nói:',
                style: TextStyle(
                  color: Colors.blue.shade200,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _currentText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // Widget hiển thị emotion từ server
  Widget _buildEmotionDisplay() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.purple.withOpacity(0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.mood,
            color: Colors.purple.shade200,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            _currentEmotion,
            style: TextStyle(
              color: Colors.purple.shade200,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }


  // Hiển thị Snackbar tùy chỉnh
  void _showCustomSnackbar({
    required String message,
    required IconData icon,
    required Color iconColor,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.black87,
      duration: const Duration(seconds: 3),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 100,
        left: 16,
        right: 16,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
