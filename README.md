# Tạo package `memcon` từ đầu → publish npm → upload GitHub → cài bằng 1 lệnh
---

# 1. Cài NodeJS + npm

```bash id="i0r4q7"
apt update
apt install -y nodejs npm git
```

Kiểm tra:

```bash id="4x8g6m"
node -v
npm -v
git --version
```

---

# 2. Tạo project

```bash id="2j7f8m"
mkdir -p /opt/memcon
cd /opt/memcon
```

---

# 3. Tạo `package.json`

```bash id="3v7t1q"
nano package.json
```

Dán:

```json id="8k9d3p"
{
  "name": "@tylaujjapan0/memcon",
  "version": "1.0.0",
  "description": "Simple RAM monitor for Linux/Docker",
  "bin": {
    "memcon": "./index.js"
  },
  "preferGlobal": true
}
```

Lưu:

```txt id="7r5m1x"
CTRL+X
Y
ENTER
```

---

# 4. Tạo `index.js`

```bash id="8n3z5r"
nano index.js
```

Dán:

---

# 5. Cho phép chạy

```bash id="1x6f4m"
chmod +x index.js
```

---

# 6. Test local

```bash id="9f2m8q"
npm install -g .
```

---

# 7. Chạy thử

```bash id="2m7v1r"
memcon
```

---

# 8. Test monitor

```bash id="4n8g2q"
ram
```

hoặc:

```bash id="6k3x9m"
ram.mem
```

---

# 9. Login npm

```bash id="5p2v7q"
npm login
```

Browser sẽ mở.

Authorize.

---

# 10. Publish npm

```bash id="8m6r3x"
npm publish --access public
```

---

# 11. Kiểm tra package online

Package sẽ xuất hiện tại:
```bash id="8m6r3x1"
npm i @tylaujjapan0/memcon
```
[npmjs memcon package](https://www.npmjs.com/package/@tylaujjapan0/memcon?utm_source=chatgpt.com)

---

# 12. Tạo GitHub repo

# Dễ nhất là dùng GitHub CLI để login bằng trình duyệt.

---

## 1. Cài GitHub CLI

Debian/Ubuntu:

```bash id="3k7m1v"
apt update
apt install -y gh
```

---

## 2. Login bằng browser

```bash id="7n2q5m"
gh auth login
```

---

## 3. Chọn lần lượt

```txt id="5v8m2x"
GitHub.com
HTTPS
Login with a web browser
```

---

## 4. Nó sẽ hiện kiểu:

```txt id="9m4q1x"
First copy your one-time code: XXXX-XXXX
Press Enter to open github.com in your browser...
```

---

## 5. Mở link đó trên browser

Ví dụ:

[GitHub Device Login](https://github.com/login/device?utm_source=chatgpt.com)

---

## 6. Nhập code

Ví dụ:

```txt id="2x8m5q"
ABCD-EFGH
```

---

## 7. Approve

Bấm:

```txt id="4m7q2v"
Authorize GitHub CLI
```

Tạo repo tên:

```txt id="9m4f2q"
memcon
```

trên:

[GitHub New Repository](https://github.com/new?utm_source=chatgpt.com)

---

# 13. Tạo install.sh

```bash id="3w7k9n"
nano install.sh
```

Dán:

```bash id="8v5q1m"
#!/bin/bash

echo "Installing memcon..."

if ! command -v node >/dev/null 2>&1; then
  echo "Installing NodeJS..."

  apt update
  apt install -y nodejs npm
fi

npx @tylaujjapan0/memcon

echo ""
echo "Done!"
echo "Commands:"
echo "ram"
echo "ram.mem"
```

---

# 14. Init git

```bash id="2n8m5q"
git init
git add .
git commit -m "first commit"
```

---

# 15. Connect GitHub repo

Thay USERNAME bằng GitHub username.

```bash id="7f4q8m"
git remote add origin https://github.com/USERNAME/memcon.git
```

---

# 16. Push GitHub

```bash id="9r2m6x"
git branch -M main
git push -u origin main
```

---

# 17. Cài bằng 1 lệnh toàn cầu

Sau khi push GitHub:

```bash id="5x8v1n"
curl -sL https://raw.githubusercontent.com/USERNAME/memcon/main/install.sh | bash
```

Ví dụ:

```bash id="1q6k8m"
curl -sL https://raw.githubusercontent.com/tylaujjapan0/memcon/main/install.sh | bash
```

---

# 18. Kết quả

User chỉ cần 1 lệnh:

```bash id="3v9m2q"
curl -sL ... | bash
```

Script sẽ:

* tự cài node/npm nếu thiếu
* tự tải memcon từ npm
* tự start monitor
* có command:

  * `ram`
  * `ram.mem`

---

# 19. Update package

Sửa:

```json id="4m7x2q"
"version": "1.0.2"
```

---

Publish lại:

```bash id="7n5k3m"
npm publish
```

---

Push GitHub:

```bash id="2f8q1x"
git add .
git commit -m "update"
git push
```
