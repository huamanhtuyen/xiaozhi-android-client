import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
// Thử import io.dart, nhưng sẽ ném ngoại lệ trên nền tảng web
import 'package:web_socket_channel/io.dart'
    if (dart.library.html) 'package:web_socket_channel/html.dart';

/// Loại sự kiện WebSocket của Xiaozhi
enum XiaozhiEventType { connected, disconnected, message, error, binaryMessage }

/// Sự kiện WebSocket của Xiaozhi
class XiaozhiEvent {
  final XiaozhiEventType type;
  final dynamic data;

  XiaozhiEvent({required this.type, this.data});
}

/// Giao diện listener WebSocket của Xiaozhi
typedef XiaozhiWebSocketListener = void Function(XiaozhiEvent event);

/// Trình quản lý WebSocket của Xiaozhi
class XiaozhiWebSocketManager {
  static const String TAG = "XiaozhiWebSocket";
  static const int RECONNECT_DELAY = 3000; // Kết nối lại sau 3 giây

  WebSocketChannel? _channel;
  String? _serverUrl;
  String? _deviceId;
  String? _token;
  bool _enableToken;

  final List<XiaozhiWebSocketListener> _listeners = [];
  bool _isReconnecting = false;
  Timer? _reconnectTimer;
  StreamSubscription? _streamSubscription;

  /// Hàm khởi tạo
  XiaozhiWebSocketManager({required String deviceId, bool enableToken = false})
    : _deviceId = deviceId,
      _enableToken = enableToken;

  /// Thêm listener sự kiện
  void addListener(XiaozhiWebSocketListener listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  /// Xóa listener sự kiện
  void removeListener(XiaozhiWebSocketListener listener) {
    _listeners.remove(listener);
  }

  /// Phân phối sự kiện đến tất cả listener
  void _dispatchEvent(XiaozhiEvent event) {
    for (var listener in _listeners) {
      listener(event);
    }
  }

  /// Kết nối đến máy chủ WebSocket
  Future<void> connect(String url, String token) async {
    if (url.isEmpty) {
      _dispatchEvent(
        XiaozhiEvent(type: XiaozhiEventType.error, data: "Địa chỉ WebSocket không được để trống"),
      );
      return;
    }

    // Lưu tham số kết nối
    _serverUrl = url;
    _token = token;

    // Nếu đã kết nối, ngắt kết nối trước
    if (_channel != null) {
      await disconnect();
    }

    try {
      // Tạo kết nối WebSocket
      Uri uri = Uri.parse(url);

      print('$TAG: Đang kết nối $url');
      print('$TAG: ID thiết bị: $_deviceId');
      print('$TAG: Token được bật: $_enableToken');

      if (_enableToken) {
        print('$TAG: Sử dụng Token: $token');
      }

      // Thử sử dụng headers (cái này có hiệu lực trên nền tảng không phải Web)
      try {
        // Tạo headers
        Map<String, dynamic> headers = {
          'device-id': _deviceId ?? '',
          'client-id': _deviceId ?? '',
          'protocol-version': '1',
        };

        // Thêm header Authorization, tham khảo implementation Java
        if (_enableToken && token.isNotEmpty) {
          headers['Authorization'] = 'Bearer $token';
          print('$TAG: Thêm header Authorization: Bearer $token');
        } else {
          headers['Authorization'] = 'Bearer test-token';
          print('$TAG: Thêm header Authorization mặc định: Bearer test-token');
        }

        // Sử dụng IOWebSocketChannel và truyền headers
        _channel = IOWebSocketChannel.connect(uri, headers: headers);

        print('$TAG: Kết nối WebSocket bằng cách sử dụng headers thành công');
      } catch (e) {
        // Nếu không hỗ trợ IOWebSocketChannel (nền tảng web), thì chuyển về sử dụng kết nối cơ bản
        print('$TAG: Không hỗ trợ cách sử dụng headers, chuyển về kết nối cơ bản: $e');

        // Tạo kết nối cơ bản
        _channel = WebSocketChannel.connect(uri);

        // Sau khi kết nối thành công, gửi thông tin xác thực như là tin nhắn đầu tiên
        Timer(Duration(milliseconds: 100), () {
          if (_channel != null && isConnected) {
            // Gửi thông tin xác thực như là tin nhắn đầu tiên
            String authMessage =
                'Authorization: Bearer ${_enableToken && token.isNotEmpty ? token : "test-token"}';
            _channel!.sink.add(authMessage);
            print('$TAG: Gửi tin nhắn xác thực: $authMessage');

            // Gửi thông tin ID thiết bị
            String deviceIdMessage = 'Device-ID: $_deviceId';
            _channel!.sink.add(deviceIdMessage);
            print('$TAG: Gửi tin nhắn ID thiết bị: $deviceIdMessage');
          }
        });
      }

      // Lắng nghe sự kiện WebSocket
      _streamSubscription = _channel!.stream.listen(
        _onMessage,
        onDone: _onDisconnected,
        onError: _onError,
        cancelOnError: false,
      );

      // Sau khi kết nối thành công, gửi tin nhắn Hello
      _dispatchEvent(
        XiaozhiEvent(type: XiaozhiEventType.connected, data: null),
      );

      // Gửi tin nhắn Hello sau khi gửi thông tin xác thực
      Timer(Duration(milliseconds: 200), () {
        _sendHelloMessage();
      });

      print('$TAG: Đã kết nối đến $uri');
    } catch (e) {
      print('$TAG: Kết nối thất bại: $e');
      _dispatchEvent(
        XiaozhiEvent(type: XiaozhiEventType.error, data: "Tạo WebSocket thất bại: $e"),
      );
    }
  }

  /// Ngắt kết nối WebSocket
  Future<void> disconnect() async {
    // Hủy kết nối lại
    _reconnectTimer?.cancel();
    _isReconnecting = false;

    // Hủy đăng ký
    await _streamSubscription?.cancel();
    _streamSubscription = null;

    // Đóng kết nối
    if (_channel != null) {
      await _channel!.sink.close(status.normalClosure);
      _channel = null;
      print('$TAG: Kết nối đã ngắt');
    }
  }

  /// Gửi tin nhắn Hello
  void _sendHelloMessage() {
    final hello = {
      "type": "hello",
      "version": 1,
      "transport": "websocket",
      "audio_params": {
        "format": "opus",
        "sample_rate": 16000,
        "channels": 1,
        "frame_duration": 60,
      },
    };

    sendMessage(jsonEncode(hello));
  }

  /// Gửi tin nhắn văn bản
  void sendMessage(String message) {
    if (_channel != null && isConnected) {
      _channel!.sink.add(message);
    } else {
      print('$TAG: Gửi thất bại, kết nối chưa được thiết lập');
    }
  }

  /// Gửi dữ liệu nhị phân
  void sendBinaryMessage(List<int> data) {
    if (_channel != null && isConnected) {
      // Gỡ lỗi: In ra 20 byte đầu tiên dưới dạng biểu diễn thập lục phân
      if (data.length > 0) {
        String hexData = '';
        for (int i = 0; i < data.length && i < 20; i++) {
          hexData += '${data[i].toRadixString(16).padLeft(2, '0')} ';
        }
      }

      try {
        _channel!.sink.add(data);
      } catch (e) {
        print('$TAG: Gửi dữ liệu nhị phân thất bại: $e');
      }
    } else {
      print('$TAG: Gửi thất bại, kết nối chưa được thiết lập');
    }
  }

  /// Gửi yêu cầu văn bản
  void sendTextRequest(String text) {
    if (!isConnected) {
      print('$TAG: Gửi thất bại, kết nối chưa được thiết lập');
      return;
    }

    try {
      // Xây dựng định dạng tin nhắn, giữ tính nhất quán với implementation Java
      final jsonMessage = {
        "type": "listen",
        "state": "detect",
        "text": text,
        "source": "text",
      };

      print('$TAG: Gửi yêu cầu văn bản: ${jsonEncode(jsonMessage)}');
      sendMessage(jsonEncode(jsonMessage));
    } catch (e) {
      print('$TAG: Gửi yêu cầu văn bản thất bại: $e');
    }
  }

  /// Xử lý tin nhắn đã nhận
  void _onMessage(dynamic message) {
    if (message is String) {
      // Tin nhắn văn bản
      print('$TAG: 收到消息: $message');
      _dispatchEvent(
        XiaozhiEvent(type: XiaozhiEventType.message, data: message),
      );
    } else if (message is List<int>) {
      // Tin nhắn nhị phân
      _dispatchEvent(
        XiaozhiEvent(type: XiaozhiEventType.binaryMessage, data: message),
      );
    }
  }

  /// Xử lý sự kiện ngắt kết nối
  void _onDisconnected() {
    print('$TAG: Kết nối đã ngắt');
    _dispatchEvent(
      XiaozhiEvent(type: XiaozhiEventType.disconnected, data: null),
    );

    // Thử kết nối lại tự động
    if (!_isReconnecting && _serverUrl != null && _token != null) {
      _isReconnecting = true;
      _reconnectTimer = Timer(
        const Duration(milliseconds: RECONNECT_DELAY),
        () {
          _isReconnecting = false;
          if (_serverUrl != null && _token != null) {
            connect(_serverUrl!, _token!);
          }
        },
      );
    }
  }

  /// Xử lý sự kiện lỗi
  void _onError(error) {
    print('$TAG: Lỗi: $error');
    _dispatchEvent(
      XiaozhiEvent(type: XiaozhiEventType.error, data: error.toString()),
    );
  }

  /// 判断是否已连接
  bool get isConnected {
    return _channel != null && _streamSubscription != null;
  }
}
