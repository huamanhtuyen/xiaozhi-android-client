import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:collection';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:opus_dart/opus_dart.dart';
import 'package:just_audio/just_audio.dart' as ja;
import 'package:audio_session/audio_session.dart';
import 'package:collection/collection.dart';
import 'package:flutter_pcm_player/flutter_pcm_player.dart';

/// Công cụ âm thanh, dùng để xử lý mã hóa/giải mã Opus và ghi âm/phát lại
class AudioUtil {
  static const String TAG = "AudioUtil";
  static const int SAMPLE_RATE = 16000;
  static const int CHANNELS = 1;
  static const int FRAME_DURATION = 60; // mili giây

  static final AudioRecorder _audioRecorder = AudioRecorder();
  static ja.AudioPlayer? _player;
  static bool _isRecorderInitialized = false;
  static bool _isPlayerInitialized = false;
  static bool _isPlayerPrepared = false;
  static bool _isRecording = false;
  static bool _isPlaying = false;
  static final StreamController<Uint8List> _audioStreamController =
      StreamController<Uint8List>.broadcast();
  static String? _tempFilePath;
  static Timer? _audioProcessingTimer;

  // Các thành phần liên quan đến Opus
  static final _encoder = SimpleOpusEncoder(
    sampleRate: SAMPLE_RATE,
    channels: CHANNELS,
    application: Application.voip,
  );
  static final _decoder = SimpleOpusDecoder(
    sampleRate: SAMPLE_RATE,
    channels: CHANNELS,
  );

  // Instance của FlutterPcmPlayer
  static FlutterPcmPlayer? _pcmPlayer;

  /// Lấy luồng âm thanh
  static Stream<Uint8List> get audioStream => _audioStreamController.stream;

  /// Khởi tạo bộ ghi âm
  static Future<void> initRecorder() async {
    if (_isRecorderInitialized) return;

    print('$TAG: Bắt đầu khởi tạo bộ ghi âm');

    // Yêu cầu tích cực hơn tất cả các quyền có thể cần thiết
    if (Platform.isAndroid) {
      print('$TAG: Yêu cầu tất cả quyền cần thiết cho Android');
      Map<Permission, PermissionStatus> statuses =
          await [
            Permission.microphone,
            Permission.storage,
            Permission.manageExternalStorage,
            Permission.bluetooth,
            Permission.bluetoothConnect,
            Permission.bluetoothScan,
          ].request();

      print('$TAG: Trạng thái quyền:');
      statuses.forEach((permission, status) {
        print('$TAG: $permission: $status');
      });

      if (statuses[Permission.microphone] != PermissionStatus.granted) {
        print('$TAG: Quyền micro bị từ chối');
        throw Exception('Cần quyền micro');
      }
    } else {
      // iOS/các nền tảng khác chỉ yêu cầu quyền micro
      final status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        print('$TAG: Quyền micro bị từ chối');
        throw Exception('Cần quyền micro');
      }
    }

    // Kiểm tra tính khả dụng
    print('$TAG: Kiểm tra xem mã hóa PCM16 có được hỗ trợ không');
    final isAvailable = await _audioRecorder.isEncoderSupported(
      AudioEncoder.pcm16bits,
    );
    print('$TAG: Trạng thái hỗ trợ mã hóa PCM16: $isAvailable');

    // Thiết lập chế độ âm thanh - tham khảo triển khai Android gốc
    print('$TAG: Cấu hình phiên âm thanh');
    final session = await AudioSession.instance;

    // Sử dụng cấu hình gần với triển khai Android gốc hơn
    if (Platform.isAndroid) {
      await session.configure(
        const AudioSessionConfiguration(
          avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
          avAudioSessionCategoryOptions:
              AVAudioSessionCategoryOptions.allowBluetooth,
          avAudioSessionMode: AVAudioSessionMode.voiceChat,
          androidAudioAttributes: AndroidAudioAttributes(
            contentType: AndroidAudioContentType.speech,
            usage: AndroidAudioUsage.voiceCommunication,
            flags: AndroidAudioFlags.audibilityEnforced,
          ),
          androidAudioFocusGainType:
              AndroidAudioFocusGainType.gainTransientExclusive,
          androidWillPauseWhenDucked: false,
        ),
      );
    } else {
      await session.configure(
        const AudioSessionConfiguration(
          avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
          avAudioSessionCategoryOptions:
              AVAudioSessionCategoryOptions.allowBluetooth,
          avAudioSessionMode: AVAudioSessionMode.voiceChat,
        ),
      );
      await session.setActive(true);
    }

    _isRecorderInitialized = true;
    print('$TAG: Khởi tạo bộ ghi âm thành công');
  }

  /// Khởi tạo trình phát âm thanh
  static Future<void> initPlayer() async {
    if (Platform.isWindows) {
      print('$TAG: Không hỗ trợ phát âm thanh trên Windows. Bỏ qua khởi tạo.');
      _isPlayerInitialized = true; // Đánh dấu đã "khởi tạo" để tránh gọi lại
      return;
    }

    // Đảm bảo bất kỳ trình phát cũ nào được giải phóng
    await stopPlaying();

    try {
      print('$TAG: Sử dụng cách đơn giản để khởi tạo trình phát PCM');

      // Tạo instance trình phát mới - hoàn toàn theo cách đơn giản của ví dụ chính thức
      _pcmPlayer = FlutterPcmPlayer();
      await _pcmPlayer!.initialize();
      await _pcmPlayer!.play();

      _isPlayerInitialized = true;
      print('$TAG: Khởi tạo trình phát PCM thành công');
    } catch (e) {
      print('$TAG: Khởi tạo trình phát PCM thất bại: $e');
      _isPlayerInitialized = false;
    }
  }

  /// Phát dữ liệu âm thanh Opus
  static Future<void> playOpusData(Uint8List opusData) async {
    if (Platform.isWindows) {
      print(
        '$TAG: Không hỗ trợ phát âm thanh trên Windows. Bỏ qua phát dữ liệu Opus.',
      );
      return;
    }

    try {
      // Nếu trình phát chưa được khởi tạo, khởi tạo trước
      if (!_isPlayerInitialized || _pcmPlayer == null) {
        await initPlayer();
      }

      // Giải mã dữ liệu Opus
      final Int16List pcmData = _decoder.decode(input: opusData);

      // Chuẩn bị dữ liệu PCM (theo cách trực tiếp trong ví dụ)
      final Uint8List pcmBytes = Uint8List(pcmData.length * 2);
      ByteData bytes = ByteData.view(pcmBytes.buffer);

      // Sử dụng thứ tự byte little-endian
      for (int i = 0; i < pcmData.length; i++) {
        bytes.setInt16(i * 2, pcmData[i], Endian.little);
      }

      // Gửi trực tiếp đến trình phát
      if (_pcmPlayer != null) {
        await _pcmPlayer!.feed(pcmBytes);
      }
    } catch (e) {
      print('$TAG: Phát thất bại: $e');

      // Đơn giản reset và khởi tạo lại
      await stopPlaying();
      await initPlayer();
    }
  }

  /// Dừng phát
  static Future<void> stopPlaying() async {
    if (_pcmPlayer != null) {
      try {
        await _pcmPlayer!.stop();
        print('$TAG: Trình phát đã dừng');
      } catch (e) {
        print('$TAG: Dừng phát thất bại: $e');
      }
      _pcmPlayer = null;
      _isPlayerInitialized = false;
    }
  }

  /// Prepare player cho lần play đầu tiên bằng cách init rồi stop để reset trạng thái
  static Future<void> preparePlayerForFirstPlay() async {
    if (Platform.isWindows || _isPlayerPrepared) {
      return;
    }

    if (_isPlayerInitialized || _pcmPlayer != null) {
      await stopPlaying();
    }

    try {
      print('$TAG: Prepare player cho lần play đầu tiên');
      await initPlayer();
      await stopPlaying();  // Reset để lần play thực tế init mới, sạch sẽ
      _isPlayerPrepared = true;
      print('$TAG: Player đã được prepare (reset) cho lần play đầu tiên');
    } catch (e) {
      print('$TAG: Prepare player thất bại: $e');
      _isPlayerPrepared = false;
    }
  }

  /// Giải phóng tài nguyên
  static Future<void> dispose() async {
    _isPlayerPrepared = false;  // Reset flag khi dispose
    _audioStreamController.close();
    print('$TAG: Tài nguyên đã được giải phóng');
  }

  /// Bắt đầu ghi âm
  static Future<void> startRecording() async {
    if (!_isRecorderInitialized) {
      await initRecorder();
    }

    if (_isRecording) return;

    try {
      print('$TAG: Thử khởi động ghi âm');

      // Đảm bảo quyền micro đã được cấp - sử dụng cách khác để kiểm tra quyền
      final status = await Permission.microphone.status;
      print('$TAG: Trạng thái quyền micro: $status');

      if (status != PermissionStatus.granted) {
        final result = await Permission.microphone.request();
        print('$TAG: Kết quả yêu cầu quyền micro: $result');
        if (result != PermissionStatus.granted) {
          print('$TAG: Quyền micro bị từ chối');
          return;
        }
      }

      // Thử sử dụng trực tiếp luồng âm thanh
      try {
        print('$TAG: Thử khởi động ghi âm theo luồng');
        final stream = await _audioRecorder.startStream(
          const RecordConfig(
            encoder: AudioEncoder.pcm16bits,
            sampleRate: SAMPLE_RATE,
            numChannels: CHANNELS,
          ),
        );

        _isRecording = true;
        print('$TAG: Khởi động ghi âm theo luồng thành công');

        // Xử lý dữ liệu trực tiếp từ luồng
        stream.listen(
          (data) async {
            if (data.isNotEmpty && data.length % 2 == 0) {
              final opusData = await encodeToOpus(data);
              if (opusData != null) {
                _audioStreamController.add(opusData);
              }
            }
          },
          onError: (error) {
            print('$TAG: Lỗi luồng âm thanh: $error');
            _isRecording = false;
          },
          onDone: () {
            print('$TAG: Luồng âm thanh kết thúc');
            _isRecording = false;
          },
        );
      } catch (e) {
        print('$TAG: Ghi âm theo luồng thất bại: $e');
        _isRecording = false;
        rethrow;
      }
    } catch (e, stackTrace) {
      print('$TAG: Khởi động ghi âm thất bại: $e');
      print(stackTrace);
      _isRecording = false;
    }
  }

  /// Dừng ghi âm
  static Future<String?> stopRecording() async {
    if (!_isRecorderInitialized || !_isRecording) return null;

    // Hủy bộ đếm thời gian
    _audioProcessingTimer?.cancel();

    // Dừng ghi âm
    try {
      final path = await _audioRecorder.stop();
      _isRecording = false;
      print('$TAG: Dừng ghi âm: $path');
      return path;
    } catch (e) {
      print('$TAG: Dừng ghi âm thất bại: $e');
      _isRecording = false;
      return null;
    }
  }

  /// Mã hóa dữ liệu PCM thành định dạng Opus
  static Future<Uint8List?> encodeToOpus(Uint8List pcmData) async {
    try {
      // Xóa log thường xuyên
      // Chuyển đổi dữ liệu PCM thành Int16List (thứ tự byte little-endian, nhất quán với Android)
      final Int16List pcmInt16 = Int16List.fromList(
        List.generate(
          pcmData.length ~/ 2,
          (i) => (pcmData[i * 2]) | (pcmData[i * 2 + 1] << 8),
        ),
      );

      // Đảm bảo độ dài dữ liệu phù hợp với yêu cầu Opus (phải là số mẫu của 2.5ms, 5ms, 10ms, 20ms, 40ms hoặc 60ms)
      final int samplesPerFrame = (SAMPLE_RATE * FRAME_DURATION) ~/ 1000;

      Uint8List encoded;

      // Xử lý dữ liệu quá ngắn
      if (pcmInt16.length < samplesPerFrame) {
        // Đối với dữ liệu quá ngắn, có thể thêm âm im lặng để lấp đầy đến độ dài cần thiết
        final Int16List paddedData = Int16List(samplesPerFrame);
        for (int i = 0; i < pcmInt16.length; i++) {
          paddedData[i] = pcmInt16[i];
        }

        // Mã hóa dữ liệu sau khi lấp đầy
        encoded = Uint8List.fromList(_encoder.encode(input: paddedData));
      } else {
        // Đối với dữ liệu đủ dài, cắt đến độ dài khung chính xác
        encoded = Uint8List.fromList(
          _encoder.encode(input: pcmInt16.sublist(0, samplesPerFrame)),
        );
      }

      return encoded;
    } catch (e, stackTrace) {
      print('$TAG: Mã hóa Opus thất bại: $e');
      print(stackTrace);
      return null;
    }
  }

  /// Kiểm tra xem có đang ghi âm không
  static bool get isRecording => _isRecording;

  /// Kiểm tra xem có đang phát không
  static bool get isPlaying => _isPlaying;
}
