# Custom Mesa 26.1.5 Driver for Ubuntu 26.04 LTS (Resolute)

Bộ Driver đồ họa mã nguồn mở **Mesa 26.1.5** được biên dịch tùy biến, hỗ trợ tối ưu hiệu năng hỗn hợp cho cả cấu hình **iGPU Intel hiện tại** và **AMD Radeon GCN (R7 430...)**.

## Hướng dẫn cài đặt nhanh 1 lệnh (One-click Install)

Mở Terminal của bạn lên và thực thi duy nhất dòng lệnh sau để tự động cài đặt toàn cục:

```bash
curl -fsSL https://raw.githubusercontent.com/dangnhatphi001-vibe-AI/mesa-ubuntu-resolute/main/install-mesa.sh | bash
```

Tính năng tích hợp ngầm trong gói `.deb`:
- Tự động liên kết Dynamic Linker đồ họa sang `/opt/mesa-26.1.5`.
- Khởi tạo cấu hình Vulkan ICD tuyệt đối chống lỗi vặt nhận diện GPU.
- Tự động hoàn tác dọn sạch hệ thống (Rollback) về driver gốc khi chạy lệnh: `sudo apt remove mesa-custom-driver`.
