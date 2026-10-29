# GreenTech K26 — Infrastructure Mini Project

> Repository mẫu cho bài thực hành nền tảng CNTT: quản trị log, chuẩn hóa tài liệu và đối soát thiết bị IoT.

## Mục tiêu

- Mô hình hóa luồng dữ liệu bằng **IPO** và chuyển dữ liệu thô thành quyết định theo **DIKW**.
- Tổ chức dự án theo 4 trụ cột: `docs/`, `scripts/`, `data/`, `backup/`.
- Lọc log lớn theo luồng bằng Pipe (`|`) và ghi nối báo cáo bằng `>>`.
- Chuẩn hóa tài liệu Markdown/Word bằng Heading Styles và mục lục tự động.
- Đối soát mã linh kiện bằng `TRIM` + `VLOOKUP(..., FALSE)`.

## Cấu trúc repository

```text
CNTT1_KienThucNenTangCNTT_MiniProject_GreenTech/
├── README.md
├── .env                  # cấu hình giả định; bị .gitignore loại khỏi Git
├── .env.example          # mẫu cấu hình không chứa bí mật
├── .gitignore
├── docs/
│   ├── README.md
│   └── srs-he-thong.docx
├── scripts/
│   ├── auto_report.bat
│   ├── auto_report.sh
│   └── init_structure.bat
├── data/
│   ├── log-he-thong.log
│   └── quan-ly-thiet-bi.xlsx
└── backup/
    └── bao-cao-su-co.txt
```

## Module 1 — Khởi tạo cấu trúc

**PowerShell — một dòng lệnh** (chạy tại thư mục cha của dự án):

```powershell
$root='greentech-system'; @('docs','scripts','data','backup') | ForEach-Object { New-Item -ItemType Directory -Force -Path (Join-Path $root $_) | Out-Null }; if (-not (Test-Path (Join-Path $root '.env'))) { New-Item -ItemType File -Path (Join-Path $root '.env') | Out-Null }
```

Hoặc, nếu đã giải nén repository này, mở CMD tại thư mục gốc và chạy:

```bat
scripts\init_structure.bat
```

Kiểm tra cây thư mục bằng `tree /F`. Đường dẫn trong các script được tính tương đối từ vị trí script, không phụ thuộc tên tài khoản Windows.

## Module 2 — Robot lọc log

### Windows

Mở CMD/PowerShell tại thư mục repository, chạy:

```bat
scripts\auto_report.bat
```

### Linux/macOS

```bash
bash scripts/auto_report.sh
```

Script lọc `CRITICAL`, `ERROR 404` và `TIMEOUT`, ghi thêm vào `backup/bao-cao-su-co.txt`. Pipe chuyển dữ liệu từng phần qua bộ lọc; script không đọc toàn bộ log vào biến RAM. Báo cáo cũ được giữ lại nhờ `>>`.

**Audit an toàn:** script chỉ kiểm tra đường dẫn đầu vào/đầu ra và ghi nối báo cáo; không thực hiện lệnh xóa. Không chạy `del /f /s /q` hoặc `rm -rf` nếu chưa xác minh chính xác đích và có bản sao lưu.

## Module 3 — Tài liệu vận hành

- `docs/README.md`: hướng dẫn ngắn, checklist và bảng thông số.
- `docs/srs-he-thong.docx`: tài liệu Word dùng `Heading 1`, `Heading 2`, `Heading 3` và trường mục lục tự động.
- Trong Word, khi nội dung thay đổi, nhấn `Ctrl+A`, sau đó `F9` để cập nhật mục lục và số trang.

## Module 4 — Đối soát tài nguyên

Mở `data/quan-ly-thiet-bi.xlsx`:

- Sheet `danh-muc-linh-kien`: danh mục linh kiện, khóa chính `ma_linh_kien`.
- Sheet `trang-thai-tram`: 100 trạm, khóa ngoại `ma_linh_kien`, RAM, ngày lắp đặt, CPU và cột `ten_thiet_bi` được tra cứu bằng công thức.
- Công thức mẫu:

```excel
=IFERROR(VLOOKUP(TRIM(B2),'danh-muc-linh-kien'!$A$2:$D$11,2,FALSE),"KIEM TRA MA")
```

`TRIM` xử lý khoảng trắng thừa trong mã đầu vào; `FALSE` yêu cầu khớp chính xác; `$` cố định vùng tra cứu khi sao chép công thức. Nếu hiện `KIEM TRA MA`, cần kiểm tra khóa ngoại thay vì bỏ qua lỗi.

## Bẫy dữ liệu và quy tắc vận hành

| Bẫy | Rủi ro | Cách xử lý |
|---|---|---|
| Tên có dấu/khoảng trắng | Script lỗi đường dẫn | Dùng kebab-case, không dấu |
| Dùng `>` | Ghi đè báo cáo cũ | Dùng `>>` khi cần nối |
| Lọc log trong trình soạn thảo | Tốn RAM với file lớn | Dùng Pipe + `findstr`/`grep` |
| Mã có khoảng trắng | `VLOOKUP` không khớp | `TRIM` trước khi tra cứu |
| Hàng trống / Merge Cell | AutoFilter, đối soát khó ổn định | Giữ vùng dữ liệu liền mạch, không gộp ô |
| Lộ `.env` | Lộ cấu hình | `.gitignore` loại `.env`; chỉ commit `.env.example` |
| Nhầm Mbps với MB/s | Ước lượng thời gian sai | `MB/s ≈ Mbps ÷ 8`; thời gian (s) ≈ dung lượng (MB) ÷ tốc độ (MB/s) |

## Bảo mật khi đưa lên GitHub

`.env` trong gói ZIP chỉ chứa giá trị **giả định** để minh họa. `.gitignore` loại `.env` khỏi Git. Trước khi `git add`, chạy `git status --ignored` và xác nhận không đưa cấu hình thật hoặc tệp nhạy cảm lên repository công khai.
