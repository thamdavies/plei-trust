# Pawnify Dashboard

Giao diện dashboard mẫu cho cửa hàng cầm đồ, giúp theo dõi nhanh tình hình tài chính và hợp đồng. Dự án ưu tiên bố cục dễ đọc trên desktop lẫn mobile, hỗ trợ giao diện sáng/tối và dùng dữ liệu mẫu để trải nghiệm các thao tác cơ bản.

## Tính năng

- Tổng quan quỹ tiền mặt, số hợp đồng, dư nợ và lãi đã thu.
- Biểu đồ thu chi và cơ cấu hợp đồng.
- Tìm kiếm hợp đồng, xem danh sách và thêm hợp đồng mẫu.
- Chuyển giao diện sáng/tối; lựa chọn được lưu trong trình duyệt.
- Điều hướng các mục tổng quan, hợp đồng, khách hàng, tài chính và báo cáo.
- Giao diện responsive cho màn hình nhỏ.

> Đây là frontend demo chạy độc lập. Frontend chưa gọi API backend; dữ liệu hợp đồng đang được lưu trong Pinia ở bộ nhớ ứng dụng.

## Backend API

Backend dùng Rails 8.1 API-only, PostgreSQL 18 trong Docker Compose và UUIDv7 được sinh từ PostgreSQL. Giai đoạn khởi tạo có health check, đăng nhập admin `admin`, bearer token có thể thu hồi và danh mục phân quyền được seed; endpoint nghiệp vụ cầm đồ để cho phase sau.

```bash
cp backend/.env.example backend/.env
docker compose up -d db
cd backend
set -a; source .env; set +a
bin/setup
bin/rails db:seed
bin/rails server
```

- [Hướng dẫn phát triển](specs/002-project-init/quickstart.md)
- [Kế hoạch kiến trúc](specs/002-project-init/plan.md)
- [Mô hình dữ liệu](specs/002-project-init/data-model.md)
- [Danh mục quyền](specs/002-project-init/permissions-catalog.md)
- API docs trong development: `http://localhost:3000/api-docs` (Swagger UI, theo OpenAPI contract).

## Công nghệ

- Vue 3, Vite và Vue Router
- Pinia
- Tailwind CSS 4 và DaisyUI
- Lucide icons (`@lucide/vue`)
- pnpm workspace

## Yêu cầu

- Node.js có Corepack
- pnpm `10.34.1` (được khai báo trong `package.json` ở thư mục gốc)

## Cài đặt và chạy

Chạy các lệnh từ thư mục gốc repository:

```bash
pnpm install
pnpm dev
```

Mở địa chỉ local mà Vite in ra trong terminal (mặc định là `http://localhost:5173`).

Nếu máy chưa có lệnh `pnpm`, bật Corepack trước:

```bash
corepack enable
```

Sau đó chạy lại `pnpm install`.

## Các lệnh thường dùng

```bash
pnpm dev           # Chạy máy chủ phát triển
pnpm build         # Tạo bản build production trong frontend/dist
pnpm preview       # Xem thử bản build production
pnpm lint          # Kiểm tra ESLint
pnpm lint:fix      # Tự sửa các lỗi ESLint có thể tự động sửa
pnpm format        # Định dạng mã bằng Prettier
pnpm format:check  # Kiểm tra định dạng
```

## Cấu trúc chính

```text
.
├── frontend/
│   ├── index.html
│   └── src/
│       ├── App.vue
│       ├── AppIcon.vue
│       ├── main.js
│       ├── router.js
│       ├── style.css
│       ├── stores/dashboard.js
│       └── views/DashboardView.vue
├── backend/                    # Rails 8.1 API, Ruby 3.4.4
├── compose.yaml                # PostgreSQL 18 development database
├── package.json
└── pnpm-workspace.yaml
```

- `frontend/src/views/DashboardView.vue`: màn hình dashboard và tương tác demo.
- `frontend/src/stores/dashboard.js`: trạng thái Pinia và danh sách hợp đồng mẫu.
- `frontend/src/router.js`: các đường dẫn điều hướng.
- `frontend/src/style.css`: nạp Tailwind CSS, cấu hình DaisyUI và theme Pawnify.
