---
title: Hướng Dẫn Đóng Góp
description: Cách đóng góp mã nguồn cho dự án android-xiaozhi
sidebar: false
outline: deep
---

<div class="contributing-page">

# Hướng Dẫn Đóng Góp

<div class="header-content">
  <h2>Cách đóng góp mã nguồn cho dự án android-xiaozhi 🚀</h2>
</div>

## Lời Mở Đầu

Cảm ơn bạn đã quan tâm đến dự án android-xiaozhi! Chúng tôi rất hoan nghênh các thành viên cộng đồng tham gia đóng góp, dù là sửa lỗi, cải thiện tài liệu hay thêm tính năng mới. Hướng dẫn này sẽ giúp bạn hiểu cách đóng góp cho dự án.

## Chuẩn Bị Môi Trường Phát Triển

### Yêu Cầu Cơ Bản

- Flutter SDK 3.7.0 hoặc cao hơn
- Dart SDK 3.7.0 hoặc cao hơn
- Hệ thống kiểm soát phiên bản Git
- Android Studio hoặc Visual Studio Code (với plugin Flutter)
- Android SDK (dùng cho phát triển Android)
- Xcode (dùng cho phát triển iOS, chỉ trên macOS)

### Lấy Mã Nguồn

1. Trước tiên, Fork dự án trên GitHub vào tài khoản của bạn
   - Truy cập [trang dự án android-xiaozhi](https://github.com/TOM88812/xiaozhi-android-client)
   - Nhấp vào nút "Fork" ở góc trên bên phải
   - Chờ Fork hoàn tất, bạn sẽ được chuyển hướng đến bản sao kho lưu trữ của mình

2. Clone kho lưu trữ đã fork của bạn về máy cục bộ:

```bash
git clone https://github.com/YOUR_USERNAME/xiaozhi-android-client.git
cd xiaozhi-android-client
```

3. Thêm kho lưu trữ upstream làm nguồn từ xa:

```bash
git remote add upstream https://github.com/TOM88812/xiaozhi-android-client.git
```

Bạn có thể sử dụng lệnh `git remote -v` để xác nhận kho lưu trữ từ xa đã được cấu hình đúng:

```bash
git remote -v
# Nên hiển thị:
# origin    https://github.com/YOUR_USERNAME/xiaozhi-android-client.git (fetch)
# origin    https://github.com/YOUR_USERNAME/xiaozhi-android-client.git (push)
# upstream  https://github.com/TOM88812/xiaozhi-android-client.git (fetch)
# upstream  https://github.com/TOM88812/xiaozhi-android-client.git (push)
```

### Cài Đặt Phụ Thuộc Phát Triển

```bash
# Cài đặt phụ thuộc Flutter
flutter pub get
```

## Quy Trình Phát Triển

### Đồng Bộ Với Kho Lưu Trữ Chính

Trước khi bắt đầu làm việc, việc đảm bảo kho lưu trữ cục bộ của bạn đồng bộ với dự án chính là rất quan trọng. Dưới đây là các bước đồng bộ kho lưu trữ cục bộ:

1. Chuyển sang nhánh chính (`main`):

```bash
git checkout main
```

2. Kéo các thay đổi mới nhất từ kho lưu trữ upstream:

```bash
git fetch upstream
```

3. Hợp nhất các thay đổi từ nhánh chính upstream vào nhánh chính cục bộ của bạn:

```bash
git merge upstream/main
```

4. Đẩy nhánh chính cục bộ đã cập nhật lên kho lưu trữ GitHub của bạn:

```bash
git push origin main
```

### Tạo Nhánh

Trước khi bắt đầu bất kỳ công việc nào, hãy đảm bảo tạo nhánh mới từ nhánh chính upstream mới nhất:

```bash
# Lấy mã upstream mới nhất (như phần trên)
git fetch upstream
git checkout -b feature/your-feature-name upstream/main
```

Khi đặt tên nhánh, bạn có thể tuân theo các quy ước sau:
- `feature/xxx`: Phát triển tính năng mới
- `fix/xxx`: Sửa lỗi
- `docs/xxx`: Cập nhật tài liệu
- `test/xxx`: Công việc liên quan đến kiểm thử
- `refactor/xxx`: Tái cấu trúc mã

### Quy Tắc Mã Hóa

Chúng tôi sử dụng hướng dẫn phong cách mã được khuyến nghị chính thức của Flutter. Trước khi gửi mã, hãy đảm bảo mã của bạn tuân thủ các yêu cầu sau:

- Sử dụng 2 khoảng trắng để thụt lề
- Độ dài dòng không vượt quá 120 ký tự
- Sử dụng tên biến và hàm có ý nghĩa
- Thêm chú thích tài liệu cho API công khai
- Sử dụng hệ thống kiểu Dart

Chúng tôi khuyến nghị sử dụng công cụ phân tích mã tĩnh của Flutter để giúp bạn tuân thủ quy tắc mã hóa:

```bash
# Sử dụng dart analyze để kiểm tra mã
flutter analyze
```

### Kiểm Thử

Trước khi gửi, hãy đảm bảo tất cả các kiểm thử đều vượt qua:

```bash
flutter test
```

## Gửi Thay Đổi

### Danh Sách Kiểm Tra Trước Khi Gửi

Trước khi gửi mã của bạn, hãy đảm bảo hoàn thành các kiểm tra sau:

1. Mã có tuân thủ quy tắc mã hóa Flutter không
2. Có thêm các trường hợp kiểm thử cần thiết không
3. Tất cả các kiểm thử có vượt qua không
4. Có thêm tài liệu phù hợp không
5. Có giải quyết vấn đề bạn dự định không
6. Có đồng bộ với mã upstream mới nhất không

### Gửi Thay Đổi

Trong quá trình phát triển, hãy hình thành thói quen gửi nhỏ lẻ, thường xuyên. Điều này làm cho các thay đổi của bạn dễ theo dõi và hiểu hơn:

```bash
# Xem các file đã thay đổi
git status

# Tạm lưu thay đổi
git add lib/feature.dart test/feature_test.dart

# Gửi thay đổi
git commit -m "feat: add new feature X"
```

### Giải Quyết Xung Đột

Nếu bạn gặp xung đột khi cố gắng hợp nhất thay đổi upstream, hãy giải quyết theo các bước sau:

1. Trước tiên, hiểu vị trí xung đột:

```bash
git status
```

2. Mở file xung đột, bạn sẽ thấy các dấu hiệu tương tự như sau:

```
Mã upstream
```

3. Sửa đổi file để giải quyết xung đột, xóa các dấu hiệu xung đột
4. Sau khi giải quyết tất cả xung đột, tạm lưu và gửi:

```bash
git add .
git commit -m "fix: resolve merge conflicts"
```

### Quy Tắc Gửi

Chúng tôi sử dụng [quy ước gửi](https://www.conventionalcommits.org/zh-hans/) để định dạng thông điệp Git commit. Thông điệp gửi nên tuân theo định dạng sau:

```
<loại>[phạm vi tùy chọn]: <mô tả>

[thân tùy chọn]

[chú thích tùy chọn]
```

Các loại gửi phổ biến bao gồm:
- `feat`: Tính năng mới
- `fix`: Sửa lỗi
- `docs`: Thay đổi tài liệu
- `style`: Thay đổi không ảnh hưởng đến ý nghĩa mã (như khoảng trắng, định dạng, v.v.)
- `refactor`: Tái cấu trúc mã không sửa lỗi cũng không thêm tính năng
- `perf`: Thay đổi mã cải thiện hiệu suất
- `test`: Thêm hoặc sửa kiểm thử
- `chore`: Thay đổi đối với quá trình xây dựng hoặc công cụ hỗ trợ và thư viện

Ví dụ:

```
feat(tts): Thêm hỗ trợ engine tổng hợp giọng nói mới

Thêm hỗ trợ API tổng hợp giọng nói Baidu, bao gồm các chức năng sau:
- Hỗ trợ chọn nhiều giọng nói
- Hỗ trợ điều chỉnh tốc độ và âm lượng
- Hỗ trợ tổng hợp tiếng Trung và tiếng Anh hỗn hợp

Sửa #123
```

### Đẩy Thay Đổi

Sau khi hoàn thành thay đổi mã, đẩy nhánh của bạn lên kho lưu trữ GitHub:

```bash
git push origin feature/your-feature-name
```

Nếu bạn đã tạo Pull Request và cần cập nhật nó, chỉ cần đẩy lại lên cùng nhánh:

```bash
# Sau khi thực hiện thêm thay đổi
git add .
git commit -m "refactor: improve code based on feedback"
git push origin feature/your-feature-name
```

### Đồng Bộ Mã Mới Nhất Trước Khi Tạo Pull Request

Trước khi tạo Pull Request, khuyến nghị đồng bộ lại với kho lưu trữ upstream để tránh xung đột tiềm ẩn:

```bash
# Lấy mã upstream mới nhất
git fetch upstream

# Rebase mã upstream mới nhất lên nhánh tính năng của bạn
git rebase upstream/main

# Nếu có xung đột, giải quyết xung đột và tiếp tục rebase
git add .
git rebase --continue

# Đẩy cưỡng chế nhánh đã cập nhật lên kho lưu trữ của bạn
git push --force-with-lease origin feature/your-feature-name
```

Lưu ý: Sử dụng `--force-with-lease` an toàn hơn `--force`, nó có thể ngăn chặn việc ghi đè thay đổi của người khác.

### Tạo Pull Request

Khi bạn hoàn thành phát triển tính năng hoặc sửa lỗi, hãy tạo Pull Request theo các bước sau:

1. Đẩy thay đổi của bạn lên GitHub:

```bash
git push origin feature/your-feature-name
```

2. Truy cập trang kho lưu trữ fork của bạn trên GitHub, nhấp vào nút "Compare & pull request"

3. Điền form Pull Request:
   - Sử dụng tiêu đề rõ ràng, tuân theo định dạng thông điệp gửi
   - Cung cấp chi tiết trong mô tả
   - Trích dẫn issue liên quan (sử dụng định dạng `#số-issue`)
   - Nếu đây là công việc đang tiến hành, thêm tiền tố `[WIP]` vào tiêu đề

4. Gửi Pull Request, chờ người duy trì dự án xem xét

### Chu Kỳ Đời Sống Pull Request

1. **Tạo**: Gửi PR của bạn
2. **Kiểm Tra CI**: Kiểm thử tự động và kiểm tra phong cách mã
3. **Xem Xét Mã**: Người duy trì sẽ xem xét mã của bạn và cung cấp phản hồi
4. **Sửa Đổi**: Sửa mã theo phản hồi
5. **Phê Duyệt**: Một khi PR của bạn được phê duyệt
6. **Hợp Nhất**: Người duy trì sẽ hợp nhất PR của bạn vào nhánh chính

## Đóng Góp Tài Liệu

Nếu bạn muốn cải thiện tài liệu dự án, hãy làm theo các bước sau:

1. Fork dự án và clone về cục bộ theo các bước trên

2. Tài liệu nằm trong thư mục `documents/docs`, sử dụng định dạng Markdown

3. Cài đặt phụ thuộc phát triển tài liệu:

```bash
cd documents
pnpm install
```

4. Khởi động máy chủ tài liệu cục bộ:

```bash
pnpm docs:dev
```

5. Truy cập `http://localhost:5173/xiaozhi-android/` trong trình duyệt để xem trước thay đổi của bạn

6. Sau khi hoàn thành thay đổi, gửi đóng góp và tạo Pull Request

### Hướng Dẫn Viết Tài Liệu

- Sử dụng ngôn ngữ rõ ràng, ngắn gọn
- Cung cấp ví dụ thực tế
- Giải thích chi tiết các khái niệm phức tạp
- Bao gồm ảnh chụp màn hình hoặc biểu đồ phù hợp (nếu cần)
- Tránh sử dụng quá nhiều thuật ngữ kỹ thuật, giải thích nếu cần
- Giữ cấu trúc tài liệu nhất quán

## Phản Hồi Vấn Đề

Nếu bạn phát hiện vấn đề nhưng tạm thời không thể sửa, hãy [tạo Issue trên GitHub](https://github.com/TOM88812/xiaozhi-android-client/issues/new). Khi tạo Issue, hãy bao gồm thông tin sau:

- Mô tả chi tiết vấn đề
- Các bước tái hiện vấn đề
- Hành vi mong đợi và hành vi thực tế
- Hệ điều hành và phiên bản Dart của bạn
- Đầu ra nhật ký liên quan hoặc thông tin lỗi

## Xem Xét Mã

Sau khi gửi Pull Request, người duy trì dự án sẽ xem xét mã của bạn. Trong quá trình xem xét mã:

- Hãy kiên nhẫn chờ phản hồi
- Phản hồi kịp thời các bình luận và gợi ý
- Thực hiện sửa đổi nếu cần và cập nhật Pull Request của bạn
- Giữ thái độ lịch sự và xây dựng trong thảo luận

### Xử Lý Phản Hồi Xem Xét Mã

1. Đọc kỹ tất cả bình luận và gợi ý
2. Phản hồi hoặc thay đổi cho từng điểm
3. Nếu bạn không đồng ý với gợi ý nào đó, hãy giải thích lý do một cách lịch sự
4. Sau khi sửa đổi hoàn tất, gửi tin nhắn trong PR để thông báo cho người xem xét

## Trở Thành Người Duy Trì Dự Án

Nếu bạn liên tục đóng góp giá trị cho dự án, bạn có thể được mời trở thành người duy trì dự án. Là người duy trì, bạn sẽ có quyền xem xét và hợp nhất Pull Request của người khác.

### Trách Nhiệm Của Người Duy Trì

- Xem xét Pull Request
- Quản lý issue
- Tham gia lập kế hoạch dự án
- Trả lời câu hỏi cộng đồng
- Hướng dẫn người đóng góp mới

## Quy Tắc Hành Vi

Hãy tôn trọng tất cả người tham gia dự án, tuân theo quy tắc hành vi sau:

- Sử dụng ngôn ngữ hòa nhập
- Tôn trọng các quan điểm và kinh nghiệm khác nhau
- Chấp nhận phê bình xây dựng một cách lịch sự
- Tập trung vào lợi ích tốt nhất của cộng đồng
- Thể hiện sự đồng cảm với các thành viên cộng đồng khác

## Câu Hỏi Thường Gặp

### Tôi nên bắt đầu đóng góp từ đâu?

1. Xem các vấn đề được đánh dấu "good first issue"
2. Sửa lỗi hoặc phần không rõ ràng trong tài liệu
3. Thêm nhiều trường hợp kiểm thử hơn
4. Giải quyết vấn đề bạn phát hiện khi sử dụng

### PR của tôi đã lâu không có phản hồi, tôi phải làm sao?

Gửi tin nhắn trong PR, lịch sự hỏi xem có cần cải thiện hoặc làm rõ thêm không. Hãy hiểu rằng người duy trì có thể bận rộn và cần thời gian để xem xét đóng góp của bạn.

### Tôi có thể đóng góp loại thay đổi nào?

- Sửa lỗi
- Tính năng mới
- Cải thiện hiệu suất
- Cập nhật tài liệu
- Trường hợp kiểm thử
- Tái cấu trúc mã

## Lời Cảm Ơn

Một lần nữa, cảm ơn bạn đã đóng góp cho dự án! Sự tham gia của bạn rất quan trọng đối với chúng tôi, cùng nhau làm cho android-xiaozhi tốt hơn!

</div>

<style>
.contributing-page {
  max-width: 900px;
  margin: 0 auto;
  padding: 2rem 1.5rem;
}

.contributing-page h1 {
  text-align: center;
  margin-bottom: 1rem;
}

.header-content {
  text-align: center;
}

.header-content h2 {
  color: var(--vp-c-brand);
  margin-bottom: 1rem;
}

.contributing-page h2 {
  margin-top: 3rem;
  padding-top: 1rem;
  border-top: 1px solid var(--vp-c-divider);
}

.contributing-page h3 {
  margin-top: 2rem;
}

.contributing-page code {
  background-color: var(--vp-c-bg-soft);
  padding: 0.2em 0.4em;
  border-radius: 3px;
}

.contributing-page pre {
  margin: 1rem 0;
  border-radius: 8px;
  overflow: auto;
}
</style>