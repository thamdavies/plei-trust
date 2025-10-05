Hệ thống có 6 cách tính lãi:
- Lãi ngày (k/triệu)
- Lãi ngày (k/ngày)
- Lãi tháng % (30 ngày)
- Lãi tháng (định kỳ)
- Lãi tuần (%)
- Lãi tuần (VNĐ)

Diễn giải chi tiết của từng cách tính như sau

#### Lãi ngày (k/triệu)
Tiền bỏ ra: 5 triệu  
Lãi suất: 10k/triệu/ngày  
Kỳ lãi: 30 ngày  
Số ngày vay: 60  
Vay từ ngày: 03/10/2025 đến hết ngày 01/12/2025  
Tổng lãi: 3,000,000 VNĐ

Công thức: lãi = (loan_amount / 1_000_000) * rate_k_per_million * 1_000 * số_ngày

Lịch đóng lãi:
| STT | Ngày bắt đầu | → | Ngày kết thúc | Số ngày | Tiền lãi | Tiền khác | Tổng lãi |
|-----|--------------|---|---------------|---------|----------|-----------|----------|
| 1 | 03/10/2025 | → | 01/11/2025 | 30 | 1,500,000 VNĐ | 0 VNĐ | 1,500,000 VNĐ |
| 2 | 02/11/2025 | → | 01/12/2025 | 30 | 1,500,000 VNĐ | 0 VNĐ | 1,500,000 VNĐ |

#### Lãi ngày (k/ngày)
Tiền bỏ ra: 5 triệu  
Lãi suất: 10k/ngày (tổng cố định, không phụ thuộc số tiền)  
Kỳ lãi: 30 ngày  
Số ngày vay: 60  
Vay: 03/10/2025 → 01/12/2025  
Tổng lãi: 600,000 VNĐ

Công thức: lãi = rate_k_per_day * 1_000 * số_ngày

Lịch đóng lãi:
| STT | Ngày bắt đầu | → | Ngày kết thúc | Số ngày | Tiền lãi | Tiền khác | Tổng lãi |
|-----|--------------|---|---------------|---------|----------|-----------|----------|
| 1 | 03/10/2025 | → | 01/11/2025 | 30 | 300,000 VNĐ | 0 VNĐ | 300,000 VNĐ |
| 2 | 02/11/2025 | → | 01/12/2025 | 30 | 300,000 VNĐ | 0 VNĐ | 300,000 VNĐ |

#### Lãi tháng % (30 ngày)
(Tháng chuẩn hóa = 30 ngày, mỗi kỳ luôn 30 ngày)

Tiền bỏ ra: 20 triệu  
Lãi suất: 0.5% / tháng (30 ngày)  
Số tháng vay: 3  
Vay: 02/10/2025 → 30/12/2025  
Tổng lãi: 300,000 VNĐ

Công thức kỳ: lãi_kỳ = loan_amount * monthly_percent

| STT | Ngày bắt đầu | → | Ngày kết thúc | Số ngày | Tiền lãi | Tiền khác | Tổng lãi |
|-----|--------------|---|---------------|---------|----------|-----------|----------|
| 1 | 02/10/2025 | → | 31/10/2025 | 30 | 100,000 VNĐ | 0 VNĐ | 100,000 VNĐ |
| 2 | 01/11/2025 | → | 30/11/2025 | 30 | 100,000 VNĐ | 0 VNĐ | 100,000 VNĐ |
| 3 | 01/12/2025 | → | 30/12/2025 | 30 | 100,000 VNĐ | 0 VNĐ | 100,000 VNĐ |

#### Lãi tháng (định kỳ)
(Dựa vào lịch thực tế cộng “1 tháng” theo calendar; tiền lãi giữ cố định mỗi kỳ dù số ngày khác nhau – giống output đã code)

Ví dụ:  
Tiền: 20 triệu – Lãi suất: 0.5%/tháng (calendar) – Số kỳ: 3  
Ngày vay: 02/10/2025 (maturity sau 3 kỳ)  
Công thức: lãi_kỳ = loan_amount * monthly_percent (không prorate theo số ngày thực tế)

| STT | Ngày bắt đầu | → | Ngày kết thúc | Số ngày | Tiền lãi | Tiền khác | Tổng lãi |
|-----|--------------|---|---------------|---------|----------|-----------|----------|
| 1 | 02/10/2025 | → | 02/11/2025 | 32 | 100,000 VNĐ | 0 VNĐ | 100,000 VNĐ |
| 2 | 03/11/2025 | → | 02/12/2025 | 30 | 100,000 VNĐ | 0 VNĐ | 100,000 VNĐ |
| 3 | 03/12/2025 | → | 02/01/2026 | 31 | 100,000 VNĐ | 0 VNĐ | 100,000 VNĐ |

(Ghi chú: Số ngày chênh lệch do cộng theo calendar; nếu muốn khớp screenshot “32/31/32” bạn đang tính inclusive cả đầu + cuối. Điều chỉnh lại phép đếm nếu cần.)

#### Lãi tuần (%)
Tiền bỏ ra: 7,000,000  
Lãi suất: 2% / tuần  
Số tuần vay: 4
Ngày vay: 07/10/2025 → 03/11/2025 (4 tuần)  
Công thức: lãi_tuần = principal * weekly_percent

| STT | Ngày bắt đầu | → | Ngày kết thúc | Số ngày | Tiền lãi | Tiền khác | Tổng lãi |
|-----|--------------|---|---------------|---------|----------|-----------|----------|
| 1 | 07/10/2025 | → | 13/10/2025 | 7 | 140,000 VNĐ | 0 VNĐ | 140,000 VNĐ |
| 2 | 14/10/2025 | → | 20/10/2025 | 7 | 140,000 VNĐ | 0 VNĐ | 140,000 VNĐ |
| 3 | 21/10/2025 | → | 27/10/2025 | 7 | 140,000 VNĐ | 0 VNĐ | 140,000 VNĐ |
| 4 | 28/10/2025 | → | 03/11/2025 | 7 | 140,000 VNĐ | 0 VNĐ | 140,000 VNĐ |

#### Lãi tuần (VNĐ)
Tiền bỏ ra: 7,000,000  
Lãi suất cố định: 80,000 VNĐ / tuần  
Số tuần vay: 4  
Ngày vay: 07/10/2025 → 03/11/2025  

Công thức: lãi_tuần = fixed_amount

| STT | Ngày bắt đầu | → | Ngày kết thúc | Số ngày | Tiền lãi | Tiền khác | Tổng lãi |
|-----|--------------|---|---------------|---------|----------|-----------|----------|
| 1 | 07/10/2025 | → | 13/10/2025 | 7 | 80,000 VNĐ | 0 VNĐ | 80,000 VNĐ |
| 2 | 14/10/2025 | → | 20/10/2025 | 7 | 80,000 VNĐ | 0 VNĐ | 80,000 VNĐ |
| 3 | 21/10/2025 | → | 27/10/2025 | 7 | 80,000 VNĐ | 0 VNĐ | 80,000 VNĐ |
| 4 | 28/10/2025 | → | 03/11/2025 | 7 | 80,000 VNĐ | 0 VNĐ | 80,000 VNĐ |

### Tóm tắt quy tắc implement trong service
- daily_per_million: interest = (principal / 1_000_000) * rate_k_per_million * 1_000 * days
- daily_fixed: interest = rate_k_per_day * 1_000 * days
- monthly_30: mỗi kỳ chuẩn 30 ngày; interest = principal * monthly_percent
- monthly_calendar: mỗi kỳ date += 1.month; interest cố định = principal * monthly_percent
- weekly_percent: interest = principal * weekly_percent
- weekly_fixed: interest = fixed_week_amount

Khi kỳ cuối bị cắt ngắn, vẫn tính như trên
