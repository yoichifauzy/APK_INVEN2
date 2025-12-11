# 📚 Dokumentasi API Inventory System

**Base URL:** `http://34.101.195.103/api`

---

## 📋 Ringkasan

Inventory System API menyediakan sekumpulan endpoint untuk mengelola aset dan stok barang secara terpusat. Fitur utama meliputi autentikasi (token), manajemen pengguna, manajemen item dan kategori, supplier, transaksi barang masuk/keluar, permintaan barang, dan laporan. Semua request/response menggunakan format JSON dan endpoint yang dilindungi memerlukan header otorisasi.

Gunakan collection Postman bernama "Inventory System API" untuk mengelompokkan request: Authentication, Users, Items, Categories, Suppliers, Incoming/Outgoing, Requests, dan Reports.

---

## 🔁 Recent API Changes (Update)

- Added approve/reject endpoints for outgoing goods:
  - `PATCH /api/barang-keluar/{id}/approve`
  - `PATCH /api/barang-keluar/{id}/reject`
    These allow `admin` and `manager` roles to approve or reject pending `barang-keluar` records.
- `barang-masuk` approve/reject now permitted for both `admin` and `manager` roles (previously admin-only).
- Authentication responses clarified:
  - `POST /api/login` returns `404` with `"Email tidak ditemukan"` when email is not registered, and `401` with `"Password salah"` when password is incorrect. Frontend surfaces these messages for clearer UX.
- Several listing endpoints were adjusted to return newest records first (e.g. request, barang-masuk, barang-keluar, items, users, suppliers) to ensure latest data appears at the top in UIs.
- Migration added: `add_approval_fields_to_barang_keluar_table` — adds approval metadata columns (`approved_by`, `approved_at`, `rejected_by`, `rejected_at`, `reject_reason`) for `barang_keluar`.

Note: If you prefer a single generic authentication error (to avoid disclosing whether an email exists), revert to returning a generic 401 message for login failures.

---

## 📋 Daftar Isi

- [Getting Started](#getting-started)
- [Authentication](#authentication)
- [Rate & Usage Limits](#rate--usage-limits)
- [Error Responses](#error-responses)
- [Endpoints (Ringkasan)](#endpoints-ringkasan)
  - Authentication
  - Users
  - Items
  - Categories
  - Suppliers
  - Incoming / Outgoing
  - Requests
  - Reports
- [Import to Postman](#import-to-postman)
- [Need help / Support](#need-help--support)

---

## 🛠 Getting Started

Ikuti langkah berikut untuk mulai menggunakan API:

1. Siapkan `BASE_URL` environment untuk lingkungan (development/staging/production).
2. Daftarkan user atau gunakan akun yang sudah ada, lalu autentikasi untuk mendapatkan token Bearer.
3. Sertakan header `Authorization: Bearer <token>` pada semua request yang memerlukan otorisasi.
4. Gunakan `Content-Type: application/json` untuk body JSON.

Tips singkat:

- Endpoint hanya menerima HTTPS pada lingkungan produksi.
- Semua response sukses mengembalikan kode 2xx dan objek JSON.
- Untuk operasi list yang panjang, gunakan query params `page`, `per_page`, `filter`, dan `sort` bila tersedia.

---

## 🔐 Authentication

API ini menggunakan skema autentikasi Bearer token (JWT atau token akses serupa).

Cara memperoleh token (contoh):

1. POST `/api/login` dengan `email` dan `password`.
2. Server mengembalikan token dalam field `access_token` atau `token`.
3. Tambahkan header pada request berikutnya:

```
Authorization: Bearer <access_token>
```

Contoh: POST `/api/login`

Request:

```
POST {{BASE_URL}}/api/login
Content-Type: application/json

{
  "email": "admin@example.com",
  "password": "password"
}
```

Response (200):

```
{
  "access_token": "eyJhbGci...",
  "token_type": "Bearer",
  "expires_in": 3600,
  "user": { "id": 1, "name": "Admin" }
}
```

Jika ada API key alternatif (mis. `X-Api-Key`), dokumentasikan di endpoint terkait.

### Authentication error

- 401 Unauthorized — token tidak disertakan, kadaluarsa, atau tidak valid.
- 403 Forbidden — user tidak memiliki hak akses untuk resource tertentu.

---

## ⏱ Rate & Usage Limits

API menerapkan batas penggunaan agar stabilitas tetap terjaga. Contoh header yang dikembalikan setiap response:

- `X-RateLimit-Limit`: maksimum request per menit.
- `X-RateLimit-Remaining`: sisa request di jendela saat ini.
- `X-RateLimit-Reset`: waktu (UTC epoch seconds) saat jendela akan direset.

Jika melewati limit, server mengembalikan `429 Too Many Requests`.

Contoh kebijakan (sesuaikan dengan environment): `300` requests per minute.

---

## ⚠️ Error Responses

Semua error mengembalikan JSON dengan struktur umum:

```
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Deskripsi kesalahan",
    "details": { /* optional */ }
  }
}
```

Contoh status penting:

- `400 Bad Request` — validasi gagal.
- `401 Unauthorized` — autentikasi diperlukan atau token tidak valid.
- `403 Forbidden` — hak akses tidak mencukupi.
- `404 Not Found` — resource tidak ditemukan.
- `429 Too Many Requests` — rate limit terlampaui.
- `500 Internal Server Error` — error sisi server.

### 503 response

`503 Service Unavailable` menunjukkan gangguan sementara (mis. spike traffic atau pemeliharaan). Coba ulang setelah beberapa detik. Jika masalah berlanjut, hubungi support.

---

## Endpoints (Ringkasan)

Berikut contoh ringkasan endpoint inti. Untuk tiap endpoint di collection Postman berikan contoh request/response lengkap.

### Authentication

- `POST /api/login` — autentikasi dan dapatkan token
- `POST /api/register` — registrasi user baru
- `POST /api/logout` — logout / invalidate token

### Users

- `GET /api/users` — list users (admin)
- `GET /api/users/{id}` — detail user
- `POST /api/users` — buat user (admin)
- `PUT /api/users/{id}` — update user
- `DELETE /api/users/{id}` — hapus user

### Items (Barang)

- `GET /api/items` — list items (support paging & filter)
- `GET /api/items/{id}` — detail item
- `POST /api/items` — tambah item
- `PUT /api/items/{id}` — update item
- `DELETE /api/items/{id}` — hapus item

Contoh request create item:

```
POST {{BASE_URL}}/api/items
Authorization: Bearer {{TOKEN}}
Content-Type: application/json

{
  "nama": "Laptop Dell XPS 15",
  "kategori_id": 1,
  "supplier_id": 1,
  "deskripsi": "Laptop berkinerja tinggi",
  "stok": 5,
  "harga": 15000000
}
```

Response (201):

```
{
  "message": "Item created successfully",
  "data": { "id": 1, "nama": "Laptop Dell XPS 15", "stok": 5 }
}
```

### Categories, Suppliers, Incoming/Outgoing, Requests, Reports

- Struktur endpoint dan pola request mirip dengan Items/Users — gunakan HTTP verbs sesuai CRUD.
- Untuk transaksi (incoming/outgoing), sertakan field `quantity`, `item_id`, `notes`, dan `performed_by`.
- Untuk reports, sediakan filter tanggal dan format response ringkasan (summary) plus detail.

---

## ✅ Import ke Postman / Buat Collection

Langkah cepat membuat Collection di Postman:

1. Klik `New` → pilih `Collection`.
2. Isi:
   - `Name`: Inventory System API
   - `Description`: Inventory System API menyediakan endpoint untuk mengelola inventaris (autentikasi, pengguna, item, kategori, transaksi, laporan). Semua endpoint menggunakan JSON dan memerlukan header `Authorization: Bearer <token>` untuk operasi yang dilindungi.
3. Klik `Create`.
4. Buat Environment di Postman dengan variable `BASE_URL` dan `TOKEN`.
5. Tambahkan request ke collection (Authentication, Users, Items, dll.) dan simpan.

Catatan: Anda dapat mengimpor file `collection.json` bila tersedia.

---

## 📞 Need help / Support

Jika butuh bantuan:

- Dokumentasi & tutorial: `docs/` (lokal) atau wiki proyek.
- Forum / team chat: `#dev-inventory`.
- Hubungi maintainer / developer: `dev@example.com`.

Jika menemukan masalah produksi (5xx berulang), sertakan:

- time (UTC), request-id (jika ada), endpoint, contoh payload, dan response error.

---

## 📌 Catatan terakhir

- Gantilah placeholder `{{BASE_URL}}` sebelum menggunakan contoh.
- Untuk keamanan, jangan commit token ke repo.
- Jika ingin, saya bisa membuat file Postman collection (`collection.json`) berisi contoh request: Authentication, Users, Items. Beri tahu saya jika mau.

---

_Dibuat otomatis berdasarkan template dokumentasi. Sesuaikan contoh response, nama field, dan path endpoint sesuai implementasi server Anda._

---

## 📋 Daftar Isi

1. [Authentication](#authentication)
2. [User Management](#user-management)
3. [Barang (Items)](#barang-items)
4. [Kategori (Categories)](#kategori-categories)
5. [Supplier](#supplier)
6. [Barang Masuk (Incoming Goods)](#barang-masuk-incoming-goods)
7. [Barang Keluar (Outgoing Goods)](#barang-keluar-outgoing-goods)
8. [Request Barang (Item Requests)](#request-barang-item-requests)
9. [Reports & Tracking](#reports--tracking)
10. [Utilities](#utilities)

---

## 🔐 Authentication

### 1️⃣ **POST /login** - Login User

**Deskripsi:** Autentikasi user dan dapatkan token

```http
POST http://34.34.217.136/api/login
Content-Type: application/json

{
  "email": "admin@example.com",
  "password": "password"
}
```

**Response (200):**

```json
{
  "token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "user": {
    "id": 1,
    "name": "Admin User",
    "email": "admin@example.com",
    "roles": ["admin"]
  }
}
```

**Untuk request berikutnya, tambahkan header:**

```
Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGc...
```

---

### 2️⃣ **POST /register** - Register User Baru

**Deskripsi:** Daftar user baru

```http
POST http://34.34.217.136/api/register
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password",
  "password_confirmation": "password",
  "role": "staff"
}
```

**Response (201):**

```json
{
  "message": "User registered successfully",
  "user": {
    "id": 2,
    "name": "John Doe",
    "email": "john@example.com",
    "roles": ["staff"]
  }
}
```

---

### 3️⃣ **POST /logout** - Logout User

**Deskripsi:** Logout dan invalidate token

```http
POST http://34.34.217.136/api/logout
Authorization: Bearer {token}
```

**Response (200):**

```json
{
  "message": "Logged out successfully"
}
```

---

### 4️⃣ **GET /user** - Get Current User

**Deskripsi:** Ambil data user yang sedang login

```http
GET http://34.34.217.136/api/user
Authorization: Bearer {token}
```

**Response (200):**

```json
{
  "id": 1,
  "name": "Admin User",
  "email": "admin@example.com",
  "roles": ["admin"],
  "created_at": "2024-01-15T10:30:00Z"
}
```

---

## 👥 User Management

> **Requirements:** Harus login + Role: `admin`

### 5️⃣ **GET /users** - List Semua User

**Deskripsi:** Ambil daftar seluruh user

```http
GET http://34.34.217.136/api/users
Authorization: Bearer {token}
```

**Response (200):**

```json
[
  {
    "id": 1,
    "name": "Admin User",
    "email": "admin@example.com",
    "roles": ["admin"],
    "created_at": "2024-01-15T10:30:00Z"
  },
  {
    "id": 2,
    "name": "John Doe",
    "email": "john@example.com",
    "roles": ["staff"],
    "created_at": "2024-01-16T10:30:00Z"
  }
]
```

---

### 6️⃣ **GET /users/{id}** - Get Detail User

**Deskripsi:** Ambil detail user berdasarkan ID

```http
GET http://34.34.217.136/api/users/2
Authorization: Bearer {token}
```

**Response (200):**

```json
{
  "id": 2,
  "name": "John Doe",
  "email": "john@example.com",
  "roles": ["staff"],
  "created_at": "2024-01-16T10:30:00Z"
}
```

---

### 7️⃣ **PUT /users/{id}** - Update User

**Deskripsi:** Update data user

```http
PUT http://34.34.217.136/api/users/2
Authorization: Bearer {token}
Content-Type: application/json

{
  "name": "John Updated",
  "email": "john.updated@example.com"
}
```

**Response (200):**

```json
{
  "message": "User updated successfully",
  "user": {
    "id": 2,
    "name": "John Updated",
    "email": "john.updated@example.com",
    "roles": ["staff"]
  }
}
```

---

### 8️⃣ **DELETE /users/{id}** - Delete User

**Deskripsi:** Hapus user

```http
DELETE http://34.34.217.136/api/users/2
Authorization: Bearer {token}
```

**Response (200):**

```json
{
  "message": "User deleted successfully"
}
```

---

## 📦 Barang (Items)

### 9️⃣ **POST /items** - Create Item Baru

**Deskripsi:** Tambah item barang baru

```http
POST http://34.34.217.136/api/items
Authorization: Bearer {token}
Content-Type: application/json

{
  "nama": "Laptop Dell XPS 15",
  "kategori_id": 1,
  "supplier_id": 1,
  "deskripsi": "Laptop berkinerja tinggi",
  "stok": 5,
  "harga": 15000000
}
```

**Response (201):**

```json
{
  "message": "Item created successfully",
  "data": {
    "id": 1,
    "nama": "Laptop Dell XPS 15",
    "kategori_id": 1,
    "supplier_id": 1,
    "deskripsi": "Laptop berkinerja tinggi",
    "stok": 5,
    "harga": 15000000,
    "created_at": "2024-01-15T10:30:00Z"
  }
}
```

---

### 🔟 **GET /items** - List Semua Item

**Deskripsi:** Ambil daftar semua item

```http
GET http://34.34.217.136/api/items
Authorization: Bearer {token}
```

**Response (200):**

```json
[
  {
    "id": 1,
    "nama": "Laptop Dell XPS 15",
    "kategori_id": 1,
    "supplier_id": 1,
    "stok": 5,
    "harga": 15000000,
    "created_at": "2024-01-15T10:30:00Z"
  }
]
```

---

### 1️⃣1️⃣ **GET /items/{id}** - Get Detail Item

**Deskripsi:** Ambil detail item spesifik

```http
GET http://34.34.217.136/api/items/1
Authorization: Bearer {token}
```

**Response (200):**

```json
{
  "id": 1,
  "nama": "Laptop Dell XPS 15",
  "kategori_id": 1,
  "supplier_id": 1,
  "deskripsi": "Laptop berkinerja tinggi",
  "stok": 5,
  "harga": 15000000,
  "created_at": "2024-01-15T10:30:00Z"
}
```

---

### 1️⃣2️⃣ **PUT /items/{id}** - Update Item

**Deskripsi:** Update data item

```http
PUT http://34.34.217.136/api/items/1
Authorization: Bearer {token}
Content-Type: application/json

{
  "nama": "Laptop Dell XPS 15 Updated",
  "stok": 10,
  "harga": 16000000
}
```

**Response (200):**

```json
{
  "message": "Item updated successfully",
  "data": {
    "id": 1,
    "nama": "Laptop Dell XPS 15 Updated",
    "stok": 10,
    "harga": 16000000
  }
}
```

---

### 1️⃣3️⃣ **DELETE /items/{id}** - Delete Item

**Deskripsi:** Hapus item

```http
DELETE http://34.34.217.136/api/items/1
Authorization: Bearer {token}
```

**Response (200):**

```json
{
  "message": "Item deleted successfully"
}
```

---

## 🏷️ Kategori (Categories)

### 1️⃣4️⃣ **POST /categories** - Create Kategori

**Deskripsi:** Tambah kategori baru

```http
POST http://34.34.217.136/api/categories
Authorization: Bearer {token}
Content-Type: application/json

{
  "nama": "Elektronik",
  "deskripsi": "Barang elektronik"
}
```

**Response (201):**

```json
{
  "message": "Category created successfully",
  "data": {
    "id": 1,
    "nama": "Elektronik",
    "deskripsi": "Barang elektronik",
    "created_at": "2024-01-15T10:30:00Z"
  }
}
```

---

### 1️⃣5️⃣ **GET /categories** - List Kategori

**Deskripsi:** Ambil daftar kategori

```http
GET http://34.34.217.136/api/categories
Authorization: Bearer {token}
```

**Response (200):**

```json
[
  {
    "id": 1,
    "nama": "Elektronik",
    "deskripsi": "Barang elektronik",
    "created_at": "2024-01-15T10:30:00Z"
  }
]
```

---

### 1️⃣6️⃣ **PUT /categories/{id}** - Update Kategori

**Deskripsi:** Update kategori

```http
PUT http://34.34.217.136/api/categories/1
Authorization: Bearer {token}
Content-Type: application/json

{
  "nama": "Elektronik & Gadget",
  "deskripsi": "Barang elektronik dan gadget"
}
```

**Response (200):**

```json
{
  "message": "Category updated successfully",
  "data": {
    "id": 1,
    "nama": "Elektronik & Gadget",
    "deskripsi": "Barang elektronik dan gadget"
  }
}
```

---

### 1️⃣7️⃣ **DELETE /categories/{id}** - Delete Kategori

**Deskripsi:** Hapus kategori

```http
DELETE http://34.34.217.136/api/categories/1
Authorization: Bearer {token}
```

**Response (200):**

```json
{
  "message": "Category deleted successfully"
}
```

---

## 🏭 Supplier

### 1️⃣8️⃣ **POST /suppliers** - Create Supplier

**Deskripsi:** Tambah supplier baru

```http
POST http://34.34.217.136/api/suppliers
Authorization: Bearer {token}
Content-Type: application/json

{
  "nama": "PT. Elektronik Indonesia",
  "email": "contact@elektronik.com",
  "telepon": "021-1234567",
  "alamat": "Jl. Merdeka No. 123, Jakarta"
}
```

**Response (201):**

```json
{
  "message": "Supplier created successfully",
  "data": {
    "id": 1,
    "nama": "PT. Elektronik Indonesia",
    "email": "contact@elektronik.com",
    "telepon": "021-1234567",
    "alamat": "Jl. Merdeka No. 123, Jakarta",
    "created_at": "2024-01-15T10:30:00Z"
  }
}
```

---

### 1️⃣9️⃣ **GET /suppliers** - List Supplier

**Deskripsi:** Ambil daftar supplier

```http
GET http://34.34.217.136/api/suppliers
Authorization: Bearer {token}
```

**Response (200):**

```json
[
  {
    "id": 1,
    "nama": "PT. Elektronik Indonesia",
    "email": "contact@elektronik.com",
    "telepon": "021-1234567",
    "alamat": "Jl. Merdeka No. 123, Jakarta"
  }
]
```

---

### 2️⃣0️⃣ **GET /suppliers/{id}** - Get Detail Supplier

**Deskripsi:** Ambil detail supplier

```http
GET http://34.34.217.136/api/suppliers/1
Authorization: Bearer {token}
```

**Response (200):**

```json
{
  "id": 1,
  "nama": "PT. Elektronik Indonesia",
  "email": "contact@elektronik.com",
  "telepon": "021-1234567",
  "alamat": "Jl. Merdeka No. 123, Jakarta"
}
```

---

### 2️⃣1️⃣ **PUT /suppliers/{id}** - Update Supplier

**Deskripsi:** Update supplier

```http
PUT http://34.34.217.136/api/suppliers/1
Authorization: Bearer {token}
Content-Type: application/json

{
  "nama": "PT. Elektronik Indonesia Updated",
  "email": "newemail@elektronik.com"
}
```

**Response (200):**

```json
{
  "message": "Supplier updated successfully",
  "data": {
    "id": 1,
    "nama": "PT. Elektronik Indonesia Updated",
    "email": "newemail@elektronik.com"
  }
}
```

---

### 2️⃣2️⃣ **DELETE /suppliers/{id}** - Delete Supplier

**Deskripsi:** Hapus supplier

```http
DELETE http://34.34.217.136/api/suppliers/1
Authorization: Bearer {token}
```

**Response (200):**

```json
{
  "message": "Supplier deleted successfully"
}
```

---

## 📥 Barang Masuk (Incoming Goods)

### 2️⃣3️⃣ **POST /barang-masuk** - Create Barang Masuk

**Deskripsi:** Tambah transaksi barang masuk (input oleh operator, status awal `pending`).

**Field body (JSON):**

- `id_barang` (integer, **wajib**) – ID barang dari master `barang`.
- `id_supplier` (integer, opsional) – ID supplier dari master `supplier` (boleh `null`).
- `qty` (integer, **wajib**) – jumlah barang yang masuk (minimal 1).
- `tanggal_masuk` (string, **wajib**) – tanggal barang masuk, format `YYYY-MM-DD`.
- `keterangan` (string, opsional) – catatan tambahan untuk transaksi ini.

```http
POST http://34.101.195.103/api/barang-masuk
Authorization: Bearer {token}
Content-Type: application/json

{
  "id_barang": 1,
  "id_supplier": 2,
  "qty": 10,
  "tanggal_masuk": "2025-12-11",
  "keterangan": "Pengadaan awal stok"
}
```

**Response (201):**

```json
{
  "message": "Barang masuk created (pending)",
  "item": {
    "id": 1,
    "id_barang": 1,
    "id_supplier": 2,
    "qty": 10,
    "tanggal_masuk": "2025-12-11",
    "keterangan": "Pengadaan awal stok",
    "id_user": 5,
    "status": "pending",
    "created_at": "2025-12-11T10:30:00.000000Z"
  }
}
```

---

### 2️⃣4️⃣ **GET /barang-masuk** - List Barang Masuk

**Deskripsi:** Ambil daftar transaksi barang masuk (history lengkap, diurutkan terbaru → terlama).

```http
GET http://34.101.195.103/api/barang-masuk
Authorization: Bearer {token}
```

**Response (200):**

```json
[
  {
    "id": 1,
    "id_barang": 1,
    "nama_barang": "Laptop Lenovo ThinkPad",
    "id_supplier": 2,
    "nama_supplier": "PT. Elektronik Indonesia",
    "qty": 10,
    "tanggal_masuk": "2025-12-11",
    "keterangan": "Pengadaan awal stok",
    "id_user": 5,
    "user_name": "Operator Gudang",
    "status": "pending",
    "approved_by": null,
    "approved_at": null,
    "rejected_by": null,
    "rejected_at": null,
    "reject_reason": null,
    "created_at": "2025-12-11T10:30:00.000000Z"
  }
]
```

---

### 2️⃣5️⃣ **PUT /barang-masuk/{id}** - Update Barang Masuk

**Deskripsi:** Update data barang masuk **selama status masih `pending`** (hanya Admin).

Field yang boleh diubah (semua opsional, hanya yang dikirim yang di-update):

- `id_barang` (integer) – ganti referensi barang.
- `id_supplier` (integer/null) – ganti supplier atau kosongkan.
- `qty` (integer) – ubah jumlah barang masuk.
- `tanggal_masuk` (string, `YYYY-MM-DD`) – ubah tanggal masuk.
- `keterangan` (string) – ubah catatan.

```http
PUT http://34.101.195.103/api/barang-masuk/1
Authorization: Bearer {token}
Content-Type: application/json

{
  "qty": 15,
  "keterangan": "Penyesuaian jumlah setelah pengecekan fisik"
}
```

**Response (200):**

```json
{
  "message": "Updated",
  "item": {
    "id": 1,
    "id_barang": 1,
    "id_supplier": 2,
    "qty": 15,
    "tanggal_masuk": "2025-12-11",
    "keterangan": "Penyesuaian jumlah setelah pengecekan fisik",
    "id_user": 5,
    "status": "pending",
    "created_at": "2025-12-11T10:30:00.000000Z"
  }
}
```

---

### 2️⃣6️⃣ **PATCH /barang-masuk/{id}/approve** - Approve Barang Masuk

**Deskripsi:** Approve barang masuk (menambah stok)

```http
PATCH http://34.34.217.136/api/barang-masuk/1/approve
Authorization: Bearer {token}
Content-Type: application/json

{
  "keterangan_approval": "Approved by Manager"
}
```

**Response (200):**

```json
{
  "message": "Incoming goods approved",
  "data": {
    "id": 1,
    "status": "approved",
    "stok_bertambah": 10
  }
}
```

---

### 2️⃣7️⃣ **PATCH /barang-masuk/{id}/reject** - Reject Barang Masuk

**Deskripsi:** Reject barang masuk

```http
PATCH http://34.34.217.136/api/barang-masuk/1/reject
Authorization: Bearer {token}
Content-Type: application/json

{
  "alasan_reject": "Barang rusak"
}
```

**Response (200):**

```json
{
  "message": "Incoming goods rejected",
  "data": {
    "id": 1,
    "status": "rejected"
  }
}
```

---

### 2️⃣8️⃣ **DELETE /barang-masuk/{id}** - Delete Barang Masuk

**Deskripsi:** Hapus barang masuk

```http
DELETE http://34.34.217.136/api/barang-masuk/1
Authorization: Bearer {token}
```

**Response (200):**

```json
{
  "message": "Incoming goods deleted successfully"
}
```

---

#### 🔄 Alur Operator – Barang Masuk

- **Operator – Input Transaksi Barang Masuk (Status Pending)**

  - **Endpoint:** `POST /api/barang-masuk`
  - **Role:** `operator` (dalam implementasi saat ini boleh juga `admin/manager`, namun skenario utama adalah operator gudang yang menginput).
  - **Perilaku:** Membuat record barang-masuk dengan status awal `pending` — **stok belum bertambah** sampai ada approve dari admin/manager.

- **Operator – Lihat Daftar Barang Masuk (Pastikan Pending)**
  - **Endpoint:** `GET /api/barang-masuk`
  - **Role:** `operator`, `admin`, `manager` (siapa pun yang login dapat mengakses daftar ini sesuai UI).
  - **Perilaku:** Menampilkan seluruh transaksi barang-masuk beserta status (`pending`, `approved`, `rejected`) sehingga operator bisa memastikan transaksi yang ia input masih `pending` sebelum disetujui.

### 🔑 Hak Akses & CRUD Barang Masuk

Ringkasan endpoint dan role yang diizinkan untuk fitur Barang Masuk sesuai kode backend (`BarangMasukController`):

| #   | Endpoint                         | Method | Aksi                             | Role yang diizinkan                   |
| --- | -------------------------------- | ------ | -------------------------------- | ------------------------------------- |
| 1   | `/api/barang-masuk`              | GET    | List barang masuk                | Operator, Admin, Manager (user login) |
| 2   | `/api/barang-masuk`              | POST   | Create barang masuk (pending)    | Operator (utama), Admin, Manager      |
| 3   | `/api/barang-masuk/{id}`         | PUT    | Update barang masuk (pending)    | Admin                                 |
| 4   | `/api/barang-masuk/{id}`         | DELETE | Hapus barang masuk               | Admin                                 |
| 5   | `/api/barang-masuk/{id}/approve` | PATCH  | Approve barang masuk (+stok)     | Admin, Manager                        |
| 6   | `/api/barang-masuk/{id}/reject`  | PATCH  | Reject barang masuk (tanpa stok) | Admin, Manager                        |

Catatan:

- Update (`PUT`) dan delete (`DELETE`) hanya diizinkan ketika status masih `pending` menurut logika controller.
- Approve akan menambah stok barang sesuai `qty` pada record terkait.
- Reject tidak mengubah stok, tetapi menyimpan `reject_reason` dan metadata siapa yang menolak.

---

## 📤 Barang Keluar (Outgoing Goods)

### 2️⃣9️⃣ **POST /barang-keluar** - Create Barang Keluar

**Deskripsi:** Operator mencatat transaksi barang keluar secara manual (status awal `pending`).

**Field body (JSON):**

- `id_barang` (integer, **wajib**) – ID barang dari master `barang`.
- `qty` (integer, **wajib**) – jumlah barang keluar (minimal 1).
- `tanggal_keluar` (string, opsional) – tanggal barang keluar, format `YYYY-MM-DD` (default: hari ini jika tidak diisi).
- `keterangan` (string, opsional) – catatan tambahan transaksi barang keluar.
- `id_request` (integer, opsional) – diisi jika barang keluar terkait langsung dengan suatu `RequestBarang` tertentu.

```http
POST http://34.101.195.103/api/barang-keluar
Authorization: Bearer {token}
Content-Type: application/json

{
  "id_barang": 1,
  "qty": 3,
  "tanggal_keluar": "2025-12-11",
  "keterangan": "Barang keluar untuk kebutuhan internal"
}
```

**Role:** `operator` saja (backend menolak role lain).

**Response (201):**

```json
{
  "message": "Barang keluar dicatat",
  "data": {
    "id": 1,
    "id_barang": 1,
    "qty": 3,
    "id_user": 5,
    "tanggal_keluar": "2025-12-11",
    "keterangan": "Barang keluar untuk kebutuhan internal",
    "status": "pending",
    "created_at": "2025-12-11T10:30:00.000000Z"
  }
}
```

---

### 3️⃣0️⃣ **GET /barang-keluar** - List Barang Keluar

**Deskripsi:** Ambil daftar transaksi barang keluar (history lengkap, diurutkan terbaru → terlama).

```http
GET http://34.101.195.103/api/barang-keluar
Authorization: Bearer {token}
```

**Response (200):**

```json
[
  {
    "id": 1,
    "id_barang": 1,
    "nama_barang": "Laptop Lenovo ThinkPad",
    "qty": 3,
    "jumlah_keluar": 3,
    "status": "pending",
    "tanggal_keluar": "2025-12-11",
    "id_user": 5,
    "user_name": "Operator Gudang",
    "id_request": 10,
    "request_user_id": 7,
    "request_from": "Staff Marketing",
    "keterangan": "Barang keluar untuk kebutuhan internal",
    "created_at": "2025-12-11T10:30:00.000000Z",
    "updated_at": "2025-12-11T10:40:00.000000Z"
  }
]
```

**Role:** seluruh user yang sudah login (admin, manager, operator, staff) dapat mengakses list ini.

---

### 3️⃣1️⃣ **PUT /barang-keluar/{id}** - Update Barang Keluar

**Deskripsi:** Update data barang keluar (hanya oleh Admin/Manager).

Field yang dapat diubah (sesuai validasi backend):

- `qty` (integer, **wajib**) – jumlah barang keluar baru.
- `tanggal_keluar` (string, opsional) – ubah tanggal keluar (`YYYY-MM-DD`).
- `keterangan` (string, opsional) – ubah catatan.
- `status` (string, opsional) – salah satu dari `pending`, `approved`, `rejected`, `done`.

```http
PUT http://34.101.195.103/api/barang-keluar/1
Authorization: Bearer {token}
Content-Type: application/json

{
  "qty": 5,
  "keterangan": "Penyesuaian qty sebelum pengiriman",
  "status": "pending"
}
```

**Role:** `admin`, `manager`.

**Response (200):**

```json
{
  "message": "Updated",
  "data": {
    "id": 1,
    "id_barang": 1,
    "qty": 5,
    "tanggal_keluar": "2025-12-11",
    "keterangan": "Penyesuaian qty sebelum pengiriman",
    "status": "pending"
  }
}
```

---

### 3️⃣2️⃣ **POST /barang-keluar/process-request/{id}** - Process Request → Barang Keluar

**Deskripsi:** Operator memproses `RequestBarang` yang sudah **approved** menjadi transaksi barang keluar dan langsung mengurangi stok.

**Catatan penting:**

- `{id}` di path adalah **ID RequestBarang** (bukan ID barang-keluar).
- RequestBarang harus berstatus `approved`, kalau tidak akan ditolak (`422`).

Field body (JSON):

- `qty` (integer, **wajib**) – jumlah yang benar-benar dikeluarkan (boleh ≤ jumlah di request, selama stok cukup).
- `lokasi` (string, opsional) – lokasi tujuan barang.
- `keterangan` (string, opsional) – catatan tambahan.

```http
POST http://34.101.195.103/api/barang-keluar/process-request/10
Authorization: Bearer {token}
Content-Type: application/json

{
  "qty": 3,
  "lokasi": "Ruang Meeting Lt. 2",
  "keterangan": "Pengeluaran barang dari request #10"
}
```

**Role:** `operator` saja.

**Efek:**

- Membuat record baru di tabel `barang_keluar` dengan `status = "done"`.
- Mengurangi `stok` barang di tabel `barang` sebanyak `qty`.
- Mengubah status RequestBarang terkait menjadi `done`.

**Response (201):**

```json
{
  "message": "Processed",
  "data": {
    "id": 1,
    "id_request": 10,
    "id_barang": 1,
    "qty": 3,
    "id_user": 5,
    "tanggal_keluar": "2025-12-11",
    "lokasi": "Ruang Meeting Lt. 2",
    "keterangan": "Pengeluaran barang dari request #10",
    "status": "done"
  }
}
```

---

### 3️⃣3️⃣ **DELETE /barang-keluar/{id}** - Delete Barang Keluar

**Deskripsi:** Hapus record barang keluar.

```http
DELETE http://34.101.195.103/api/barang-keluar/1
Authorization: Bearer {token}
```

**Role:** saat ini di backend **belum** ada pembatasan role khusus (selama pengguna login). Di sisi UI, disarankan hanya Admin yang diberi akses fitur hapus.

**Response (200):**

```json
{
  "message": "Deleted"
}
```

---

#### 🔄 Alur Operator / Admin / Manager – Barang Keluar

- **Operator – Buat Barang Keluar Manual (Pending)**

  - Endpoint: `POST /api/barang-keluar`
  - Status awal: `pending`.
  - Tidak langsung mengubah stok; stok berkurang ketika proses permintaan (`process-request`) atau sesuai kebijakan bisnis (saat ini stok berkurang di `process-request`).

- **Operator – Proses Request Disetujui**

  - Endpoint: `POST /api/barang-keluar/process-request/{requestId}`
  - Hanya untuk RequestBarang berstatus `approved`.
  - Mengurangi stok dan menandai RequestBarang menjadi `done`.

- **Admin/Manager – Review & Koreksi Barang Keluar**

  - Endpoint: `PUT /api/barang-keluar/{id}`
  - Dapat mengubah `qty`, `tanggal_keluar`, `keterangan`, dan `status`.

- **Admin/Manager – Approve / Reject Barang Keluar (Manual)**
  - Endpoint: `PATCH /api/barang-keluar/{id}/approve` dan `PATCH /api/barang-keluar/{id}/reject`.
  - Digunakan jika dibuat alur approval tambahan di atas barang-keluar manual.

### 🔑 Hak Akses & CRUD Barang Keluar

Ringkasan endpoint dan role yang diizinkan untuk fitur Barang Keluar sesuai kode backend (`BarangKeluarController`):

| #   | Endpoint                                  | Method | Aksi                                          | Role yang diizinkan                                |
| --- | ----------------------------------------- | ------ | --------------------------------------------- | -------------------------------------------------- |
| 1   | `/api/barang-keluar`                      | GET    | List barang keluar                            | Semua user login (Admin, Manager, Operator, Staff) |
| 2   | `/api/barang-keluar`                      | POST   | Buat transaksi barang keluar (pending)        | Operator                                           |
| 3   | `/api/barang-keluar/{id}`                 | PUT    | Update data barang keluar                     | Admin, Manager                                     |
| 4   | `/api/barang-keluar/{id}`                 | DELETE | Hapus barang keluar                           | Semua user login (disarankan hanya Admin di UI)    |
| 5   | `/api/barang-keluar/{id}/approve`         | PATCH  | Approve barang keluar                         | Admin, Manager                                     |
| 6   | `/api/barang-keluar/{id}/reject`          | PATCH  | Reject barang keluar                          | Admin, Manager                                     |
| 7   | `/api/barang-keluar/process-request/{id}` | POST   | Proses RequestBarang approved → barang keluar | Operator                                           |

Status yang digunakan di barang-keluar: `pending`, `approved`, `rejected`, `done`.

---

## 📋 Request Barang (Item Requests)

### 3️⃣4️⃣ **POST /request-barang** - Create Request Barang

**Deskripsi:** Buat request barang baru (dari staff)

```http
POST http://34.34.217.136/api/request-barang
Authorization: Bearer {token}
Content-Type: application/json

{
  "barang_id": 1,
  "jumlah": 2,
  "keperluan": "Untuk presentasi klien",
  "tanggal_dibutuhkan": "2024-01-20"
}
```

**Response (201):**

```json
{
  "message": "Request created successfully",
  "data": {
    "id": 1,
    "barang_id": 1,
    "jumlah": 2,
    "status": "pending",
    "created_at": "2024-01-15T10:30:00Z"
  }
}
```

---

### 3️⃣5️⃣ **GET /request-barang** - List Request Barang

**Deskripsi:** Ambil daftar request barang

```http
GET http://34.34.217.136/api/request-barang
Authorization: Bearer {token}
```

**Response (200):**

```json
[
  {
    "id": 1,
    "barang_id": 1,
    "user_id": 2,
    "jumlah": 2,
    "status": "pending",
    "created_at": "2024-01-15T10:30:00Z"
  }
]
```

---

### 3️⃣6️⃣ **PUT /request-barang/{id}** - Update Request Barang

**Deskripsi:** Update request (sebelum diapprove)

```http
PUT http://34.34.217.136/api/request-barang/1
Authorization: Bearer {token}
Content-Type: application/json

{
  "jumlah": 3,
  "keperluan": "Updated requirement"
}
```

**Response (200):**

```json
{
  "message": "Request updated successfully",
  "data": {
    "id": 1,
    "jumlah": 3
  }
}
```

---

### 3️⃣7️⃣ **PUT /request-barang/{id}/status** - Update Status Request

**Deskripsi:** Update status request (approve/reject)

```http
PUT http://34.34.217.136/api/request-barang/1/status
Authorization: Bearer {token}
Content-Type: application/json

{
  "status": "approved",
  "keterangan": "Approved by Manager"
}
```

**Status yang valid:**

- `pending` - Request baru
- `approved` - Disetujui manager
- `rejected` - Ditolak
- `completed` - Sudah diambil

**Response (200):**

```json
{
  "message": "Request status updated",
  "data": {
    "id": 1,
    "status": "approved"
  }
}
```

---

### 3️⃣8️⃣ **DELETE /request-barang/{id}** - Delete Request Barang

**Deskripsi:** Hapus request

```http
DELETE http://34.34.217.136/api/request-barang/1
Authorization: Bearer {token}
```

**Response (200):**

```json
{
  "message": "Request deleted successfully"
}
```

---

## 📊 Reports & Tracking

### 3️⃣9️⃣ **GET /reports** - Get Reports

**Deskripsi:** Ambil laporan inventory

```http
GET http://34.34.217.136/api/reports
Authorization: Bearer {token}
```

**Query Parameters:**

- `filter` - `masuk`, `keluar`, `stock`
- `start_date` - YYYY-MM-DD
- `end_date` - YYYY-MM-DD

**Response (200):**

```json
{
  "total_masuk": 50,
  "total_keluar": 15,
  "total_stok": 35,
  "by_category": [
    {
      "kategori": "Elektronik",
      "stok": 25
    }
  ]
}
```

---

### 4️⃣0️⃣ **GET /tracking** - Track Barang

**Deskripsi:** Tracking history barang

```http
GET http://34.34.217.136/api/tracking
Authorization: Bearer {token}
```

**Query Parameters:**

- `barang_id` - ID barang (required)

**Response (200):**

```json
[
  {
    "id": 1,
    "action": "masuk",
    "jumlah": 10,
    "tanggal": "2024-01-15T10:30:00Z",
    "user": "Supplier XYZ",
    "keterangan": "Barang dari supplier"
  },
  {
    "id": 2,
    "action": "keluar",
    "jumlah": 3,
    "tanggal": "2024-01-16T14:20:00Z",
    "user": "Departemen IT",
    "keterangan": "Untuk kebutuhan internal"
  }
]
```

---

### 4️⃣1️⃣ **GET /debug/reports/stock** - Debug Stock Reports

**Deskripsi:** Debug laporan stok (untuk development)

```http
GET http://34.34.217.136/api/debug/reports/stock
Authorization: Bearer {token}
```

**Response (200):**

```json
{
  "total_items": 10,
  "items": [
    {
      "id": 1,
      "nama": "Laptop Dell XPS 15",
      "stok": 5,
      "last_update": "2024-01-15T10:30:00Z"
    }
  ]
}
```

---

## 🛠️ Utilities

### 4️⃣2️⃣ **GET /sanctum/csrf-cookie**

**Deskripsi:** Ambil CSRF token (jika diperlukan)

```http
GET http://34.34.217.136/sanctum/csrf-cookie
```

---

### 4️⃣3️⃣ **GET /storage/{path}** - Get File Storage

**Deskripsi:** Akses file yang disimpan di storage

```http
GET http://34.34.217.136/storage/uploads/barang/123.jpg
```

---

### 4️⃣4️⃣ **GET /** - Health Check

**Deskripsi:** Cek status aplikasi

```http
GET http://34.34.217.136/
```

**Response (200):**

```
OK
```

---

### 4️⃣5️⃣ **GET /up** - Livewire Health Check

**Deskripsi:** Cek health aplikasi Livewire

```http
GET http://34.34.217.136/up
```

---

## 📌 Urutan Eksekusi Terstruktur (Standard Flow)

### **Phase 1: Setup & Authentication**

1. ✅ **Health Check** → `GET /` atau `GET /up`
2. ✅ **Register User** → `POST /register` (jika belum punya akun)
3. ✅ **Login** → `POST /login`
4. ✅ **Get Current User** → `GET /user`

### **Phase 2: Setup Master Data (Admin)**

5. ✅ **Create Categories** → `POST /categories` (min 3 kategori)
6. ✅ **Create Suppliers** → `POST /suppliers` (min 2 supplier)
7. ✅ **Create Items** → `POST /items` (min 5 items)
8. ✅ **Get Items List** → `GET /items`

### **Phase 3: User Management (Admin)**

9. ✅ **Create Users** → `POST /register` dengan role berbeda
10. ✅ **List Users** → `GET /users`

### **Phase 4: Inventory In (Receiving)**

11. ✅ **Create Barang Masuk** → `POST /barang-masuk`
12. ✅ **List Barang Masuk** → `GET /barang-masuk`
13. ✅ **Approve Barang Masuk** → `PATCH /barang-masuk/{id}/approve`
14. ✅ **Verify Stock Updated** → `GET /items` (stok bertambah)

### **Phase 5: Item Requests (Staff)**

15. ✅ **Create Request Barang** → `POST /request-barang`
16. ✅ **List Requests** → `GET /request-barang`

### **Phase 6: Request Approval (Manager)**

17. ✅ **Approve Request** → `PUT /request-barang/{id}/status` (status: approved)

### **Phase 7: Inventory Out (Operator)**

18. ✅ **Create Barang Keluar** → `POST /barang-keluar`
19. ✅ **List Barang Keluar** → `GET /barang-keluar`
20. ✅ **Process Barang Keluar** → `POST /barang-keluar/process-request/{id}`
21. ✅ **Verify Stock Decreased** → `GET /items` (stok berkurang)

### **Phase 8: Reporting & Tracking**

22. ✅ **Get Reports** → `GET /reports`
23. ✅ **Track Item** → `GET /tracking?barang_id=1`
24. ✅ **Debug Stock** → `GET /debug/reports/stock`

### **Phase 9: Maintenance**

25. ✅ **Update Category** → `PUT /categories/{id}`
26. ✅ **Update Supplier** → `PUT /suppliers/{id}`
27. ✅ **Update Item** → `PUT /items/{id}`
28. ✅ **Update User** → `PUT /users/{id}`

### **Phase 10: Cleanup (Optional)**

29. ✅ **Reject Request** → `PUT /request-barang/{id}/status` (status: rejected)
30. ✅ **Reject Barang Masuk** → `PATCH /barang-masuk/{id}/reject`
31. ✅ **Delete Request** → `DELETE /request-barang/{id}`
32. ✅ **Delete Barang Keluar** → `DELETE /barang-keluar/{id}`
33. ✅ **Delete Item** → `DELETE /items/{id}`
34. ✅ **Delete User** → `DELETE /users/{id}`
35. ✅ **Logout** → `POST /logout`

---

## 🔑 Authentication Headers

**Semua request (kecuali login & register) memerlukan:**

```
Authorization: Bearer {token}
Content-Type: application/json
```

**Contoh lengkap:**

```http
GET http://34.34.217.136/api/items
Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGc...
```

---

## ⚠️ HTTP Status Codes

| Code | Meaning                                 |
| ---- | --------------------------------------- |
| 200  | ✅ Success                              |
| 201  | ✅ Created                              |
| 400  | ❌ Bad Request                          |
| 401  | ❌ Unauthorized (Token invalid/expired) |
| 403  | ❌ Forbidden (Role tidak sesuai)        |
| 404  | ❌ Not Found                            |
| 422  | ❌ Validation Error                     |
| 500  | ❌ Server Error                         |

---

## 💡 Tips

1. **Token Expiration**: Jika dapat error 401, login ulang
2. **Rate Limiting**: Jika banyak request, tunggu sebentar
3. **Validation**: Pastikan data sesuai format (email, date, dll)
4. **Permissions**: Check role user untuk endpoint tertentu
5. **Testing**: Gunakan Postman atau Thunder Client untuk testing

---

**Dokumentasi Update: 2024-12-10**
