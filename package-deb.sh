#!/usr/bin/env bash
set -e

# Tự động lấy thư mục chứa script làm Workspace để tránh lỗi đường dẫn có khoảng trắng
WORKSPACE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_ROOT="${WORKSPACE}/mesa-custom-driver"
SOURCE_MESA="/opt/mesa-26.1.5"

echo "[1/5] Khởi tạo cấu trúc gói tin Debian..."
rm -rf "$PKG_ROOT"
mkdir -p "${PKG_ROOT}/DEBIAN"
mkdir -p "${PKG_ROOT}/opt"

echo "[2/5] Sao chép tệp tin driver /opt/mesa-26.1.5 vào gói..."
if [ ! -d "$SOURCE_MESA" ]; then
    echo "[Lỗi] Không tìm thấy driver đã cài đặt tại $SOURCE_MESA" >&2
    exit 1
fi
cp -a "$SOURCE_MESA" "${PKG_ROOT}/opt/"

echo "[3/5] Ép cấu hình đường dẫn tuyệt đối cho Vulkan JSON..."
INTEL_JSON="${PKG_ROOT}/opt/mesa-26.1.5/share/vulkan/icd.d/intel_icd.x86_64.json"
RADEON_JSON="${PKG_ROOT}/opt/mesa-26.1.5/share/vulkan/icd.d/radeon_icd.x86_64.json"

if [ -f "$INTEL_JSON" ]; then
    sed -i 's|"library_path": "libvulkan_intel.so"|"library_path": "/opt/mesa-26.1.5/lib/x86_64-linux-gnu/libvulkan_intel.so"|g' "$INTEL_JSON"
fi
if [ -f "$RADEON_JSON" ]; then
    sed -i 's|"library_path": "libvulkan_radeon.so"|"library_path": "/opt/mesa-26.1.5/lib/x86_64-linux-gnu/libvulkan_radeon.so"|g' "$RADEON_JSON"
fi

echo "[4/5] Tạo siêu dữ liệu và cấu hình tự động postinst/prerm..."
cat << 'INNER_EOF' > "${PKG_ROOT}/DEBIAN/control"
Package: mesa-custom-driver
Version: 26.1.5-resolute
Section: graphics
Priority: optional
Architecture: amd64
Maintainer: Dang Nhat Phi <dang-nhat-phi@github>
Depends: libclc-22, libclang-common-22-dev, libelf1t64, libdrm2, libwayland-client0, libxcb1
Description: Custom Mesa 26.1.5 driver compiled for Ubuntu 26.04 LTS. Supports hybrid Intel iGPU and AMD Radeon GCN devices.
INNER_EOF

cat << 'INNER_EOF' > "${PKG_ROOT}/DEBIAN/postinst"
#!/bin/sh
set -e
echo "/opt/mesa-26.1.5/lib/x86_64-linux-gnu" > /etc/ld.so.conf.d/00-custom-mesa.conf
ldconfig
mkdir -p /etc/vulkan/icd.d
ln -sf /opt/mesa-26.1.5/share/vulkan/icd.d/intel_icd.x86_64.json /etc/vulkan/icd.d/intel_icd.x86_64.json
ln -sf /opt/mesa-26.1.5/share/vulkan/icd.d/radeon_icd.x86_64.json /etc/vulkan/icd.d/radeon_icd.x86_64.json
mkdir -p /etc/glvnd/egl_vendor.d
ln -sf /opt/mesa-26.1.5/share/glvnd/egl_vendor.d/50_mesa.json /etc/glvnd/egl_vendor.d/50_mesa.json
exit 0
INNER_EOF

cat << 'INNER_EOF' > "${PKG_ROOT}/DEBIAN/prerm"
#!/bin/sh
set -e
rm -f /etc/ld.so.conf.d/00-custom-mesa.conf
rm -f /etc/vulkan/icd.d/intel_icd.x86_64.json
rm -f /etc/vulkan/icd.d/radeon_icd.x86_64.json
rm -f /etc/glvnd/egl_vendor.d/50_mesa.json
ldconfig
exit 0
INNER_EOF

# Thiết lập quyền sở hữu và quyền hạn cần có đối với cấu trúc gói Debian
sudo chown -R root:root "$PKG_ROOT"
sudo chmod -R 755 "${PKG_ROOT}/opt"
sudo chmod 755 "${PKG_ROOT}/DEBIAN"
sudo chmod 755 "${PKG_ROOT}/DEBIAN/postinst"
sudo chmod 755 "${PKG_ROOT}/DEBIAN/prerm"
sudo chmod 644 "${PKG_ROOT}/DEBIAN/control"

echo "[5/5] Tiến hành đóng gói dpkg-deb..."
dpkg-deb --build "$PKG_ROOT"
sudo chown -R "$(id -u):$(id -g)" "$WORKSPACE"
echo "=== ĐÃ TẠO THÀNH CÔNG FILE .DEB ==="
