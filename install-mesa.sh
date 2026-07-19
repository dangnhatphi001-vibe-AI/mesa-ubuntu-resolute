#!/usr/bin/env bash
set -e

GITHUB_USER="dangnhatphi001-vibe-AI"
GITHUB_REPO="mesa-ubuntu-resolute"
DEB_NAME="mesa-custom-driver.deb"

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

echo "=====[ Khởi chạy cài đặt nhanh Mesa 26.1.5 ]====="
sudo apt update

DOWNLOAD_URL=$(curl -s "https://api.github.com/repos/${GITHUB_USER}/${GITHUB_REPO}/releases/latest" \
    | grep "browser_download_url.*deb" \
    | cut -d '"' -f 4)

if [ -z "$DOWNLOAD_URL" ]; then
    DOWNLOAD_URL="https://raw.githubusercontent.com/${GITHUB_USER}/${GITHUB_REPO}/main/${DEB_NAME}"
fi

echo "[*] Đang tải gói driver từ GitHub..."
curl -L "$DOWNLOAD_URL" -o "${TMP_DIR}/${DEB_NAME}"

echo "[*] Tiến hành nạp driver vào hệ thống..."
sudo apt install "${TMP_DIR}/${DEB_NAME}" -y

echo "========================================================"
echo "THÀNH CÔNG! Vui lòng khởi động lại máy để áp dụng driver."
echo "========================================================"
