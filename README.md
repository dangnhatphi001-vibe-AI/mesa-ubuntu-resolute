# 🚀 Custom Mesa 26.1.5 Driver for Ubuntu 26.04 LTS (Resolute)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Ubuntu Version](https://img.shields.io/badge/Ubuntu-26.04%20LTS-orange.svg)](#)
[![Mesa Version](https://img.shields.io/badge/Mesa-26.1.5--custom-blue.svg)](#)
[![Platform](https://img.shields.io/badge/Platform-Intel%20%7C%20AMD%20Radeon-brightgreen.svg)](#)

Bộ Driver đồ họa mã nguồn mở **Mesa 26.1.5** được biên dịch tùy biến và tối ưu hóa hiệu năng cho các cấu hình phần cứng chạy Ubuntu 26.04 LTS (Resolute). Đặc biệt hỗ trợ tối ưu hiệu năng hỗn hợp (Hybrid GPU) cho cả cấu hình **iGPU Intel** hiện tại và các dòng **AMD Radeon kiến trúc GCN** (như R7 430, R7 240, v.v.).

---

## ✨ Tính năng nổi bật

* 🔄 **Dynamic Linker**: Tự động liên kết Dynamic Linker đồ họa của hệ thống sang thư mục cài đặt biệt lập `/opt/mesa-26.1.5` để tránh xung đột thư viện hệ thống gốc.
* 🎮 **Vulkan ICD**: Khởi tạo cấu hình Vulkan ICD tuyệt đối, chống triệt để các lỗi vặt nhận diện GPU trong game và các ứng dụng đồ họa 3D.
* 🛡️ **An toàn & Sạch sẽ**: Hỗ trợ cơ chế khôi phục (Rollback) hoàn toàn về driver gốc của Ubuntu chỉ với một lệnh gỡ cài đặt.
* ⚡ **One-click Installer**: Quá trình cài đặt tự động toàn bộ từ tải gói, cài thư viện phụ thuộc đến cấu hình hệ thống chỉ trong 1 dòng lệnh.

---

## 💻 Cấu hình phần cứng được hỗ trợ

| Nhà sản xuất | Dòng GPU hỗ trợ | Trạng thái |
| :--- | :--- | :--- |
| **Intel®** | Intel HD/UHD/Iris Graphics (Tích hợp trên CPU Intel) | 🟢 Hoạt động tốt |
| **AMD Radeon™** | Kiến trúc GCN (Graphics Core Next) như Radeon R7 430, HD 7000+ | 🟢 Hoạt động tốt |

---

## ⚡ Hướng dẫn cài đặt nhanh (One-click Install)

Mở Terminal của bạn (`Ctrl + Alt + T`) và thực thi dòng lệnh duy nhất sau:

```bash
curl -fsSL https://raw.githubusercontent.com/dangnhatphi001-vibe-AI/mesa-ubuntu-resolute/main/install-mesa.sh | bash
```

> [!IMPORTANT]
> Sau khi cài đặt hoàn tất, vui lòng **khởi động lại máy tính** để Driver đồ họa mới được hệ thống áp dụng hoàn toàn.

---

## 🔍 Kiểm tra sau khi cài đặt

Để kiểm tra xem hệ thống đã nhận Driver Mesa 26.1.5 tùy biến chưa, hãy chạy lệnh:

```bash
glxinfo | grep "OpenGL version"
```
Màn hình sẽ hiển thị thông tin phiên bản Mesa có chứa đuôi cấu hình `Mesa 26.1.5`.

Đối với Vulkan, kiểm tra bằng:
```bash
vulkaninfo --summary
```

---

## ⚙️ Cơ chế vận hành toàn cục

Hệ thống cài đặt hoạt động theo quy trình 4 bước khép kín dưới đây:

```
[Chạy lệnh curl]
       │
       ▼
1. Tải script 'install-mesa.sh' từ GitHub về bộ nhớ tạm (RAM).
       │
       ▼
2. Truy vấn GitHub API tìm bản cài đặt "mesa-custom-driver.deb" mới nhất trong Releases.
       │
       ▼
3. Cài đặt file .deb thông qua 'apt' để tự động kéo các gói phụ thuộc (libclc, libdrm...).
       │
       ▼
4. Kịch bản ngầm 'postinst' kích hoạt: Tạo symlink và chạy 'ldconfig' nhận driver tại /opt/mesa-26.1.5.
```

---

## 🗑️ Gỡ cài đặt & Khôi phục (Uninstall & Rollback)

Nếu bạn muốn quay về driver mặc định ban đầu của Ubuntu, chỉ cần chạy lệnh sau:

```bash
sudo apt remove mesa-custom-driver -y
```
Hệ thống sẽ tự động dọn sạch cấu hình tùy biến, hoàn tác các symlink và khôi phục trạng thái driver gốc một cách an toàn.

---
*Dự án được duy trì bởi [dangnhatphi001-vibe-AI](https://github.com/dangnhatphi001-vibe-AI).*
