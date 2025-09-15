import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:ai_assistant/providers/theme_provider.dart';
import 'package:ai_assistant/providers/config_provider.dart';
import 'package:ai_assistant/providers/conversation_provider.dart';
import 'package:ai_assistant/screens/home_screen.dart';
import 'package:ai_assistant/screens/settings_screen.dart';
import 'package:ai_assistant/screens/test_screen.dart';
import 'package:ai_assistant/utils/app_theme.dart';
import 'package:opus_flutter/opus_flutter.dart' as opus_flutter;
import 'package:opus_dart/opus_dart.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:ui';
import 'package:ai_assistant/utils/audio_util.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

// Có kích hoạt công cụ debug không
const bool enableDebugTools = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Thiết lập thanh điều hướng toàn cục immersive
  await _setupSystemUI();

  // Thiết lập listener thay đổi màu trạng thái, đảm bảo style trạng thái luôn nhất quán
  SystemChannels.lifecycle.setMessageHandler((msg) async {
    if (msg == AppLifecycleState.resumed.toString()) {
      // Khi ứng dụng quay lại foreground, áp dụng lại thiết lập UI hệ thống
      await _setupSystemUI();
    }
    return null;
  });

  // Thiết lập render hiệu suất cao
  if (Platform.isAndroid || Platform.isIOS) {
    // Kích hoạt SkSL preheat, cải thiện hiệu suất render lần đầu
    await Future.delayed(const Duration(milliseconds: 50));
    PaintingBinding.instance.imageCache.maximumSize = 1000;
    // Tăng dung lượng cache hình ảnh
    PaintingBinding.instance.imageCache.maximumSizeBytes =
        100 * 1024 * 1024; // 100 MB
  }

  // Yêu cầu quyền ghi âm và lưu trữ
  await [
    Permission.microphone,
    Permission.storage,
    if (Platform.isAndroid) Permission.bluetoothConnect,
  ].request();

  // Thêm hỗ trợ localization tiếng Trung
  timeago.setLocaleMessages('zh', timeago.ZhMessages());
  timeago.setDefaultLocale('zh');

  // Thiết lập tần số quét cao trên Android
  if (Platform.isAndroid) {
    try {
      // Lấy tất cả mode hiển thị hỗ trợ
      final modes = await FlutterDisplayMode.supported;
      print('Các mode hiển thị hỗ trợ: ${modes.length}');
      modes.forEach((mode) => print('Mode: $mode'));

      // Lấy mode hiện tại đang active
      final current = await FlutterDisplayMode.active;
      print('Mode hiện tại: $current');

      // Thiết lập mode tần số quét cao
      await FlutterDisplayMode.setHighRefreshRate();

      // Xác nhận thiết lập thành công
      final afterSet = await FlutterDisplayMode.active;
      print('Mode sau thiết lập: $afterSet');
    } catch (e) {
      print('Thiết lập tần số quét cao thất bại: $e');
    }
  }

  // Khởi tạo thư viện Opus
  try {
    initOpus(await opus_flutter.load());
    print('Khởi tạo Opus thành công: ${getOpusVersion()}');
  } catch (e) {
    print('Khởi tạo Opus thất bại: $e');
  }

  // Khởi tạo recorder và player
  try {
    await AudioUtil.initRecorder();
    await AudioUtil.initPlayer();
    print('Khởi tạo hệ thống âm thanh thành công');
  } catch (e) {
    print('Khởi tạo hệ thống âm thanh thất bại: $e');
  }

  // Khởi tạo quản lý config
  final configProvider = ConfigProvider();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider.value(value: configProvider),
        ChangeNotifierProvider(create: (_) => ConversationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

// Thiết lập hiệu ứng immersive UI hệ thống
Future<void> _setupSystemUI() async {
  // Thiết lập trạng thái và navigation bar trong suốt
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );

  if (Platform.isAndroid) {
    // Kích hoạt mode hiển thị edge-to-edge, thực hiện full screen thực sự
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  } else if (Platform.isIOS) {
    // Trên iOS thiết lập full screen nhưng giữ trạng thái bar
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top],
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'AI-LHHT',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const HomeScreen(),
      routes: {
        // Thêm route cho màn hình test
        '/test': (context) => const TestScreen(),
      },
      // Thêm thiết lập cuộn mượt mà
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        // Kích hoạt cuộn vật lý
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        // Đảm bảo tất cả nền tảng có thanh cuộn và hiệu ứng đàn hồi
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
        },
      ),
    );
  }
}
