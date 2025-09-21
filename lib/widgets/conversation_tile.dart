import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:ai_assistant/models/conversation.dart';
import 'package:ai_assistant/models/xiaozhi_config.dart';
import 'package:ai_assistant/models/dify_config.dart';
import 'package:ai_assistant/providers/config_provider.dart';

class ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ConversationTile({
    super.key,
    required this.conversation,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          onLongPress: onLongPress,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _buildAvatar(),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    conversation.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                _buildTypeTag(context),
                              ],
                            ),
                          ),
                          Text(
                            _formatTime(conversation.lastMessageTime),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        conversation.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.grey.shade300,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeTag(BuildContext context) {
    final bool isDify = conversation.type == ConversationType.dify;
    String label = isDify ? 'Văn bản' : 'Giọng nói';

    // Nếu có ID cấu hình và không rỗng, thì hiển thị tên cấu hình
    if (conversation.configId.isNotEmpty) {
      final configProvider = Provider.of<ConfigProvider>(
        context,
        listen: false,
      );

      if (isDify) {
        // Thử tìm cấu hình Dify khớp
        final matchingConfig =
            configProvider.difyConfigs
                .where((config) => config.id == conversation.configId)
                .firstOrNull;
        if (matchingConfig != null) {
          label = '${matchingConfig.name}';
        }
      } else {
        // Thử tìm cấu hình Xiaozhi khớp
        final matchingConfig =
            configProvider.xiaozhiConfigs
                .where((config) => config.id == conversation.configId)
                .firstOrNull;
        if (matchingConfig != null) {
          label = '${matchingConfig.name}';
        }
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isDify ? Colors.blue.shade50 : Colors.purple.shade50,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: isDify ? Colors.blue.shade600 : Colors.purple.shade600,
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    if (conversation.type == ConversationType.dify) {
      return CircleAvatar(
        radius: 24,
        backgroundColor: Colors.blue.shade400,
        child: const Icon(
          Icons.chat_bubble_outline,
          color: Colors.white,
          size: 24,
        ),
      );
    } else {
      return CircleAvatar(
        radius: 24,
        backgroundColor: Colors.purple.shade400,
        child: const Icon(Icons.mic, color: Colors.white, size: 24),
      );
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0 && difference.inDays <= 1) {
      return 'Hôm qua';
    } else if (difference.inDays > 1 && difference.inDays <= 7) {
      return 'Thứ ${_getWeekday(dateTime.weekday)}';
    } else {
      // Khi đó hiển thị thời gian
      final hour = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }
  }

  String _getWeekday(int weekday) {
    switch (weekday) {
      case 1:
        return 'Hai';
      case 2:
        return 'Ba';
      case 3:
        return 'Tư';
      case 4:
        return 'Năm';
      case 5:
        return 'Sáu';
      case 6:
        return 'Bảy';
      case 7:
        return 'Chủ Nhật';
      default:
        return '';
    }
  }
}
