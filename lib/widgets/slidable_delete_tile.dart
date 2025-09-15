import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Quản lý trạng thái toàn cục, đảm bảo chỉ có một nút xóa mở cùng lúc
class SlidableController {
  static SlidableController? _instance;

  static SlidableController get instance {
    _instance ??= SlidableController._();
    return _instance!;
  }

  SlidableController._();

  // Mục hiện tại đang mở
  _SlidableDeleteTileState? _currentOpenTile;

  // Thiết lập mục hiện tại đang mở
  void setCurrentOpenTile(_SlidableDeleteTileState tile) {
    // Nếu đã có mục khác đang mở, đóng nó trước
    if (_currentOpenTile != null && _currentOpenTile != tile) {
      _currentOpenTile!._resetPosition();
    }
    _currentOpenTile = tile;
  }

  // Đóng mục hiện tại đang mở
  void closeCurrentTile() {
    _currentOpenTile?._resetPosition();
    _currentOpenTile = null;
  }
}

class SlidableDeleteTile extends StatefulWidget {
  final Widget child;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final Key? itemKey;

  const SlidableDeleteTile({
    super.key,
    required this.child,
    required this.onDelete,
    required this.onTap,
    required this.onLongPress,
    this.itemKey,
  });

  @override
  State<SlidableDeleteTile> createState() => _SlidableDeleteTileState();
}

class _SlidableDeleteTileState extends State<SlidableDeleteTile> {
  // Vị trí trượt
  double _dragExtent = 0.0;
  // Có mở nút xóa chưa
  bool _isOpen = false;
  // Chiều rộng nút xóa
  final double _deleteButtonWidth = 80.0;
  // Ngưỡng kéo, vượt quá tỷ lệ này sẽ tự động mở
  final double _openThreshold = 0.3;

  @override
  void dispose() {
    // Nếu mục hiện tại đang mở là cái này, xóa tham chiếu
    if (SlidableController.instance._currentOpenTile == this) {
      SlidableController.instance._currentOpenTile = null;
    }
    super.dispose();
  }

  // Đặt lại trạng thái trượt
  void _resetPosition() {
    if (!mounted) return;
    setState(() {
      _isOpen = false;
      _dragExtent = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Xây dựng nút xóa - Icon thùng rác thực tế
    final deleteButton = Container(
      width: _deleteButtonWidth,
      height: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            // Phản hồi rung
            HapticFeedback.mediumImpact();
            // Thực hiện callback xóa
            widget.onDelete();
            // Đặt lại trạng thái
            _resetPosition();
            // Xóa tham chiếu mục hiện tại đang mở
            SlidableController.instance._currentOpenTile = null;
          },
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 4,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: -2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.delete_outline_rounded,
                color: Colors.red.shade600,
                size: 26,
              ),
            ),
          ),
        ),
      ),
    );

    return Stack(
      children: [
        // Nền trượt (vùng nút xóa)
        Positioned.fill(
          child: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: (_dragExtent.abs() / _deleteButtonWidth).clamp(0.0, 1.0),
              child: deleteButton,
            ),
          ),
        ),

        // Nội dung có thể trượt - Sử dụng GestureDetector để trượt ngang
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragStart: (_) {
            // Bắt đầu kéo, đóng các mục khác đang mở
            SlidableController.instance.closeCurrentTile();
          },
          onHorizontalDragUpdate: (details) {
            setState(() {
              // Cập nhật vị trí trượt
              _dragExtent += details.delta.dx;
              // Giới hạn phạm vi
              _dragExtent = _dragExtent.clamp(-_deleteButtonWidth, 0.0);
            });
          },
          onHorizontalDragEnd: (details) {
            // Dựa trên tốc độ và khoảng cách trượt để quyết định có mở nút xóa không
            final velocity = details.velocity.pixelsPerSecond.dx;

            // Trượt sang phải nhanh, hoặc gần vị trí gốc, thì đóng
            if (velocity > 300 ||
                _dragExtent > -_deleteButtonWidth * _openThreshold) {
              _resetPosition();
              SlidableController.instance._currentOpenTile = null;
            }
            // Trượt sang trái nhanh, hoặc gần mở hoàn toàn, thì mở
            else if (velocity < -300 ||
                _dragExtent.abs() >= _deleteButtonWidth * _openThreshold) {
              // Mở nút xóa
              setState(() {
                _isOpen = true;
                _dragExtent = -_deleteButtonWidth;
              });
              // Ghi lại mục hiện tại đang mở
              SlidableController.instance.setCurrentOpenTile(this);
              // Phản hồi rung
              HapticFeedback.lightImpact();
            }
            // Các trường hợp khác, giữ nguyên
            else if (_isOpen) {
              setState(() {
                _dragExtent = -_deleteButtonWidth;
              });
            } else {
              _resetPosition();
            }
          },
          onTap:
              _isOpen
                  ? () {
                    // Nếu nút xóa đang mở, click vào vùng nội dung để đóng nó
                    _resetPosition();
                    SlidableController.instance._currentOpenTile = null;
                  }
                  : widget.onTap,
          onLongPress: _isOpen ? null : widget.onLongPress,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOutCubic,
            transform: Matrix4.translationValues(_dragExtent, 0.0, 0.0),
            child: widget.child,
          ),
        ),

        // Thêm một vùng xử lý click bổ sung, đảm bảo nút xóa có thể click
        if (_isOpen)
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            width: _deleteButtonWidth,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                // Phản hồi rung
                HapticFeedback.mediumImpact();
                // Thực hiện callback xóa
                widget.onDelete();
                // Đặt lại trạng thái
                _resetPosition();
                // Xóa tham chiếu mục hiện tại đang mở
                SlidableController.instance._currentOpenTile = null;
              },
              child: Container(color: Colors.transparent),
            ),
          ),
      ],
    );
  }
}
