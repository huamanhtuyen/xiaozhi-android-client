# Tài liệu android-xiaozhi

Đây là trang web tài liệu của dự án android-xiaozhi, được xây dựng dựa trên VitePress.

## Chức năng

- Hướng dẫn dự án: Cung cấp hướng dẫn sử dụng chi tiết và tài liệu phát triển của dự án
- Trang nhà tài trợ: Hiển thị và cảm ơn tất cả các nhà tài trợ của dự án
- Hướng dẫn đóng góp: Giải thích cách đóng góp mã cho dự án
- Danh sách người đóng góp: Hiển thị tất cả các nhà phát triển đã đóng góp cho dự án
- Thiết kế responsive: Phù hợp với máy tính để bàn và thiết bị di động

## Phát triển cục bộ

```bash
# Cài đặt dependencies
pnpm install

# Khởi động server phát triển
pnpm docs:dev

# Xây dựng file tĩnh
pnpm docs:build

# Xem trước kết quả xây dựng
pnpm docs:preview
```

## Cấu trúc thư mục

```
documents/
├── docs/                  # File nguồn tài liệu
│   ├── .vitepress/        # Cấu hình VitePress
│   ├── guide/             # Tài liệu hướng dẫn
│   ├── sponsors/          # Trang nhà tài trợ
│   ├── contributing.md    # Hướng dẫn đóng góp
│   ├── contributors.md    # Danh sách người đóng góp
│   └── index.md           # Trang chủ
├── package.json           # Cấu hình dự án
└── README.md              # Giải thích dự án
```

## Trang nhà tài trợ

Trang nhà tài trợ được thực hiện qua các cách sau:

1. Thư mục `/sponsors/` chứa nội dung liên quan đến nhà tài trợ
2. File `data.json` lưu trữ dữ liệu nhà tài trợ
3. Sử dụng component Vue để render động danh sách nhà tài trợ ở phía client
4. Cung cấp hướng dẫn chi tiết để trở thành nhà tài trợ và các phương thức thanh toán

## Hướng dẫn đóng góp

Trang hướng dẫn đóng góp cung cấp các nội dung sau:

1. Hướng dẫn chuẩn bị môi trường phát triển
2. Giải thích quy trình đóng góp mã
3. Tiêu chuẩn mã hóa và tiêu chuẩn commit
4. Quy trình tạo và review Pull Request
5. Hướng dẫn đóng góp tài liệu

## Danh sách người đóng góp

Trang danh sách người đóng góp hiển thị tất cả các nhà phát triển đã đóng góp cho dự án, bao gồm:

1. Thành viên đội ngũ phát triển cốt lõi
2. Người đóng góp mã
3. Người đóng góp tài liệu
4. Người cung cấp test và phản hồi

## Triển khai

Trang web tài liệu được triển khai tự động đến GitHub Pages qua GitHub Actions.