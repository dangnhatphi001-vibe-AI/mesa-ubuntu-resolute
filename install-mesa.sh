#!/usr/bin/env bash
# ==============================================================================
# Script Name: install-mesa.sh
# Description: One-click global installer for custom Mesa 26.1.5 package
# Maintainer: dangnhatphi001-vibe-AI
# ==============================================================================

set -e

# Khai báo thông tin định danh chính xác theo tài khoản GitHub của bạn
GITHUB_USER="dangnhatphi001-vibe-AI"
GITHUB_REPO="mesa-ubuntu-resolute"
DEB_NAME="mesa-custom-driver.deb"

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

echo "=====[ Đang khởi chạy quy trình cài đặt nhanh Driver Mesa 26.1.5 ]====="

echo "[1/4] Cập nhật danh sách kho phần mềm..."
sudo apt update

echo "[2/4] Đang truy vấn API GitHub để tìm kiếm bản cài đặt mới nhất..."
DOWNLOAD_URL=$(curl -s "https://api.github.com/repos/${GITHUB_USER}/${GITHUB_REPO}/releases/latest" \
    | grep "browser_download_url.*deb" \
    | cut -d '"' -f 4)

if [ -z "$DOWNLOAD_URL" ]; then
    echo "[Thông báo] Không tìm thấy Assets trong Releases, chuyển hướng tải trực tiếp từ nhánh main..."
    DOWNLOAD_URL="https://raw.githubusercontent.com/${GITHUB_USER}/${GITHUB_REPO}/main/${DEB_NAME}"
fi

echo "[3/4] Đang tải xuống gói đóng gói driver..."
curl -L "$DOWNLOAD_URL" -o "${TMP_DIR}/${DEB_NAME}"

echo "[4/4] Tiến hành cài đặt gói và giải quyết các phụ thuộc hệ thống..."
sudo apt install "${TMP_DIR}/${DEB_NAME}" -y

echo "=============================================================================="
echo "[THÀNH CÔNG] Hệ thống của bạn đã được nâng cấp lên Mesa 26.1.5 toàn cục!"
echo "Vui lòng khởi động lại máy để Driver đồ họa mới được áp dụng hoàn toàn."
echo "=============================================================================="
