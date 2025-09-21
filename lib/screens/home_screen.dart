import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ai_assistant/providers/conversation_provider.dart';
import 'package:ai_assistant/providers/config_provider.dart';
import 'package:ai_assistant/models/conversation.dart';
import 'package:ai_assistant/screens/settings_screen.dart';
import 'package:ai_assistant/screens/conversation_type_screen.dart';
import 'package:ai_assistant/screens/voice_call_screen.dart';
import 'package:ai_assistant/widgets/conversation_tile.dart';
import 'package:ai_assistant/widgets/slidable_delete_tile.dart';
import 'package:ai_assistant/widgets/discovery_screen.dart';
import 'package:flutter/rendering.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final FocusNode _searchFocusNode = FocusNode();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Khi nhấp vào bất kỳ vị trí nào trên trang, làm cho ô tìm kiếm mất focus
        _searchFocusNode.unfocus();
        // Đồng thời đóng tất cả các nút xóa đang mở
        SlidableController.instance.closeCurrentTile();
      },
      child: Scaffold(
        key: _scaffoldMessengerKey,
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: const Color(0xFFF8F9FA),
        appBar:
            _selectedIndex == 1
                ? null
                : AppBar(
                  title: const Text(
                    'Tin nhắn',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Colors.black,
                    ),
                  ),
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  backgroundColor: const Color(0xFFF8F9FA),
                  centerTitle: false,
                  titleSpacing: 20,
                  toolbarHeight: 65,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          splashColor: Colors.grey.withOpacity(0.1),
                          highlightColor: Colors.grey.withOpacity(0.1),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SettingsScreen(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Icon(
                              Icons.settings,
                              size: 26,
                              color: Colors.grey.shade700,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 0.5,
                                  offset: const Offset(0, 0.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        body:
            _selectedIndex == 1
                ? const SafeArea(bottom: false, child: DiscoveryScreen())
                : SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      _buildSearchBar(),
                      Expanded(child: _buildBody()),
                    ],
                  ),
                ),
        floatingActionButton:
            _selectedIndex == 0
                ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 0,
                        offset: const Offset(0, 4),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: -2,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: FloatingActionButton(
                    onPressed: () async {
                      final configProvider = Provider.of<ConfigProvider>(context, listen: false);
                      final xiaozhiConfigs = configProvider.xiaozhiConfigs;

                      if (xiaozhiConfigs.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Vui lòng thêm cấu hình dịch vụ Xiaozhi trong cài đặt trước')),
                        );
                        return;
                      }

                      final conversationProvider = Provider.of<ConversationProvider>(context, listen: false);
                      final conversation = await conversationProvider.createConversation(
                        title: 'Cuộc gọi thoại với ${xiaozhiConfigs.first.name}',
                        type: ConversationType.xiaozhi,
                        configId: xiaozhiConfigs.first.id,
                      );

                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VoiceCallScreen(
                              conversation: conversation,
                              xiaozhiConfig: xiaozhiConfigs.first,
                            ),
                          ),
                        );
                      }
                    },
                    backgroundColor: Colors.black,
                    child: const Icon(Icons.add, size: 30, color: Colors.white),
                    elevation: 0,
                    shape: const CircleBorder(),
                  ),
                )
                : null,
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: Theme(
            data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom / 2,
                ),
                child: BottomNavigationBar(
                  currentIndex: _selectedIndex,
                  onTap: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  selectedItemColor: Colors.black,
                  unselectedItemColor: Colors.grey.shade600,
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  type: BottomNavigationBarType.fixed,
                  selectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                  iconSize: 26,
                  items: [
                    BottomNavigationBarItem(
                      icon: Material(
                        color: Colors.transparent,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color:
                                _selectedIndex == 0
                                    ? Colors.grey.shade100
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow:
                                _selectedIndex == 0
                                    ? [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 4,
                                        spreadRadius: 0,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                    : null,
                          ),
                          child: Icon(
                            _selectedIndex == 0
                                ? Icons.chat_bubble
                                : Icons.chat_bubble_outline,
                          ),
                        ),
                      ),
                      label: 'Tin nhắn',
                    ),
                    BottomNavigationBarItem(
                      icon: Material(
                        color: Colors.transparent,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color:
                                _selectedIndex == 1
                                    ? Colors.grey.shade100
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow:
                                _selectedIndex == 1
                                    ? [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 4,
                                        spreadRadius: 0,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                    : null,
                          ),
                          child: Icon(
                            _selectedIndex == 1
                                ? Icons.search
                                : Icons.search_outlined,
                          ),
                        ),
                      ),
                      label: 'Khám phá',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    if (_selectedIndex == 1) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.white,
          child: TextField(
            focusNode: _searchFocusNode,
            decoration: InputDecoration(
              hintText: 'Tìm kiếm cuộc trò chuyện',
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
              prefixIcon: Container(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  Icons.search,
                  color: Colors.grey.shade500,
                  size: 22,
                ),
              ),
              suffixIcon: Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(right: 4),
                child: Icon(
                  Icons.mic_none_outlined,
                  color: Colors.grey.shade500,
                  size: 22,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              focusColor: Colors.white,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    // Messages tab
    return Consumer<ConversationProvider>(
      builder: (context, provider, child) {
        final pinnedConversations = provider.pinnedConversations;
        final unpinnedConversations = provider.unpinnedConversations;

        return ListView(
          padding: EdgeInsets.only(
            bottom: 16 + MediaQuery.of(context).padding.bottom,
          ),
          children: [
            if (pinnedConversations.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 8,
                  bottom: 8,
                ),
                child: Text(
                  'Cuộc trò chuyện được ghim',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                    fontSize: 15,
                    shadows: [
                      Shadow(
                        color: Color(0x40000000),
                        blurRadius: 0.5,
                        offset: Offset(0, 0.5),
                      ),
                    ],
                  ),
                ),
              ),
              ...pinnedConversations.map(
                (conversation) => _buildConversationTile(conversation),
              ),
            ],

            if (unpinnedConversations.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: pinnedConversations.isEmpty ? 8 : 16,
                  bottom: 8,
                ),
                child: const Text(
                  'Tất cả cuộc trò chuyện',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                    fontSize: 15,
                    shadows: [
                      Shadow(
                        color: Color(0x40000000),
                        blurRadius: 0.5,
                        offset: Offset(0, 0.5),
                      ),
                    ],
                  ),
                ),
              ),
              ...unpinnedConversations.map(
                (conversation) => _buildConversationTile(conversation),
              ),
            ],

            if (pinnedConversations.isEmpty && unpinnedConversations.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(64.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              spreadRadius: 0,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.chat_bubble_outline,
                          size: 48,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Không có cuộc trò chuyện',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade500,
                          shadows: const [
                            Shadow(
                              color: Color(0x40000000),
                              blurRadius: 0.5,
                              offset: Offset(0, 0.5),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 5,
                              spreadRadius: 0,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add_circle_outline,
                              size: 18,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Nhấp vào + để tạo cuộc trò chuyện mới',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildConversationTile(Conversation conversation) {
    return SlidableDeleteTile(
      key: Key(conversation.id),
      onDelete: () {
        // Xóa cuộc trò chuyện
        Provider.of<ConversationProvider>(
          context,
          listen: false,
        ).deleteConversation(conversation.id);

        // Hiển thị thông báo hoàn tác
        _scaffoldMessengerKey.currentState?.clearSnackBars();
        _scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text('${conversation.title} đã bị xóa'),
            backgroundColor: Colors.grey.shade800,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
            margin: EdgeInsets.only(
              bottom: 20 + MediaQuery.of(context).padding.bottom,
              left: 20,
              right: 20
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            action: SnackBarAction(
              label: 'Hoàn tác',
              textColor: Colors.white,
              onPressed: () {
                // Khôi phục cuộc trò chuyện đã bị xóa
                Provider.of<ConversationProvider>(
                  context,
                  listen: false,
                ).restoreLastDeletedConversation();
              },
            ),
          ),
        );
      },
      onTap: () {
        // Điều hướng trực tiếp đến màn hình voice call
        final configProvider = Provider.of<ConfigProvider>(context, listen: false);
        final xiaozhiConfig = configProvider.xiaozhiConfigs.firstWhere(
          (config) => config.id == conversation.configId,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VoiceCallScreen(
              conversation: conversation,
              xiaozhiConfig: xiaozhiConfig,
            ),
          ),
        );
      },
      onLongPress: () {
        // Hiển thị các tùy chọn như ghim trên cùng
        _showConversationOptions(conversation);
      },
      child: ConversationTile(
        conversation: conversation,
        onTap: null, // Không cần xử lý click nữa
        onLongPress: null, // Không cần xử lý nhấn dài nữa
      ),
    );
  }

  void _showConversationOptions(Conversation conversation) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      elevation: 20,
      barrierColor: Colors.black.withOpacity(0.5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 5,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 1,
                      spreadRadius: 0,
                      offset: const Offset(0, 0.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        spreadRadius: 0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 4,
                      ),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 4,
                              spreadRadius: 0,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          conversation.isPinned
                              ? Icons.push_pin
                              : Icons.push_pin_outlined,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                      title: Text(
                        conversation.isPinned
                            ? 'Bỏ ghim'
                            : 'Ghim cuộc trò chuyện',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Provider.of<ConversationProvider>(
                          context,
                          listen: false,
                        ).togglePinConversation(conversation.id);
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        spreadRadius: 0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 4,
                      ),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.1),
                              blurRadius: 4,
                              spreadRadius: 0,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 24,
                        ),
                      ),
                      title: const Text(
                        'Xóa cuộc trò chuyện',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Provider.of<ConversationProvider>(
                          context,
                          listen: false,
                        ).deleteConversation(conversation.id);
                        _scaffoldMessengerKey.currentState?.showSnackBar(
                          SnackBar(
                            content: Text('${conversation.title} đã bị xóa'),
                            backgroundColor: Colors.grey.shade800,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.only(
                              bottom: 20 + MediaQuery.of(context).padding.bottom,
                              left: 20,
                              right: 20
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
