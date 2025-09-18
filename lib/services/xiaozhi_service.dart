import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound/flutter_sound.dart';
import '../services/xiaozhi_websocket_manager.dart';
import '../utils/device_util.dart';
import '../utils/audio_util.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Loại sự kiện dịch vụ Xiaozhi
enum XiaozhiServiceEventType {
  connected,
  disconnected,
  textMessage,
  audioData,
  error,
  voiceCallStart,
  voiceCallEnd,
  userMessage,
}

/// Sự kiện dịch vụ Xiaozhi
class XiaozhiServiceEvent {
  final XiaozhiServiceEventType type;
  final dynamic data;

  XiaozhiServiceEvent(this.type, this.data);
}

/// Trình nghe dịch vụ Xiaozhi
typedef XiaozhiServiceListener = void Function(XiaozhiServiceEvent event);

/// Trình nghe tin nhắn
typedef MessageListener = void Function(dynamic message);

/// Dịch vụ Xiaozhi
class XiaozhiService {
  static const String TAG = "XiaozhiService";
  static const String DEFAULT_SERVER = "wss://ws.xiaozhi.ai";

  // Thực thể singleton
  static XiaozhiService? _instance;

  final String websocketUrl;
  final String macAddress;
  final String token;
  String? _sessionId; // ID phiên sẽ được cung cấp bởi máy chủ

  XiaozhiWebSocketManager? _webSocketManager;
  bool _isConnected = false;
  bool _isMuted = false;
  final List<XiaozhiServiceListener> _listeners = [];
  StreamSubscription? _audioStreamSubscription;
  bool _isVoiceCallActive = false;
  WebSocketChannel? _ws;
  bool _hasStartedCall = false;
  MessageListener? _messageListener;

  /// Hàm tạo nhà máy, thực hiện mẫu singleton
  factory XiaozhiService({
    required String websocketUrl,
    required String macAddress,
    required String token,
    String? sessionId,
  }) {
    _instance ??= XiaozhiService._internal(
      websocketUrl: websocketUrl,
      macAddress: macAddress,
      token: token,
      sessionId: sessionId,
    );
    return _instance!;
  }

  /// Hàm tạo nội bộ
  XiaozhiService._internal({
    required this.websocketUrl,
    required this.macAddress,
    required this.token,
    String? sessionId,
  }) {
    _sessionId = sessionId;
    _init();
  }

  /// Lấy thực thể
  static XiaozhiService? get instance => _instance;

  /// Chuyển sang chế độ cuộc gọi thoại
  Future<void> switchToVoiceCallMode() async {
    // Nếu đã ở chế độ cuộc gọi thoại, trả về trực tiếp
    if (_isVoiceCallActive) return;

    try {
      print('$TAG: Đang chuyển sang chế độ cuộc gọi thoại');

      // Đơn giản hóa quy trình khởi tạo, đảm bảo trạng thái sạch
      await AudioUtil.stopPlaying();
      await AudioUtil.initRecorder();
      await AudioUtil.initPlayer();

      _isVoiceCallActive = true;
      print('$TAG: Đã chuyển sang chế độ cuộc gọi thoại');
    } catch (e) {
      print('$TAG: Chuyển sang chế độ cuộc gọi thoại thất bại: $e');
      rethrow;
    }
  }

  /// Chuyển sang chế độ trò chuyện thông thường
  Future<void> switchToChatMode() async {
    // Nếu đã ở chế độ trò chuyện thông thường, trả về trực tiếp
    if (!_isVoiceCallActive) return;

    try {
      print('$TAG: Đang chuyển sang chế độ trò chuyện thông thường');

      // Dừng các hoạt động liên quan đến cuộc gọi thoại
      await stopListeningCall();

      // Đảm bảo trình phát đã dừng
      await AudioUtil.stopPlaying();

      _isVoiceCallActive = false;
      print('$TAG: Đã chuyển sang chế độ trò chuyện thông thường');
    } catch (e) {
      print('$TAG: Chuyển sang chế độ trò chuyện thông thường thất bại: $e');
      _isVoiceCallActive = false;
    }
  }

  /// Khởi tạo
  Future<void> _init() async {
    // Sử dụng địa chỉ MAC từ cấu hình làm ID thiết bị
    print(
      '$TAG: Khởi tạo hoàn tất, sử dụng địa chỉ MAC làm ID thiết bị: $macAddress',
    );

    // Khởi tạo trình quản lý WebSocket, kích hoạt token
    _webSocketManager = XiaozhiWebSocketManager(
      deviceId: macAddress,
      enableToken: true,
    );

    // Thêm trình nghe sự kiện WebSocket
    _webSocketManager!.addListener(_onWebSocketEvent);

    // Khởi tạo công cụ âm thanh
    await AudioUtil.initRecorder();
    await AudioUtil.initPlayer();
  }

  /// Thiết lập trình nghe tin nhắn
  void setMessageListener(MessageListener listener) {
    _messageListener = listener;
  }

  /// Thêm trình nghe sự kiện
  void addListener(XiaozhiServiceListener listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  /// Xóa trình nghe sự kiện
  void removeListener(XiaozhiServiceListener listener) {
    _listeners.remove(listener);
  }

  /// Phân phối sự kiện đến tất cả trình nghe
  void _dispatchEvent(XiaozhiServiceEvent event) {
    for (var listener in _listeners) {
      listener(event);
    }
  }

  /// Kết nối đến dịch vụ Xiaozhi
  Future<void> connect() async {
    if (_isConnected) return;

    try {
      print('$TAG: Bắt đầu kết nối máy chủ...');

      // Tạo trình quản lý WebSocket
      _webSocketManager = XiaozhiWebSocketManager(
        deviceId: macAddress,
        enableToken: true,
      );

      // Thêm trình nghe sự kiện WebSocket
      _webSocketManager!.addListener(_onWebSocketEvent);

      // Kết nối WebSocket
      await _webSocketManager!.connect(websocketUrl, token);
    } catch (e) {
      print('$TAG: Kết nối thất bại: $e');
      _dispatchEvent(
        XiaozhiServiceEvent(
          XiaozhiServiceEventType.error,
          'Kết nối dịch vụ Xiaozhi thất bại: $e',
        ),
      );
    }
  }

  /// Ngắt kết nối dịch vụ Xiaozhi
  Future<void> disconnect() async {
    if (!_isConnected || _webSocketManager == null) return;

    try {
      // Hủy đăng ký luồng âm thanh
      await _audioStreamSubscription?.cancel();
      _audioStreamSubscription = null;

      // Dừng ghi âm
      if (AudioUtil.isRecording) {
        await AudioUtil.stopRecording();
      }

      // Ngắt kết nối WebSocket
      await _webSocketManager!.disconnect();
      _webSocketManager = null;
      _isConnected = false;
    } catch (e) {
      print('$TAG: Ngắt kết nối thất bại: $e');
    }
  }

  /// Gửi tin nhắn văn bản
  Future<String> sendTextMessage(String message) async {
    if (!_isConnected && _webSocketManager == null) {
      await connect();
    }

    try {
      // Tạo một Completer để chờ phản hồi
      final completer = Completer<String>();
      bool hasResponse = false;

      print('$TAG: Bắt đầu gửi tin nhắn văn bản: $message');

      // Thêm trình nghe tin nhắn, nghe tất cả phản hồi có thể
      void onceListener(XiaozhiServiceEvent event) {
        if (event.type == XiaozhiServiceEventType.textMessage) {
          // Bỏ qua tin nhắn echo (tức là tin nhắn chúng ta gửi)
          if (event.data == message) {
            print('$TAG: Bỏ qua tin nhắn echo: ${event.data}');
            return;
          }

          print('$TAG: Nhận phản hồi từ máy chủ: ${event.data}');
          if (!completer.isCompleted) {
            hasResponse = true;
            completer.complete(event.data as String);
            removeListener(onceListener);
          }
        } else if (event.type == XiaozhiServiceEventType.error &&
            !completer.isCompleted) {
          print('$TAG: Nhận phản hồi lỗi: ${event.data}');
          completer.completeError(event.data.toString());
          removeListener(onceListener);
        }
      }

      // Thêm trình nghe trước, đảm bảo không bỏ lỡ tin nhắn nào
      addListener(onceListener);

      // Gửi yêu cầu văn bản
      print('$TAG: Gửi yêu cầu văn bản: $message');
      _webSocketManager!.sendTextRequest(message);

      // Thiết lập thời gian chờ, 15 giây rộng rãi hơn 10 giây
      final timeoutTimer = Timer(const Duration(seconds: 15), () {
        if (!completer.isCompleted) {
          print(
            '$TAG: Yêu cầu hết thời gian, không nhận được phản hồi trong 15 giây',
          );
          completer.completeError('Yêu cầu hết thời gian');
          removeListener(onceListener);
        }
      });

      // Chờ phản hồi
      try {
        final result = await completer.future;
        // Hủy bộ đếm thời gian hết hạn
        timeoutTimer.cancel();
        return result;
      } catch (e) {
        // Hủy bộ đếm thời gian hết hạn
        timeoutTimer.cancel();
        rethrow;
      }
    } catch (e) {
      print('$TAG: Gửi tin nhắn thất bại: $e');
      rethrow;
    }
  }

  /// Kết nối cuộc gọi thoại
  Future<void> connectVoiceCall() async {
    try {
      // Đơn giản hóa quy trình, đảm bảo quyền và âm thanh sẵn sàng
      if (Platform.isIOS || Platform.isAndroid) {
        final status = await Permission.microphone.request();
        if (status != PermissionStatus.granted) {
          print('$TAG: Quyền micro bị từ chối');
          _dispatchEvent(
            XiaozhiServiceEvent(
              XiaozhiServiceEventType.error,
              'Quyền micro bị từ chối',
            ),
          );
          return;
        }
      }

      // Khởi tạo hệ thống âm thanh
      await AudioUtil.stopPlaying();
      await AudioUtil.initRecorder();
      await AudioUtil.initPlayer();

      print('$TAG: Đang kết nối $websocketUrl');
      print('$TAG: ID thiết bị: $macAddress');
      print('$TAG: Token kích hoạt: true');
      print('$TAG: Sử dụng Token: $token');

      // Sử dụng WebSocketManager để kết nối
      _webSocketManager = XiaozhiWebSocketManager(
        deviceId: macAddress,
        enableToken: true,
      );
      _webSocketManager!.addListener(_onWebSocketEvent);
      await _webSocketManager!.connect(websocketUrl, token);
    } catch (e) {
      print('$TAG: Kết nối thất bại: $e');
      rethrow;
    }
  }

  /// Kết thúc cuộc gọi thoại
  Future<void> disconnectVoiceCall() async {
    if (_webSocketManager == null) return;

    try {
      // Dừng ghi âm
      if (AudioUtil.isRecording) {
        await AudioUtil.stopRecording();
      }

      // Dừng phát âm thanh
      await AudioUtil.stopPlaying();

      // Hủy đăng ký luồng âm thanh
      await _audioStreamSubscription?.cancel();
      _audioStreamSubscription = null;

      // Ngắt kết nối trực tiếp
      await disconnect();
    } catch (e) {
      // Bỏ qua lỗi khi ngắt kết nối
      print('$TAG: Lỗi xảy ra khi kết thúc cuộc gọi thoại: $e');
    }
  }

  /// Bắt đầu nói
  Future<void> startSpeaking() async {
    try {
      final message = {'type': 'speak', 'state': 'start', 'mode': 'auto'};
      _webSocketManager?.sendMessage(jsonEncode(message));
      print('$TAG: Đã gửi tin nhắn bắt đầu nói');
    } catch (e) {
      print('$TAG: Bắt đầu nói thất bại: $e');
    }
  }

  /// Dừng nói
  Future<void> stopSpeaking() async {
    try {
      final message = {'type': 'speak', 'state': 'stop', 'mode': 'auto'};
      _webSocketManager?.sendMessage(jsonEncode(message));
      print('$TAG: Đã gửi tin nhắn dừng nói');
    } catch (e) {
      print('$TAG: Dừng nói thất bại: $e');
    }
  }

  /// Gửi tin nhắn listen
  void _sendListenMessage() async {
    try {
      final listenMessage = {
        'type': 'listen',
        'session_id': _sessionId,
        'state': 'start',
        'mode': 'auto',
      };
      _webSocketManager?.sendMessage(jsonEncode(listenMessage));
      print('$TAG: Đã gửi tin nhắn listen');

      // Bắt đầu ghi âm
      _isVoiceCallActive = true;
      await AudioUtil.startRecording();
    } catch (e) {
      print('$TAG: Gửi tin nhắn listen thất bại: $e');
      _dispatchEvent(
        XiaozhiServiceEvent(
          XiaozhiServiceEventType.error,
          'Gửi tin nhắn listen thất bại: $e',
        ),
      );
    }
  }

  /// Bắt đầu nghe nói (chế độ cuộc gọi thoại)
  Future<void> startListeningCall() async {
    try {
      // Đảm bảo đã có ID phiên
      if (_sessionId == null) {
        print(
          '$TAG: Không có ID phiên, không thể bắt đầu nghe, chờ khởi tạo ID phiên...',
        );
        // Chờ một khoảng thời gian ngắn, sau đó kiểm tra lại ID phiên
        await Future.delayed(const Duration(milliseconds: 500));
        if (_sessionId == null) {
          print('$TAG: ID phiên vẫn rỗng, bỏ qua bắt đầu nghe');
          throw Exception('ID phiên rỗng, không thể bắt đầu ghi âm');
        }
      }

      print('$TAG: Sử dụng ID phiên để bắt đầu ghi âm: $_sessionId');

      // Yêu cầu quyền micro
      if (Platform.isIOS) {
        final micStatus = await Permission.microphone.status;
        if (micStatus != PermissionStatus.granted) {
          final result = await Permission.microphone.request();
          if (result != PermissionStatus.granted) {
            print('$TAG: Quyền micro bị từ chối');
            _dispatchEvent(
              XiaozhiServiceEvent(
                XiaozhiServiceEventType.error,
                'Quyền micro bị từ chối',
              ),
            );
            return;
          }
        }

        // Đảm bảo phiên âm thanh đã được khởi tạo
        await AudioUtil.initRecorder();
      } else {
        // Yêu cầu quyền Android
        final status = await Permission.microphone.request();
        if (status.isDenied) {
          print('$TAG: Quyền micro bị từ chối');
          _dispatchEvent(
            XiaozhiServiceEvent(
              XiaozhiServiceEventType.error,
              'Quyền micro bị từ chối',
            ),
          );
          return;
        }
      }

      // Bắt đầu ghi âm
      await AudioUtil.startRecording();

      // Thiết lập đăng ký luồng âm thanh
      _audioStreamSubscription = AudioUtil.audioStream.listen((opusData) {
        // Gửi dữ liệu âm thanh
        _webSocketManager?.sendBinaryMessage(opusData);
      });

      // Gửi lệnh bắt đầu nghe
      final message = {
        'session_id': _sessionId,
        'type': 'listen',
        'state': 'start',
        'mode': 'auto',
      };
      _webSocketManager?.sendMessage(jsonEncode(message));
      print('$TAG: Đã gửi tin nhắn bắt đầu nghe (chế độ cuộc gọi thoại)');
    } catch (e) {
      print('$TAG: Bắt đầu nghe thất bại: $e');
      throw Exception('Bắt đầu đầu vào thoại thất bại: $e');
    }
  }

  /// Dừng nghe nói (chế độ cuộc gọi thoại)
  Future<void> stopListeningCall() async {
    try {
      // Hủy đăng ký luồng âm thanh
      await _audioStreamSubscription?.cancel();
      _audioStreamSubscription = null;

      // Dừng ghi âm
      await AudioUtil.stopRecording();

      // Gửi lệnh dừng nghe
      if (_sessionId != null && _webSocketManager != null) {
        final message = {
          'session_id': _sessionId,
          'type': 'listen',
          'state': 'stop',
          'mode': 'auto',
        };
        _webSocketManager?.sendMessage(jsonEncode(message));
        print('$TAG: Đã gửi tin nhắn dừng nghe (chế độ cuộc gọi thoại)');
      }
    } catch (e) {
      print('$TAG: Dừng nghe thất bại: $e');
    }
  }

  /// Hủy gửi (vuốt lên để hủy)
  Future<void> abortListening() async {
    try {
      // Hủy đăng ký luồng âm thanh
      await _audioStreamSubscription?.cancel();
      _audioStreamSubscription = null;

      // Dừng ghi âm
      await AudioUtil.stopRecording();

      // Gửi lệnh hủy
      if (_sessionId != null && _webSocketManager != null) {
        final message = {'session_id': _sessionId, 'type': 'abort'};
        _webSocketManager?.sendMessage(jsonEncode(message));
        print('$TAG: Đã gửi tin nhắn hủy');
      }
    } catch (e) {
      print('$TAG: Hủy nghe thất bại: $e');
    }
  }

  /// Chuyển đổi trạng thái im lặng
  void toggleMute() {
    _isMuted = !_isMuted;

    if (_webSocketManager == null || !_webSocketManager!.isConnected) return;

    try {
      final request = {'type': _isMuted ? 'voice_mute' : 'voice_unmute'};

      _webSocketManager!.sendMessage(jsonEncode(request));
    } catch (e) {
      print('$TAG: Chuyển đổi trạng thái im lặng thất bại: $e');
    }
  }

  /// Xử lý sự kiện WebSocket
  void _onWebSocketEvent(XiaozhiEvent event) {
    switch (event.type) {
      case XiaozhiEventType.connected:
        _isConnected = true;
        _dispatchEvent(
          XiaozhiServiceEvent(XiaozhiServiceEventType.connected, null),
        );
        break;

      case XiaozhiEventType.disconnected:
        _isConnected = false;
        _dispatchEvent(
          XiaozhiServiceEvent(XiaozhiServiceEventType.disconnected, null),
        );
        break;

      case XiaozhiEventType.message:
        _handleTextMessage(event.data as String);
        break;

      case XiaozhiEventType.binaryMessage:
        // Xử lý dữ liệu âm thanh nhị phân - đơn giản hóa phát trực tiếp
        final audioData = event.data as List<int>;
        AudioUtil.playOpusData(Uint8List.fromList(audioData));
        break;

      case XiaozhiEventType.error:
        _dispatchEvent(
          XiaozhiServiceEvent(XiaozhiServiceEventType.error, event.data),
        );
        break;
    }
  }

  /// Xử lý tin nhắn WebSocket
  void _handleWebSocketMessage(dynamic message) {
    try {
      if (message is String) {
        _handleTextMessage(message);
      } else if (message is List<int>) {
        AudioUtil.playOpusData(Uint8List.fromList(message));
      }
    } catch (e) {
      print('$TAG: Xử lý tin nhắn thất bại: $e');
    }
  }

  /// Xử lý tin nhắn văn bản
  void _handleTextMessage(String message) {
    print('$TAG: Nhận tin nhắn văn bản: $message');
    try {
      final Map<String, dynamic> jsonData = json.decode(message);
      final String type = jsonData['type'] ?? '';

      // Đảm bảo gọi trình nghe tin nhắn trước tiên
      if (_messageListener != null) {
        _messageListener!(jsonData);
      }

      // Cập nhật ID phiên (máy chủ sẽ cung cấp ID phiên mới trong tin nhắn hello)
      if (jsonData['session_id'] != null) {
        _sessionId = jsonData['session_id'];
        print('$TAG: Cập nhật ID phiên: $_sessionId');
      }

      // Phân phối sự kiện theo loại tin nhắn
      switch (type) {
        case 'hello':
          // Xử lý phản hồi hello của máy chủ
          if (_isVoiceCallActive && !_hasStartedCall) {
            _hasStartedCall = true;
            // Gửi tin nhắn chế độ nói tự động
            startSpeaking();
          }
          break;

        case 'start':
          // Sau khi nhận phản hồi start, nếu ở chế độ cuộc gọi thoại, bắt đầu ghi âm
          if (_isVoiceCallActive) {
            _sendListenMessage();
          }
          break;

        case 'tts':
          // Xử lý tin nhắn TTS
          final String state = jsonData['state'] ?? '';
          final String text = jsonData['text'] ?? '';

          if (state == 'sentence_start' && text.isNotEmpty) {
            print('$TAG: Nhận câu TTS: $text');
            _dispatchEvent(
              XiaozhiServiceEvent(XiaozhiServiceEventType.textMessage, text),
            );
          }
          break;

        case 'stt':
          // Xử lý kết quả nhận dạng giọng nói
          final String text = jsonData['text'] ?? '';
          if (text.isNotEmpty) {
            print('$TAG: Nhận kết quả nhận dạng giọng nói: $text');
            // Phân phối sự kiện tin nhắn người dùng trước
            _dispatchEvent(
              XiaozhiServiceEvent(XiaozhiServiceEventType.userMessage, text),
            );
          }
          break;

        case 'emotion':
          // Xử lý tin nhắn biểu cảm
          final String emotion = jsonData['emotion'] ?? '';
          if (emotion.isNotEmpty) {
            print('$TAG: Nhận tin nhắn biểu cảm: $emotion');
            _dispatchEvent(
              XiaozhiServiceEvent(
                XiaozhiServiceEventType.textMessage,
                'Biểu cảm: $emotion',
              ),
            );
          }
          break;

        default:
          // Đối với các loại tin nhắn khác, bỏ qua trực tiếp
          print(
            '$TAG: Nhận tin nhắn loại không biết: $type, dữ liệu gốc: $message',
          );
      }
    } catch (e) {
      print('$TAG: Phân tích tin nhắn thất bại: $e, tin nhắn gốc: $message');
    }
  }

  /// Bắt đầu cuộc gọi
  void _startCall() {
    try {
      // Gửi tin nhắn bắt đầu cuộc gọi
      final startMessage = {
        'type': 'start',
        'mode': 'auto',
        'audio_params': {
          'format': 'opus',
          'sample_rate': 16000,
          'channels': 1,
          'frame_duration': 60,
        },
      };
      _webSocketManager?.sendMessage(jsonEncode(startMessage));
      print('$TAG: Đã gửi tin nhắn bắt đầu cuộc gọi');
    } catch (e) {
      print('$TAG: Bắt đầu cuộc gọi thất bại: $e');
    }
  }

  /// Ngắt âm thanh phát
  Future<void> stopPlayback() async {
    try {
      print('$TAG: Đang dừng phát âm thanh');

      // Dừng phát đơn giản và trực tiếp
      await AudioUtil.stopPlaying();

      print('$TAG: Phát âm thanh đã dừng');
    } catch (e) {
      print('$TAG: Dừng phát âm thanh thất bại: $e');
    }
  }

  /// Kiểm tra xem đã kết nối chưa
  bool get isConnected =>
      _isConnected &&
      _webSocketManager != null &&
      _webSocketManager!.isConnected;

  /// Kiểm tra xem có bị tắt tiếng không
  bool get isMuted => _isMuted;

  /// Kiểm tra xem cuộc gọi thoại có hoạt động không
  bool get isVoiceCallActive => _isVoiceCallActive;

  /// Giải phóng tài nguyên
  Future<void> dispose() async {
    await disconnect();
    await AudioUtil.dispose();
    _listeners.clear();
    print('$TAG: Tài nguyên đã được giải phóng');
  }

  /// Bắt đầu nghe (chế độ giữ để nói)
  Future<void> startListening({String mode = 'manual'}) async {
    if (!_isConnected || _webSocketManager == null) {
      await connect();
    }

    try {
      // Đảm bảo đã có ID phiên
      if (_sessionId == null) {
        print('$TAG: Không có ID phiên, không thể bắt đầu nghe');
        return;
      }

      // Bắt đầu ghi âm
      await AudioUtil.startRecording();

      // Gửi lệnh bắt đầu nghe
      final message = {
        'session_id': _sessionId,
        'type': 'listen',
        'state': 'start',
        'mode': mode,
      };
      _webSocketManager?.sendMessage(jsonEncode(message));
      print('$TAG: Đã gửi tin nhắn bắt đầu nghe (giữ để nói)');

      // Thiết lập đăng ký luồng âm thanh
      _audioStreamSubscription = AudioUtil.audioStream.listen((opusData) {
        // Gửi dữ liệu âm thanh
        _webSocketManager?.sendBinaryMessage(opusData);
      });
    } catch (e) {
      print('$TAG: Bắt đầu nghe thất bại: $e');
      throw Exception('Bắt đầu đầu vào thoại thất bại: $e');
    }
  }

  /// Dừng nghe (chế độ giữ để nói)
  Future<void> stopListening() async {
    try {
      // Hủy đăng ký luồng âm thanh
      await _audioStreamSubscription?.cancel();
      _audioStreamSubscription = null;

      // Dừng ghi âm
      await AudioUtil.stopRecording();

      // Gửi lệnh dừng nghe
      if (_sessionId != null && _webSocketManager != null) {
        final message = {
          'session_id': _sessionId,
          'type': 'listen',
          'state': 'stop',
        };
        _webSocketManager?.sendMessage(jsonEncode(message));
        print('$TAG: Đã gửi tin nhắn dừng nghe');
      }
    } catch (e) {
      print('$TAG: Dừng nghe thất bại: $e');
    }
  }

  /// Gửi tin nhắn ngắt
  Future<void> sendAbortMessage() async {
    try {
      if (_webSocketManager != null && _isConnected && _sessionId != null) {
        final abortMessage = {
          'session_id': _sessionId,
          'type': 'abort',
          'reason': 'wake_word_detected',
        };
        _webSocketManager?.sendMessage(jsonEncode(abortMessage));
        print('$TAG: Gửi tin nhắn ngắt: $abortMessage');

        // Nếu đang ghi âm, tạm dừng ngắn sau đó tiếp tục
        if (_isSpeaking) {
          await stopListeningCall();
          await Future.delayed(const Duration(milliseconds: 500));
          await startListeningCall();
        }
      }
    } catch (e) {
      print('$TAG: Gửi tin nhắn ngắt thất bại: $e');
    }
  }

  /// Kiểm tra xem có đang nói không
  bool get _isSpeaking => _audioStreamSubscription != null;
}
