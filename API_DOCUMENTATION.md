# 📚 Dokumentasi API Inventory System

**Base URL:** `http://34.34.217.136/api`
**Base URL:** `{{BASE_URL}}` (contoh: `https://api.example.com`)

---

## 📋 Ringkasan

Inventory System API menyediakan sekumpulan endpoint untuk mengelola aset dan stok barang secara terpusat. Fitur utama meliputi autentikasi (token), manajemen pengguna, manajemen item dan kategori, supplier, transaksi barang masuk/keluar, permintaan barang, dan laporan. Semua request/response menggunakan format JSON dan endpoint yang dilindungi memerlukan header otorisasi.

Gunakan collection Postman bernama "Inventory System API" untuk mengelompokkan request: Authentication, Users, Items, Categories, Suppliers, Incoming/Outgoing, Requests, dan Reports.

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

**Deskripsi:** Tambah barang masuk (dari supplier)

```http
POST http://34.34.217.136/api/barang-masuk
Authorization: Bearer {token}
Content-Type: application/json

{
  "barang_id": 1,
  "supplier_id": 1,
  "jumlah": 10,
  "tanggal_masuk": "2024-01-15",
  "nomor_referensi": "REF-001",
  "keterangan": "Barang dari supplier"
}
```

**Response (201):**

```json
{
  "message": "Incoming goods created successfully",
  "data": {
    "id": 1,
    "barang_id": 1,
    "supplier_id": 1,
    "jumlah": 10,
    "tanggal_masuk": "2024-01-15",
    "status": "pending",
    "created_at": "2024-01-15T10:30:00Z"
  }
}
```

---

### 2️⃣4️⃣ **GET /barang-masuk** - List Barang Masuk

**Deskripsi:** Ambil daftar barang masuk

```http
GET http://34.34.217.136/api/barang-masuk
Authorization: Bearer {token}
```

**Response (200):**

```json
[
  {
    "id": 1,
    "barang_id": 1,
    "supplier_id": 1,
    "jumlah": 10,
    "tanggal_masuk": "2024-01-15",
    "status": "pending",
    "created_at": "2024-01-15T10:30:00Z"
  }
]
```

---

### 2️⃣5️⃣ **PUT /barang-masuk/{id}** - Update Barang Masuk

**Deskripsi:** Update barang masuk (sebelum diapprove)

```http
PUT http://34.34.217.136/api/barang-masuk/1
Authorization: Bearer {token}
Content-Type: application/json

{
  "jumlah": 15,
  "keterangan": "Updated"
}
```

**Response (200):**

```json
{
  "message": "Incoming goods updated successfully",
  "data": {
    "id": 1,
    "jumlah": 15
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

## 📤 Barang Keluar (Outgoing Goods)

### 2️⃣9️⃣ **POST /barang-keluar** - Create Barang Keluar

**Deskripsi:** Tambah barang keluar

```http
POST http://34.34.217.136/api/barang-keluar
Authorization: Bearer {token}
Content-Type: application/json

{
  "barang_id": 1,
  "jumlah": 3,
  "tanggal_keluar": "2024-01-15",
  "tujuan": "Departemen IT",
  "keterangan": "Untuk kebutuhan internal"
}
```

**Response (201):**

```json
{
  "message": "Outgoing goods created successfully",
  "data": {
    "id": 1,
    "barang_id": 1,
    "jumlah": 3,
    "tanggal_keluar": "2024-01-15",
    "status": "pending",
    "created_at": "2024-01-15T10:30:00Z"
  }
}
```

---

### 3️⃣0️⃣ **GET /barang-keluar** - List Barang Keluar

**Deskripsi:** Ambil daftar barang keluar

```http
GET http://34.34.217.136/api/barang-keluar
Authorization: Bearer {token}
```

**Response (200):**

```json
[
  {
    "id": 1,
    "barang_id": 1,
    "jumlah": 3,
    "tanggal_keluar": "2024-01-15",
    "status": "pending",
    "created_at": "2024-01-15T10:30:00Z"
  }
]
```

---

### 3️⃣1️⃣ **PUT /barang-keluar/{id}** - Update Barang Keluar

**Deskripsi:** Update barang keluar (sebelum diprocess)

```http
PUT http://34.34.217.136/api/barang-keluar/1
Authorization: Bearer {token}
Content-Type: application/json

{
  "jumlah": 5,
  "keterangan": "Updated"
}
```

**Response (200):**

```json
{
  "message": "Outgoing goods updated successfully",
  "data": {
    "id": 1,
    "jumlah": 5
  }
}
```

---

### 3️⃣2️⃣ **POST /barang-keluar/process-request/{id}** - Process Barang Keluar

**Deskripsi:** Process/approve barang keluar (mengurangi stok)

```http
POST http://34.34.217.136/api/barang-keluar/process-request/1
Authorization: Bearer {token}
Content-Type: application/json

{
  "keterangan": "Processed by operator"
}
```

**Response (200):**

```json
{
  "message": "Outgoing goods processed",
  "data": {
    "id": 1,
    "status": "processed",
    "stok_berkurang": 3
  }
}
```

---

### 3️⃣3️⃣ **DELETE /barang-keluar/{id}** - Delete Barang Keluar

**Deskripsi:** Hapus barang keluar

```http
DELETE http://34.34.217.136/api/barang-keluar/1
Authorization: Bearer {token}
```

**Response (200):**

```json
{
  "message": "Outgoing goods deleted successfully"
}
```

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
