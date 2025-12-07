-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 07, 2025 at 01:00 PM
-- Server version: 8.4.3
-- PHP Version: 8.4.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `project_inventory`
--

-- --------------------------------------------------------

--
-- Table structure for table `barang`
--

CREATE TABLE `barang` (
  `id` bigint UNSIGNED NOT NULL,
  `kode_barang` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nama_barang` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_kategori` bigint UNSIGNED DEFAULT NULL,
  `satuan` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `harga` decimal(15,2) NOT NULL DEFAULT '0.00',
  `stok` int NOT NULL DEFAULT '0',
  `stok_minimum` int NOT NULL DEFAULT '0',
  `lokasi` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `qr_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `id_supplier` bigint UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `barang`
--

INSERT INTO `barang` (`id`, `kode_barang`, `nama_barang`, `id_kategori`, `satuan`, `harga`, `stok`, `stok_minimum`, `lokasi`, `qr_code`, `created_at`, `updated_at`, `id_supplier`) VALUES
(3, 'BRG5A7E1C', 'Beng Beng', 4, 'pcs', 5000.00, 100, 0, 'A13', NULL, '2025-11-24 07:48:53', '2025-12-03 02:24:30', 2),
(4, 'BRG2DBC02', 'Taro Kentang', 1, 'pcs', 2000.00, 105, 0, 'A13', NULL, '2025-11-24 07:55:46', '2025-12-03 02:18:29', 3),
(6, 'BRG-1001', 'Roma Gandum', 2, 'pcs', 3000.00, 100, 5, 'Rak A1', NULL, '2025-11-25 03:27:19', '2025-12-03 02:01:06', 4),
(7, 'BRG-1002', 'Milk Susu', 2, 'pcs', 4000.00, 98, 3, 'Rak A3', NULL, '2025-11-25 03:27:19', '2025-12-03 02:01:34', 4),
(8, 'BRG-2001', 'Kopiko', 3, 'pack', 6000.00, 90, 10, 'Rak B1', NULL, '2025-11-25 03:27:19', '2025-11-25 20:59:11', 3),
(10, 'BRG934177', 'Panadol Extra', 4, 'Kapsul', 2000.00, 50, 0, 'A16', NULL, '2025-12-03 20:45:13', '2025-12-03 20:45:13', 2);

-- --------------------------------------------------------

--
-- Table structure for table `barang_keluar`
--

CREATE TABLE `barang_keluar` (
  `id` bigint UNSIGNED NOT NULL,
  `id_barang` bigint UNSIGNED NOT NULL,
  `qty` int NOT NULL,
  `lokasi` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tanggal_keluar` date NOT NULL,
  `id_user` bigint UNSIGNED NOT NULL,
  `id_request` bigint UNSIGNED DEFAULT NULL,
  `keterangan` text COLLATE utf8mb4_unicode_ci,
  `status` enum('pending','approved','rejected','done') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `barang_keluar`
--

INSERT INTO `barang_keluar` (`id`, `id_barang`, `qty`, `lokasi`, `tanggal_keluar`, `id_user`, `id_request`, `keterangan`, `status`, `created_at`, `updated_at`) VALUES
(7, 8, 10, 'Jatitujuh', '2025-11-26', 10, 6, 'ambil aja sob', 'done', '2025-11-25 20:59:11', '2025-11-25 20:59:11'),
(8, 4, 5, 'Jatiuwunung', '2025-11-26', 10, 7, 'haiop', 'done', '2025-11-25 21:38:12', '2025-11-25 21:38:12'),
(9, 7, 2, 'Toko saya', '2025-11-26', 3, 8, 'wajib', 'done', '2025-11-26 01:13:28', '2025-11-26 01:13:28');

-- --------------------------------------------------------

--
-- Table structure for table `barang_masuk`
--

CREATE TABLE `barang_masuk` (
  `id` bigint UNSIGNED NOT NULL,
  `id_barang` bigint UNSIGNED NOT NULL,
  `id_supplier` bigint UNSIGNED DEFAULT NULL,
  `qty` int NOT NULL,
  `tanggal_masuk` date NOT NULL,
  `keterangan` text COLLATE utf8mb4_unicode_ci,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `approved_by` bigint UNSIGNED DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `rejected_by` bigint UNSIGNED DEFAULT NULL,
  `rejected_at` timestamp NULL DEFAULT NULL,
  `reject_reason` text COLLATE utf8mb4_unicode_ci,
  `id_user` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `barang_masuk`
--

INSERT INTO `barang_masuk` (`id`, `id_barang`, `id_supplier`, `qty`, `tanggal_masuk`, `keterangan`, `status`, `approved_by`, `approved_at`, `rejected_by`, `rejected_at`, `reject_reason`, `id_user`, `created_at`, `updated_at`) VALUES
(5, 4, 2, 10, '2025-11-26', 'nambah 10 gaksih', 'approved', 5, '2025-11-25 21:23:37', NULL, NULL, NULL, 10, '2025-11-25 21:04:33', '2025-11-25 21:23:37');

-- --------------------------------------------------------

--
-- Table structure for table `kategori`
--

CREATE TABLE `kategori` (
  `id` bigint UNSIGNED NOT NULL,
  `nama_kategori` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deskripsi` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `kategori`
--

INSERT INTO `kategori` (`id`, `nama_kategori`, `deskripsi`, `created_at`, `updated_at`) VALUES
(1, 'Umum', 'Kategori bawaan untuk seed', '2025-11-23 20:22:39', '2025-11-23 20:22:39'),
(2, 'Elektronik', 'Perangkat elektronik dan aksesoris', '2025-11-25 03:27:19', '2025-12-03 20:38:19'),
(3, 'Konsumabel', 'Barang habis pakai', '2025-11-25 03:27:19', '2025-11-25 03:27:19'),
(4, 'Obat', 'BPOM', '2025-12-03 02:17:21', '2025-12-03 02:17:21'),
(5, 'Snack', 'Makanan Ringan', '2025-12-03 20:37:30', '2025-12-03 20:37:30');

-- --------------------------------------------------------

--
-- Table structure for table `log_aktivitas`
--

CREATE TABLE `log_aktivitas` (
  `id` bigint UNSIGNED NOT NULL,
  `id_user` bigint UNSIGNED NOT NULL,
  `aktivitas` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `waktu` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `log_aktivitas`
--

INSERT INTO `log_aktivitas` (`id`, `id_user`, `aktivitas`, `waktu`) VALUES
(1, 5, 'Rejected barang_masuk id=1 by user=5 reason=test', '2025-11-24 15:17:30'),
(2, 5, 'Approved barang_masuk id=2 by user=5', '2025-11-24 15:18:19'),
(3, 5, 'Approved barang_masuk id=4 by user=5', '2025-11-25 20:47:02'),
(4, 5, 'Approved barang_masuk id=5 by user=5', '2025-11-25 21:23:37');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2025_11_24_013452_create_users_table', 1),
(2, '2025_11_24_013504_create_kategori_table', 1),
(3, '2025_11_24_013513_create_supplier_table', 1),
(4, '2025_11_24_013536_create_barang_table', 1),
(5, '2025_11_24_013547_create_barang_masuk_table', 1),
(6, '2025_11_24_013624_create_request_barang_table', 1),
(7, '2025_11_24_013627_create_barang_keluar_table', 1),
(8, '2025_11_24_013643_create_log_aktivitas_table', 1),
(9, '2025_11_24_021044_create_personal_access_tokens_table', 1),
(10, '2025_11_24_022609_create_sessions_table', 1),
(11, '2025_11_24_150000_add_supplier_and_price_to_barang_table', 2),
(12, '2025_11_24_160000_make_id_kategori_nullable_on_barang', 3),
(13, '2025_11_25_000001_add_status_and_approval_to_barang_masuk', 4),
(14, '2025_11_25_010000_add_status_to_barang_keluar_table', 5),
(15, '2025_11_25_020000_add_lokasi_to_barang_keluar_table', 6);

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint UNSIGNED NOT NULL,
  `name` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(4, 'App\\Models\\User', 1, 'token', '2f2dcd426d724a5ea883ae8a76e3c106d501413b49680e0f80cff7b85e8cb703', '[\"*\"]', NULL, NULL, '2025-11-23 20:02:45', '2025-11-23 20:02:45'),
(5, 'App\\Models\\User', 1, 'token', '74a5210f4bc6cf82deb34b1f247a70f27fe9b27514e245cc4fa6d766c5bf7a7a', '[\"*\"]', NULL, NULL, '2025-11-23 20:07:18', '2025-11-23 20:07:18'),
(6, 'App\\Models\\User', 1, 'token', '88162715847eb01d058f99f25ab463032bedcb9310bce5e6dcb4e2dbd5c6d042', '[\"*\"]', '2025-11-23 20:09:14', NULL, '2025-11-23 20:08:30', '2025-11-23 20:09:14'),
(10, 'App\\Models\\User', 2, 'token', '2a80e4fcf660219b4cda74da26236cf675ec9d1607c7f37b9d90e9b11018f64a', '[\"*\"]', '2025-11-23 20:25:17', NULL, '2025-11-23 20:23:22', '2025-11-23 20:25:17'),
(11, 'App\\Models\\User', 2, 'token', '6a581d17ba855c2f5245f46432a50a7f72195fca7808a71770a5122f77d99b5e', '[\"*\"]', '2025-11-23 20:41:30', NULL, '2025-11-23 20:38:53', '2025-11-23 20:41:30'),
(12, 'App\\Models\\User', 2, 'token', '1b73e90190826c1046f80ef356fa2a4d9d7e6e26517007ca89897af61101e688', '[\"*\"]', NULL, NULL, '2025-11-23 20:43:49', '2025-11-23 20:43:49'),
(15, 'App\\Models\\User', 5, 'token', 'f3f90c38bd5e1388a32359ec98d50859342e2977541cac3a3ba5ebff8a2db10b', '[\"*\"]', NULL, NULL, '2025-11-23 21:36:04', '2025-11-23 21:36:04'),
(16, 'App\\Models\\User', 5, 'token', '93fe9f5c1c63d6e4dcce4a1ef1d0e879d5c6b05153fa501e8a63acfc3c0d4c22', '[\"*\"]', NULL, NULL, '2025-11-23 23:17:40', '2025-11-23 23:17:40'),
(17, 'App\\Models\\User', 2, 'token', 'b260e4f1c562fa6e380d7280a014675b366fc5091a33e1c0e91d4d23cb976189', '[\"*\"]', NULL, NULL, '2025-11-23 23:18:55', '2025-11-23 23:18:55'),
(18, 'App\\Models\\User', 3, 'token', 'f63017bdeadcc0b5ba0f7a1c03cc1324c0404e28dd76747529591db0dbcebc91', '[\"*\"]', NULL, NULL, '2025-11-23 23:19:44', '2025-11-23 23:19:44'),
(19, 'App\\Models\\User', 4, 'token', '8c8a5362d3b8a3a540ee22e8b85697b4c6cee1e521124ca64464014224e891c3', '[\"*\"]', NULL, NULL, '2025-11-23 23:20:16', '2025-11-23 23:20:16'),
(20, 'App\\Models\\User', 2, 'token', '139737d3b199edec46588f6a658982bb1cc54893763cefd81cf6c284c871ce08', '[\"*\"]', NULL, NULL, '2025-11-23 23:20:52', '2025-11-23 23:20:52'),
(21, 'App\\Models\\User', 2, 'token', '3c3c8272b1158c58fee668357f518ae9027099d288bc027252b9cc9703a79024', '[\"*\"]', NULL, NULL, '2025-11-23 23:21:48', '2025-11-23 23:21:48'),
(22, 'App\\Models\\User', 4, 'token', 'ea440c68add0d267acfd062b6ea8b6a212ca7bdcf8ca4cb65ac5f5970fce6eb1', '[\"*\"]', NULL, NULL, '2025-11-23 23:22:26', '2025-11-23 23:22:26'),
(23, 'App\\Models\\User', 6, 'token', '2ff4cd977044ed7a556c788ca51520b57904f2130a6e2e06bd40bc91c1e27ad3', '[\"*\"]', NULL, NULL, '2025-11-23 23:24:46', '2025-11-23 23:24:46'),
(24, 'App\\Models\\User', 6, 'token', '7478928f71663a01a048844c3d00faaf710b0e6fb7d00641de9d716db9141e12', '[\"*\"]', NULL, NULL, '2025-11-23 23:25:23', '2025-11-23 23:25:23'),
(25, 'App\\Models\\User', 6, 'token', '7e7e2cdd48aca391486c688ce06106f974b16aa61a363394d6fa8257d275fdf6', '[\"*\"]', NULL, NULL, '2025-11-23 23:29:20', '2025-11-23 23:29:20'),
(26, 'App\\Models\\User', 5, 'token', '84e17949abe814ad0ff55399a5365a99865fb8e9584dee518f96523cfd1f032e', '[\"*\"]', NULL, NULL, '2025-11-24 00:53:28', '2025-11-24 00:53:28'),
(27, 'App\\Models\\User', 5, 'token', '90b4564c77e3f9db331c53ff1f364767b3e8cf7025584bb7ffc184957bee9e4a', '[\"*\"]', NULL, NULL, '2025-11-24 01:01:18', '2025-11-24 01:01:18'),
(28, 'App\\Models\\User', 5, 'token', '7eb239581ac8636eba77eac150686632e649b1917a3f6b01adaa9a8185be5ba0', '[\"*\"]', '2025-11-24 01:07:00', NULL, '2025-11-24 01:05:38', '2025-11-24 01:07:00'),
(29, 'App\\Models\\User', 5, 'token', '74bbc2257cdc99263cc2115b13e4ef5cf487936039b9f5e58712f75a0b69c4bc', '[\"*\"]', '2025-11-24 06:59:10', NULL, '2025-11-24 06:53:57', '2025-11-24 06:59:10'),
(30, 'App\\Models\\User', 5, 'token', '9deb254a79c3bd88f2abe0fe47a82171fd225aa6c53a5e808ef76f44091adefe', '[\"*\"]', '2025-11-24 07:04:23', NULL, '2025-11-24 07:02:52', '2025-11-24 07:04:23'),
(31, 'App\\Models\\User', 5, 'token', '434f45e26c453f3d765547fba86f44637db24ab3e997f103853ce25ae6342cb1', '[\"*\"]', '2025-11-24 07:13:29', NULL, '2025-11-24 07:11:35', '2025-11-24 07:13:29'),
(32, 'App\\Models\\User', 5, 'token', 'fed8412331ce0ae537c28db5e7471f57175d8fbd970487f46e0b5ad034085a40', '[\"*\"]', '2025-11-24 07:17:35', NULL, '2025-11-24 07:17:03', '2025-11-24 07:17:35'),
(33, 'App\\Models\\User', 5, 'token', 'f6d121fa3b92c44b425de9bd2b4d1502cc7399c6083dae3299722b222c27d270', '[\"*\"]', '2025-11-24 07:23:29', NULL, '2025-11-24 07:22:51', '2025-11-24 07:23:29'),
(34, 'App\\Models\\User', 5, 'token', '01885d8a5ed6be74bb2038b682381c0a5b96d85556f1f1e2b35df58b45c50b49', '[\"*\"]', '2025-11-24 07:27:55', NULL, '2025-11-24 07:27:18', '2025-11-24 07:27:55'),
(35, 'App\\Models\\User', 8, 'token', '596404dacd4b8a18d31dedac9accde3ee80b3886d24e3091a2efb125cedceeb8', '[\"*\"]', '2025-11-24 07:55:46', NULL, '2025-11-24 07:34:03', '2025-11-24 07:55:46'),
(36, 'App\\Models\\User', 5, 'token', '9b5101f65914ac6f7f1985132162fe7de4b90190c846de83511c45e1177822b5', '[\"*\"]', '2025-11-24 07:59:32', NULL, '2025-11-24 07:58:13', '2025-11-24 07:59:32'),
(37, 'App\\Models\\User', 5, 'token', 'a7c1cc5a37fea1da7e488bc287778848cf7b887f13da4a6ff0765e617cd25880', '[\"*\"]', '2025-11-24 14:59:56', NULL, '2025-11-24 14:58:35', '2025-11-24 14:59:56'),
(38, 'App\\Models\\User', 5, 'token', 'f135e54fe53a4cef09d687675d6fa32dcb9005981a2f680cdd05efa1ee4bf9e9', '[\"*\"]', '2025-11-24 15:21:11', NULL, '2025-11-24 15:16:21', '2025-11-24 15:21:11'),
(39, 'App\\Models\\User', 5, 'token', '33831217103e173e2dad8e0f2edf3e760eca3a32d2d5d3c839d2c32469558670', '[\"*\"]', '2025-11-24 15:53:34', NULL, '2025-11-24 15:52:02', '2025-11-24 15:53:34'),
(40, 'App\\Models\\User', 5, 'token', 'c24211c8d26eee3f20463b181f8824a61cd13a7b67253c0248580ecf2206fbf4', '[\"*\"]', '2025-11-24 16:03:25', NULL, '2025-11-24 16:03:16', '2025-11-24 16:03:25'),
(41, 'App\\Models\\User', 5, 'token', '4aa40fc3d5fecb54cab7ce730af14cd3e210afec2c9036853b4df45d3044f78f', '[\"*\"]', '2025-11-24 19:56:28', NULL, '2025-11-24 19:56:09', '2025-11-24 19:56:28'),
(42, 'App\\Models\\User', 5, 'token', 'feab64750c8ba7ab18321ac150ebebf01b61ae2b587925a1329f668fcd72f843', '[\"*\"]', '2025-11-24 20:21:11', NULL, '2025-11-24 20:21:05', '2025-11-24 20:21:11'),
(43, 'App\\Models\\User', 5, 'token', '5221d02d4a5611b44b3956a0209aec4f257f4d07c4f72fd03b434912aef4d3c7', '[\"*\"]', '2025-11-24 20:34:08', NULL, '2025-11-24 20:33:24', '2025-11-24 20:34:08'),
(44, 'App\\Models\\User', 5, 'token', '558487ff5c408e2f0998d2a9147b89ac0a92753c1d4c4fec21cb493c9f02623b', '[\"*\"]', '2025-11-24 20:47:15', NULL, '2025-11-24 20:45:59', '2025-11-24 20:47:15'),
(45, 'App\\Models\\User', 5, 'token', '6b7a8a7722222ea1f96d8004439f62af0b5824efbf6eae207bcbfcce98d9ce98', '[\"*\"]', '2025-11-24 20:56:33', NULL, '2025-11-24 20:55:00', '2025-11-24 20:56:33'),
(46, 'App\\Models\\User', 5, 'token', 'ecc07896a73f87ca04fd50df66aaf2e0df37d66ce5573904c9085c6f30edfe3c', '[\"*\"]', '2025-11-24 21:24:11', NULL, '2025-11-24 21:18:03', '2025-11-24 21:24:11'),
(47, 'App\\Models\\User', 3, 'token', '15fb19c6ec1053b39d40d0d52e90f0ef907e79e26d3f243016bf767fa64f09c8', '[\"*\"]', NULL, NULL, '2025-11-24 21:54:33', '2025-11-24 21:54:33'),
(48, 'App\\Models\\User', 3, 'token', 'a221245f0be5bb28ae2163a985e5b4d543a6846453121f2a24fefa6b4ffb5c85', '[\"*\"]', NULL, NULL, '2025-11-24 21:55:06', '2025-11-24 21:55:06'),
(49, 'App\\Models\\User', 3, 'token', 'b8a18ec652a2ec1747f9fe2195f12c5f7028b58669b46322ba6c3e3debf4077d', '[\"*\"]', NULL, NULL, '2025-11-24 21:56:00', '2025-11-24 21:56:00'),
(50, 'App\\Models\\User', 5, 'token', '866312ae438df037d9247997b66c0f819dc77f7e947b497d370cbc0040e2ffd7', '[\"*\"]', NULL, NULL, '2025-11-24 21:56:49', '2025-11-24 21:56:49'),
(51, 'App\\Models\\User', 3, 'token', 'da5fbde58e4aabc31ffd06dffe693a9c15248459334d79d020f51b174f61c831', '[\"*\"]', NULL, NULL, '2025-11-24 21:57:16', '2025-11-24 21:57:16'),
(52, 'App\\Models\\User', 5, 'token', 'dca6acf4d5decb8dce7eb7c91b858a20fedcd0f85ed812e41f5339892930534d', '[\"*\"]', '2025-11-24 21:58:26', NULL, '2025-11-24 21:57:38', '2025-11-24 21:58:26'),
(53, 'App\\Models\\User', 9, 'token', 'fbb308ffffec7f7122dde09d0a5d623b2d59b8d05226b1785891380ecd5c38eb', '[\"*\"]', NULL, NULL, '2025-11-24 21:59:03', '2025-11-24 21:59:03'),
(54, 'App\\Models\\User', 4, 'token', '18ea716aa4a1485a4e007217288d4413784080c1592ad8b8d2058af76b43c946', '[\"*\"]', NULL, NULL, '2025-11-24 22:08:54', '2025-11-24 22:08:54'),
(55, 'App\\Models\\User', 6, 'token', '82c5e2c60bc2fb0c99a7662088f1518ce44f8866f4b7201c3b2ceeb0aac5a934', '[\"*\"]', NULL, NULL, '2025-11-24 22:16:50', '2025-11-24 22:16:50'),
(56, 'App\\Models\\User', 9, 'token', '1af88a871aa4b7a663293a60bba96ddec0c6cfbd56dc84eb3eeaf9c3cea83634', '[\"*\"]', NULL, NULL, '2025-11-24 22:17:39', '2025-11-24 22:17:39'),
(57, 'App\\Models\\User', 10, 'token', 'aeede2a1651af2431015090c14300b999b2b0252486f0f7fc0d01d814594f0a6', '[\"*\"]', NULL, NULL, '2025-11-24 22:30:46', '2025-11-24 22:30:46'),
(58, 'App\\Models\\User', 10, 'token', '6cb903cb0ae1408ba4d3fa0550f76c38c1da2f996949bf3885e1b44318e589cc', '[\"*\"]', NULL, NULL, '2025-11-24 22:40:02', '2025-11-24 22:40:02'),
(59, 'App\\Models\\User', 10, 'token', '48a14dcc1ac1a3c58bd7c12dcf3085b8d2a68454f44a862a5713bb6ba5732f09', '[\"*\"]', '2025-11-25 02:38:17', NULL, '2025-11-25 02:38:02', '2025-11-25 02:38:17'),
(60, 'App\\Models\\User', 10, 'token', '81e54571b8d4694f80e49c438df7e8c870cade1b907608d01fceab3f7eea609b', '[\"*\"]', '2025-11-25 02:44:11', NULL, '2025-11-25 02:43:57', '2025-11-25 02:44:11'),
(61, 'App\\Models\\User', 10, 'token', '144b844c4a463196e852ebf51cb2021b63d065f7e1f7cb6a637dc9abcf9586fe', '[\"*\"]', '2025-11-25 02:48:06', NULL, '2025-11-25 02:47:59', '2025-11-25 02:48:06'),
(62, 'App\\Models\\User', 10, 'token', '4b1acd741d2a8f018d006473a320fe4bdab5a00cd7deab48497eb5da1ca75458', '[\"*\"]', NULL, NULL, '2025-11-25 02:48:44', '2025-11-25 02:48:44'),
(63, 'App\\Models\\User', 10, 'token', '127a5d29a51584caa921ede973ef5c9cc8a3d3a637ab421d4187b62b8e0da53e', '[\"*\"]', '2025-11-25 02:58:58', NULL, '2025-11-25 02:57:56', '2025-11-25 02:58:58'),
(64, 'App\\Models\\User', 10, 'token', '6c3143befe0fad509e96b8fb3201689672d669dda1452b52bfcf0548f39b5e8b', '[\"*\"]', '2025-11-25 03:05:06', NULL, '2025-11-25 03:04:40', '2025-11-25 03:05:06'),
(65, 'App\\Models\\User', 10, 'token', '7c2d02f67759fb2830e0116d6c644b5d6d41728409318ee37996701ad35dc13e', '[\"*\"]', NULL, NULL, '2025-11-25 03:12:09', '2025-11-25 03:12:09'),
(66, 'App\\Models\\User', 10, 'token', '708898eb61c835e400f5e20ad45205e458dbb7d28cbb24649afa1d2c4da1bef6', '[\"*\"]', NULL, NULL, '2025-11-25 03:16:01', '2025-11-25 03:16:01'),
(67, 'App\\Models\\User', 5, 'token', '5b8345494eb3c6788af762cac3298acc96e7b295d6f9fd0a3cc77e10f0408849', '[\"*\"]', '2025-11-25 03:17:32', NULL, '2025-11-25 03:16:37', '2025-11-25 03:17:32'),
(68, 'App\\Models\\User', 5, 'token', '28f4bf22830a004e5a197ead9277e498b7531e3b7171b49738ad631ade7756da', '[\"*\"]', '2025-11-25 03:32:20', NULL, '2025-11-25 03:31:47', '2025-11-25 03:32:20'),
(69, 'App\\Models\\User', 5, 'token', 'cfae0901f5c25a2efb456b5c4d75e18e258d6d1fc6c66767b3731cac0b9619ce', '[\"*\"]', '2025-11-25 03:41:02', NULL, '2025-11-25 03:40:27', '2025-11-25 03:41:02'),
(70, 'App\\Models\\User', 5, 'token', '934ea4245655ff646a096a269bdb85e3b6b408f74ca09b8b10c20f55854004b7', '[\"*\"]', '2025-11-25 03:49:51', NULL, '2025-11-25 03:49:43', '2025-11-25 03:49:51'),
(71, 'App\\Models\\User', 5, 'token', 'f3312ffe285d9e722eb7ed7c7a14b23c6741b658148a8aedffe7d829e0b28e6a', '[\"*\"]', '2025-11-25 03:57:45', NULL, '2025-11-25 03:54:17', '2025-11-25 03:57:45'),
(72, 'App\\Models\\User', 5, 'token', 'c61ec61767e020d2cbb7b7af23034ff3fb92a8ea83a92ba8fb618724526f5495', '[\"*\"]', '2025-11-25 04:00:19', NULL, '2025-11-25 03:59:16', '2025-11-25 04:00:19'),
(73, 'App\\Models\\User', 5, 'token', '143f138ee4d148b8f243ce8ef632846b0538a014a478d879274cfb42dc5fe41b', '[\"*\"]', '2025-11-25 04:57:57', NULL, '2025-11-25 04:52:48', '2025-11-25 04:57:57'),
(74, 'App\\Models\\User', 5, 'token', '3b4d8d314a5333253bb958dc865f12945f6fce01c13a6cea50b25c812750858f', '[\"*\"]', '2025-11-25 05:12:18', NULL, '2025-11-25 05:11:18', '2025-11-25 05:12:18'),
(75, 'App\\Models\\User', 5, 'token', 'e3238f0b8ecf8efa3730928ac77e3bf4e2238dc8796a08cdc4551aa7201df6a0', '[\"*\"]', '2025-11-25 17:16:06', NULL, '2025-11-25 17:15:40', '2025-11-25 17:16:06'),
(76, 'App\\Models\\User', 6, 'token', '9a18f69ab82050cf50c9df5a60ec610c6bb91aae85752d2261f5724188904b29', '[\"*\"]', NULL, NULL, '2025-11-25 17:25:02', '2025-11-25 17:25:02'),
(77, 'App\\Models\\User', 6, 'token', '1be79f19078c1dbaa57d3014e2faacc86fcd2dac899a189bb0dc01c75dd3e408', '[\"*\"]', '2025-11-25 17:54:21', NULL, '2025-11-25 17:53:10', '2025-11-25 17:54:21'),
(78, 'App\\Models\\User', 10, 'token', '9ae7f0eaca7363b638dddc3e72fddd9376a49de3da0e5fa48c3c8f68fe9f4f87', '[\"*\"]', NULL, NULL, '2025-11-25 17:55:33', '2025-11-25 17:55:33'),
(79, 'App\\Models\\User', 5, 'token', '984739e12899e6c27ed4b9653c38c33c4d6c6e5c053e57b7147752e0242a5651', '[\"*\"]', '2025-11-25 17:58:01', NULL, '2025-11-25 17:56:29', '2025-11-25 17:58:01'),
(80, 'App\\Models\\User', 6, 'token', '51939ef0ad7b086e4e98754507026aa37551d5e9432f9da4863610b2a4247080', '[\"*\"]', '2025-11-25 18:07:35', NULL, '2025-11-25 18:07:12', '2025-11-25 18:07:35'),
(81, 'App\\Models\\User', 5, 'token', '9dc0ccc1e2e0cdfe1384405d0655508d917bc3479f3bc01a81c79e170cf0e13f', '[\"*\"]', '2025-11-25 18:08:04', NULL, '2025-11-25 18:07:57', '2025-11-25 18:08:04'),
(82, 'App\\Models\\User', 5, 'token', '15f28236d5167057e883453c785a5c1beb99fe42ccb35588e7fbd48991e157fa', '[\"*\"]', '2025-11-25 18:14:26', NULL, '2025-11-25 18:13:16', '2025-11-25 18:14:26'),
(83, 'App\\Models\\User', 5, 'token', '7bab95d1d77f047790becd5b46926525b6100e77b9e83379edbdcc88eda7fd20', '[\"*\"]', '2025-11-25 18:22:41', NULL, '2025-11-25 18:21:52', '2025-11-25 18:22:41'),
(84, 'App\\Models\\User', 10, 'token', '68e5c3e04bf6d488534c7cb40d19ce28b260d255c69f15803b4156774af76c2d', '[\"*\"]', '2025-11-25 18:27:57', NULL, '2025-11-25 18:25:38', '2025-11-25 18:27:57'),
(85, 'App\\Models\\User', 4, 'token', 'cc58b0f53f9d3a1d1c99f1aab66f6bdc324f18362d3e74cf611c1aaee7b64192', '[\"*\"]', NULL, NULL, '2025-11-25 18:34:02', '2025-11-25 18:34:02'),
(86, 'App\\Models\\User', 5, 'token', '9b0414c6b1533eb5551146fe0be2aca8b740cc6039f18b665324fe1daa07b725', '[\"*\"]', '2025-11-25 18:35:30', NULL, '2025-11-25 18:35:12', '2025-11-25 18:35:30'),
(87, 'App\\Models\\User', 10, 'token', 'dd95867117ebbf9ecd1fd809919718243ba379700378f84b589c915411473615', '[\"*\"]', '2025-11-25 18:37:11', NULL, '2025-11-25 18:36:02', '2025-11-25 18:37:11'),
(88, 'App\\Models\\User', 4, 'token', 'f84df5e744253350c6a656c97def0d7ded0a4d4adc9c43e5de0b04064bae2369', '[\"*\"]', NULL, NULL, '2025-11-25 18:40:32', '2025-11-25 18:40:32'),
(89, 'App\\Models\\User', 4, 'token', 'd9b607bf666758dbf3556cab9cff7c9810787b196c28f631314a8b87629634b6', '[\"*\"]', '2025-11-25 18:47:51', NULL, '2025-11-25 18:47:08', '2025-11-25 18:47:51'),
(90, 'App\\Models\\User', 4, 'token', '02c609a911d45eff3b4d28c84d66258ae19338e297aa66d6b4abac323fbc47f0', '[\"*\"]', '2025-11-25 18:55:31', NULL, '2025-11-25 18:55:14', '2025-11-25 18:55:31'),
(91, 'App\\Models\\User', 6, 'token', 'ab763abb64d6ea20e20c34c8dc0428910bdde90d650856b8869974ea6a341bde', '[\"*\"]', '2025-11-25 19:09:36', NULL, '2025-11-25 19:09:17', '2025-11-25 19:09:36'),
(92, 'App\\Models\\User', 6, 'token', '7e4273d0b5120cd4298c58336920a74acdf182214ac52db2f6f86dc6a0581d69', '[\"*\"]', NULL, NULL, '2025-11-25 19:13:38', '2025-11-25 19:13:38'),
(93, 'App\\Models\\User', 10, 'token', '66f93e8fa3d59f3c9dcb98249747b22280a27cb50790c6ee363b1c390d01a6f3', '[\"*\"]', '2025-11-25 20:31:08', NULL, '2025-11-25 19:14:18', '2025-11-25 20:31:08'),
(94, 'App\\Models\\User', 4, 'token', '8e3033c3c565329c683d1cca866596a9e7a384ac46a30dec521dea8ee1f9b374', '[\"*\"]', '2025-11-25 20:33:19', NULL, '2025-11-25 20:32:48', '2025-11-25 20:33:19'),
(95, 'App\\Models\\User', 6, 'token', 'ff1193c6372dd446907b298ba84c2174a44760d088bc4817d65c5e783941908b', '[\"*\"]', '2025-11-25 20:34:52', NULL, '2025-11-25 20:34:07', '2025-11-25 20:34:52'),
(96, 'App\\Models\\User', 5, 'token', 'c43ff59b04d0369119fc4ac2cafbbe8e90ae3752199a14d433b419047b3ab0b3', '[\"*\"]', '2025-11-25 20:53:38', NULL, '2025-11-25 20:35:25', '2025-11-25 20:53:38'),
(97, 'App\\Models\\User', 10, 'token', '754040e11a20c40d39366bf902cd120a977433e9c1cfe89aa0ff42483d9bd819', '[\"*\"]', '2025-11-25 20:55:09', NULL, '2025-11-25 20:54:19', '2025-11-25 20:55:09'),
(98, 'App\\Models\\User', 4, 'token', '5cca15eb7c473a667bd05c2ef358d05a5848f797ad87f9fdd243d5077bb67199', '[\"*\"]', '2025-11-25 20:56:13', NULL, '2025-11-25 20:55:42', '2025-11-25 20:56:13'),
(99, 'App\\Models\\User', 6, 'token', '80910e43751b75dd9a3275a9f032015acbd347b1d527ec82d7b45459bee27e0b', '[\"*\"]', '2025-11-25 20:57:11', NULL, '2025-11-25 20:56:42', '2025-11-25 20:57:11'),
(100, 'App\\Models\\User', 5, 'token', 'fc9ce85f23b0b73979a1bcec8b5fc861cac427cdd9c62fa694044a00d3086c47', '[\"*\"]', '2025-11-25 20:58:29', NULL, '2025-11-25 20:57:40', '2025-11-25 20:58:29'),
(101, 'App\\Models\\User', 10, 'token', '682e4179b21048511024181778441d745eff99014f19bae132db2d7f728a4081', '[\"*\"]', '2025-11-25 20:59:24', NULL, '2025-11-25 20:58:50', '2025-11-25 20:59:24'),
(102, 'App\\Models\\User', 4, 'token', 'd71aa19e73729616b5de9792ec6887f6642afe499a01836b51df2e2091b31ece', '[\"*\"]', '2025-11-25 21:00:14', NULL, '2025-11-25 21:00:05', '2025-11-25 21:00:14'),
(103, 'App\\Models\\User', 6, 'token', '5f5f410e6af0871576f9d2996ed0cbc6bf1af31f981e7d6336361391057a7433', '[\"*\"]', '2025-11-25 21:01:13', NULL, '2025-11-25 21:00:45', '2025-11-25 21:01:13'),
(104, 'App\\Models\\User', 5, 'token', 'ff59d88a8d5fe213dbd139dad674bd0d324ef98986c9bc2b5c6a499948e54071', '[\"*\"]', '2025-11-25 21:02:23', NULL, '2025-11-25 21:01:54', '2025-11-25 21:02:23'),
(105, 'App\\Models\\User', 10, 'token', 'e286cba93f97bb6b982923f99318a63cbe26448c0c4ea2e14547018dece4a41d', '[\"*\"]', '2025-11-25 21:04:54', NULL, '2025-11-25 21:03:17', '2025-11-25 21:04:54'),
(106, 'App\\Models\\User', 4, 'token', '8a9408f5bc1d20f97eaeae304fc94e058b79f4fd8e4eeda4572c37772b5dd4bb', '[\"*\"]', '2025-11-25 21:05:34', NULL, '2025-11-25 21:05:20', '2025-11-25 21:05:34'),
(107, 'App\\Models\\User', 5, 'token', 'f37c5427f117a9434e8b5175be23c618d4810b6742480d52adf12c47c6e9491a', '[\"*\"]', '2025-11-25 21:25:38', NULL, '2025-11-25 21:05:59', '2025-11-25 21:25:38'),
(108, 'App\\Models\\User', 10, 'token', '03e40711012bbd5c7a3c1ad8823b8116b739b752f756da4dca3293de6247988d', '[\"*\"]', '2025-11-25 21:27:15', NULL, '2025-11-25 21:26:12', '2025-11-25 21:27:15'),
(109, 'App\\Models\\User', 4, 'token', 'd0378125be4abddfad7c78e2850529c8952b9a0239b74393be5ea33a74f1abe5', '[\"*\"]', '2025-11-25 21:27:45', NULL, '2025-11-25 21:27:32', '2025-11-25 21:27:45'),
(110, 'App\\Models\\User', 6, 'token', '6109af096b0724950102881b7fb51f73052f371efa3c0382e7e5dbcee7d0cec6', '[\"*\"]', '2025-11-25 21:35:20', NULL, '2025-11-25 21:28:17', '2025-11-25 21:35:20'),
(111, 'App\\Models\\User', 5, 'token', '65d304214024f88e5aed66af30ff6bd32130ab4a19d1b95b060120a9d038faf9', '[\"*\"]', '2025-11-25 21:37:14', NULL, '2025-11-25 21:35:52', '2025-11-25 21:37:14'),
(112, 'App\\Models\\User', 10, 'token', 'eec64b0284c122d3ccd2c92981998ad449121574d8b3a8509ecb70c4545dc9cb', '[\"*\"]', '2025-11-25 21:39:38', NULL, '2025-11-25 21:37:40', '2025-11-25 21:39:38'),
(113, 'App\\Models\\User', 5, 'token', 'f26dd2531afcdfac5dbdba670dd7f4beca1162b8e4f08d1c989a3e673ec7e35b', '[\"*\"]', '2025-11-25 21:42:20', NULL, '2025-11-25 21:40:03', '2025-11-25 21:42:20'),
(114, 'App\\Models\\User', 4, 'token', '067ba9239c78bbc766c597cb495d09977dcef74cff77edda12cd120982d3d84e', '[\"*\"]', '2025-11-25 21:43:07', NULL, '2025-11-25 21:42:56', '2025-11-25 21:43:07'),
(115, 'App\\Models\\User', 6, 'token', '258035139f0e585326a7622ada8395ba9a01ef702907f7ae060484461c2a6fb8', '[\"*\"]', '2025-11-25 21:59:08', NULL, '2025-11-25 21:43:37', '2025-11-25 21:59:08'),
(116, 'App\\Models\\User', 10, 'token', '771d44009c17060f951566674540e5e06d6ec3d9599124147c4fcc48461ce8c0', '[\"*\"]', '2025-11-25 22:17:44', NULL, '2025-11-25 22:16:18', '2025-11-25 22:17:44'),
(117, 'App\\Models\\User', 5, 'token', '30d03b7a9cd111d3191bc4338ed3f5e52aa352cd03389ff877465d8eb646931f', '[\"*\"]', '2025-11-25 22:36:10', NULL, '2025-11-25 22:18:16', '2025-11-25 22:36:10'),
(118, 'App\\Models\\User', 10, 'token', '2cbec2e0cbd017567fb3e36dadc4183444dadf4d1dd00ae9f5120c3f6bd6cdc7', '[\"*\"]', NULL, NULL, '2025-11-25 22:37:14', '2025-11-25 22:37:14'),
(119, 'App\\Models\\User', 5, 'token', 'a62e52f0057eb1588213c679f8ecf63f1c430157a48ed1e79265272568008434', '[\"*\"]', '2025-11-26 00:23:35', NULL, '2025-11-26 00:01:28', '2025-11-26 00:23:35'),
(120, 'App\\Models\\User', 5, 'token', 'b43d8d4b4319fba12c0ea82b9f9b22ee8b0f21ae30850f05a42dc349d31eb80a', '[\"*\"]', '2025-11-26 01:06:08', NULL, '2025-11-26 00:56:50', '2025-11-26 01:06:08'),
(121, 'App\\Models\\User', 6, 'token', '78a80565c0e41acce26f984e52bf1501a548dd6dc1a24557c6ed08bbed148923', '[\"*\"]', '2025-11-26 01:08:22', NULL, '2025-11-26 01:07:30', '2025-11-26 01:08:22'),
(122, 'App\\Models\\User', 4, 'token', '09a4bb8d6d6add0c21bc014061cd690be707fffd5fe4b38fde6c3d4f7879d3a2', '[\"*\"]', '2025-11-26 01:12:18', NULL, '2025-11-26 01:11:31', '2025-11-26 01:12:18'),
(123, 'App\\Models\\User', 3, 'token', '59cc41de73733e91cd7ea7a81d862bcd39cb511163a17f8f586339a4d20db061', '[\"*\"]', '2025-11-26 01:14:03', NULL, '2025-11-26 01:12:51', '2025-11-26 01:14:03'),
(124, 'App\\Models\\User', 6, 'token', '1278e464f79491a870850e7bc36ded7bf7f102a20cc4b1313645ab9f6877ec30', '[\"*\"]', '2025-11-26 01:15:32', NULL, '2025-11-26 01:15:12', '2025-11-26 01:15:32'),
(125, 'App\\Models\\User', 4, 'token', '5cabcd660843c1d1352667bb4472667eae549fc8ea71bd071f82e900da09734c', '[\"*\"]', '2025-11-26 01:16:33', NULL, '2025-11-26 01:16:11', '2025-11-26 01:16:33'),
(126, 'App\\Models\\User', 3, 'token', '2f4249ab418d6e9b6b3be99b276a9a3196f042e3764a89c18c174efd13f95ef6', '[\"*\"]', '2025-11-26 01:26:12', NULL, '2025-11-26 01:17:36', '2025-11-26 01:26:12'),
(127, 'App\\Models\\User', 5, 'token', '6f2df488a99524c21d850e0398faddd920e97eaed3f9b4e4a8a4c15bec22beab', '[\"*\"]', '2025-11-26 01:28:20', NULL, '2025-11-26 01:27:15', '2025-11-26 01:28:20'),
(128, 'App\\Models\\User', 4, 'token', '009e424e8cf249d21180558e3e4a76c7256ff06ee3d8de2d86b659d59b6138b6', '[\"*\"]', '2025-11-26 01:30:00', NULL, '2025-11-26 01:29:11', '2025-11-26 01:30:00'),
(129, 'App\\Models\\User', 6, 'token', 'ce18085ca696baf188ad1a91224d96bdfc44985e588b6319e258812e1e10b7f1', '[\"*\"]', '2025-11-26 01:43:59', NULL, '2025-11-26 01:43:39', '2025-11-26 01:43:59'),
(130, 'App\\Models\\User', 4, 'token', 'a5ac2a4af452b261e98ffc5589bc99d1d07281192ccdd0026e11af851064f498', '[\"*\"]', '2025-11-26 01:44:38', NULL, '2025-11-26 01:44:26', '2025-11-26 01:44:38'),
(131, 'App\\Models\\User', 5, 'token', '20ac09cd61c9175e13e9820fc2db78c232604792eb03c0795b2c48a84d2c1c3a', '[\"*\"]', '2025-11-26 01:46:13', NULL, '2025-11-26 01:45:07', '2025-11-26 01:46:13'),
(132, 'App\\Models\\User', 3, 'token', '48479f43505a366db76c4473cef5803484b20ab0595108177467b8cbec6c8720', '[\"*\"]', '2025-11-26 01:47:06', NULL, '2025-11-26 01:47:01', '2025-11-26 01:47:06'),
(133, 'App\\Models\\User', 6, 'token', '090c3ba945e437b347ba61d7ac828bac12da21d22d6f570e248ee72f038aee57', '[\"*\"]', '2025-11-26 01:57:51', NULL, '2025-11-26 01:57:25', '2025-11-26 01:57:51'),
(134, 'App\\Models\\User', 4, 'token', 'b180fb95239486a639c3c00b85affcd7e1e0c9f67e2ee2a39b9833b41432d6df', '[\"*\"]', '2025-11-26 01:58:52', NULL, '2025-11-26 01:58:34', '2025-11-26 01:58:52'),
(135, 'App\\Models\\User', 5, 'token', 'c7170c05b0e4ccf6d5c0b245cbbfe45361b27e20750bf598100d9e7a82cf8fa7', '[\"*\"]', '2025-11-26 02:34:09', NULL, '2025-11-26 01:59:30', '2025-11-26 02:34:09'),
(136, 'App\\Models\\User', 5, 'token', 'f7449549c452d5d4c3767692f06eaae8fcbb985011d1d5ed271a4e444b1ac5f8', '[\"*\"]', '2025-12-01 06:22:37', NULL, '2025-12-01 06:20:22', '2025-12-01 06:22:37'),
(137, 'App\\Models\\User', 5, 'token', '165012fb64fe84d83739bf63a60163a295964acdb8e494d156f45183edf3879e', '[\"*\"]', '2025-12-01 06:34:55', NULL, '2025-12-01 06:30:20', '2025-12-01 06:34:55'),
(138, 'App\\Models\\User', 5, 'token', '97983cc89517f6546c0793761d40cfdf6d75c88e2cbad59275a015ff41651f7b', '[\"*\"]', '2025-12-01 06:42:01', NULL, '2025-12-01 06:41:53', '2025-12-01 06:42:01'),
(139, 'App\\Models\\User', 5, 'token', '9e077bf5c82fd38e250c7eb4bcd8f353894ba76be721bd671d201b8743ce1a3b', '[\"*\"]', '2025-12-01 07:07:00', NULL, '2025-12-01 06:46:49', '2025-12-01 07:07:00'),
(140, 'App\\Models\\User', 5, 'token', 'ee0993eab93503a84a98a3cbf52e393ebf73dfa7e6818f3fb9134060a522bdb8', '[\"*\"]', '2025-12-01 07:17:08', NULL, '2025-12-01 07:10:59', '2025-12-01 07:17:08'),
(141, 'App\\Models\\User', 5, 'token', '782fba56db4af60204f92f2753dc8f351a38fcc5790bcd2e9fe0848b79fc2b1f', '[\"*\"]', '2025-12-01 07:21:57', NULL, '2025-12-01 07:21:50', '2025-12-01 07:21:57'),
(142, 'App\\Models\\User', 5, 'token', '5f9ceac27956387519f482a61f3c93e91e045029bae141a2c776fd22da1c746d', '[\"*\"]', '2025-12-01 07:29:25', NULL, '2025-12-01 07:29:17', '2025-12-01 07:29:25'),
(143, 'App\\Models\\User', 5, 'token', 'e4f359e58ae71c3abebe90368801264e96522d0063d67d1f95ba3da1d028e25b', '[\"*\"]', '2025-12-01 08:12:57', NULL, '2025-12-01 07:43:35', '2025-12-01 08:12:57'),
(144, 'App\\Models\\User', 5, 'token', 'a9a84c5db994a85c8785839c4646a1e4f83021f80d17fd73e443bd637a809e67', '[\"*\"]', '2025-12-01 08:47:35', NULL, '2025-12-01 08:47:11', '2025-12-01 08:47:35'),
(145, 'App\\Models\\User', 5, 'token', '8161564576300a218650553ba7c5d6eae05d88b3e10e5d7a36d1111f33118737', '[\"*\"]', '2025-12-01 08:51:31', NULL, '2025-12-01 08:51:16', '2025-12-01 08:51:31'),
(146, 'App\\Models\\User', 5, 'token', 'c07a5ca12cbdb8f3c90de7234db40bf5962f0564a8a38f162ef37854b523f8dc', '[\"*\"]', '2025-12-01 09:34:54', NULL, '2025-12-01 09:31:51', '2025-12-01 09:34:54'),
(147, 'App\\Models\\User', 5, 'token', 'bfc118e1f9825633e337a57572a9a2b4f9bdbde6b7af95cb0bc19fe468ee5e61', '[\"*\"]', '2025-12-01 10:12:30', NULL, '2025-12-01 09:39:05', '2025-12-01 10:12:30'),
(148, 'App\\Models\\User', 5, 'token', '1062b1c5bf041e39c56bb7ae6be36dbcd69b0d6c35e8f77f3a0adc2480b67611', '[\"*\"]', '2025-12-01 17:25:06', NULL, '2025-12-01 17:24:17', '2025-12-01 17:25:06'),
(149, 'App\\Models\\User', 5, 'token', 'b1eb1a4ebc296c4b01d18d3124936fccd4cabd0dc19f95a53114494b9fcc08ed', '[\"*\"]', '2025-12-01 17:33:59', NULL, '2025-12-01 17:30:51', '2025-12-01 17:33:59'),
(150, 'App\\Models\\User', 5, 'token', '88326c2e20bb3baa490a2283ef518c4f3170ac904a331ba4c88593f598b5745f', '[\"*\"]', '2025-12-01 17:40:19', NULL, '2025-12-01 17:38:51', '2025-12-01 17:40:19'),
(151, 'App\\Models\\User', 5, 'token', 'addfaf5d5bf04944e5f54a10597656d8e4be8e5e7b1c5457698f729c37947c5a', '[\"*\"]', '2025-12-01 18:06:05', NULL, '2025-12-01 18:02:06', '2025-12-01 18:06:05'),
(152, 'App\\Models\\User', 5, 'token', '818c1ca50897967139f5e692e0a2962b35d2b54593a639acea8547a692e219ca', '[\"*\"]', '2025-12-01 18:29:42', NULL, '2025-12-01 18:17:18', '2025-12-01 18:29:42'),
(153, 'App\\Models\\User', 5, 'token', 'e1a71132b5bd4da24778853fa0a7397a2e7a149904bce046a375b6dff5fedbae', '[\"*\"]', '2025-12-01 19:30:27', NULL, '2025-12-01 18:44:42', '2025-12-01 19:30:27'),
(154, 'App\\Models\\User', 5, 'token', '7bd0a6965a23b1e36e075c51b6fcfed274e191967c7d424377b4114823d7e24d', '[\"*\"]', '2025-12-01 19:49:24', NULL, '2025-12-01 19:39:52', '2025-12-01 19:49:24'),
(155, 'App\\Models\\User', 5, 'token', 'dda741f903c112f34282d504761b77a9a09e021e50bad58bab823fe115488491', '[\"*\"]', '2025-12-01 21:08:24', NULL, '2025-12-01 21:02:37', '2025-12-01 21:08:24'),
(156, 'App\\Models\\User', 5, 'token', '08795b7d7e0730652cb5ed30be956025d65a0da28dd577b75ae2042598b39f60', '[\"*\"]', '2025-12-01 22:11:05', NULL, '2025-12-01 21:18:08', '2025-12-01 22:11:05'),
(157, 'App\\Models\\User', 5, 'token', '5b8c891ef10b76597cab1649110c267617f4488a6e38a09779e98d056bfb724c', '[\"*\"]', '2025-12-01 22:23:08', NULL, '2025-12-01 22:19:06', '2025-12-01 22:23:08'),
(158, 'App\\Models\\User', 3, 'token', 'c1e6dce044cb7fb715a84e73a610a2414ca52dbbfc7de6a0f8e1b5ecfd0d045c', '[\"*\"]', '2025-12-01 22:28:15', NULL, '2025-12-01 22:25:10', '2025-12-01 22:28:15'),
(159, 'App\\Models\\User', 4, 'token', 'ae10cf0802e40d3bf7b0fb1e465fc5d742f5e4a024d272c690c71c5a105b640f', '[\"*\"]', '2025-12-01 22:30:29', NULL, '2025-12-01 22:29:05', '2025-12-01 22:30:29'),
(160, 'App\\Models\\User', 6, 'token', '8481e104906ad76a0f2c3704358157318391e78cc6dc7a33cd9ebdde5816b311', '[\"*\"]', '2025-12-01 22:31:42', NULL, '2025-12-01 22:31:03', '2025-12-01 22:31:42'),
(161, 'App\\Models\\User', 5, 'token', '577ac1c7716d60f3b647cdcf79ab054e9a15a9517b59bee9158a136a9c0e4fbc', '[\"*\"]', '2025-12-01 22:38:39', NULL, '2025-12-01 22:34:32', '2025-12-01 22:38:39'),
(162, 'App\\Models\\User', 3, 'token', 'e327376bdd1f9a04758df386957cc62f27a75c9c34701e6bcfbe338896869a8b', '[\"*\"]', '2025-12-01 22:47:17', NULL, '2025-12-01 22:40:36', '2025-12-01 22:47:17'),
(163, 'App\\Models\\User', 3, 'token', '035fa7016e2b14cf20c70b688b60d6b7fe7766e9b7b4c4620268dfebe2b281ac', '[\"*\"]', '2025-12-02 06:04:44', NULL, '2025-12-02 05:58:00', '2025-12-02 06:04:44'),
(164, 'App\\Models\\User', 3, 'token', '7f11a119710497264036c2d2462855421db99284b4b6378e0bf6f32be36657b5', '[\"*\"]', '2025-12-02 06:13:01', NULL, '2025-12-02 06:08:29', '2025-12-02 06:13:01'),
(165, 'App\\Models\\User', 4, 'token', 'af04ea34ab67b08c00423f8267f8969ff0d351ed0aa83fbff1ce84a33846ef13', '[\"*\"]', '2025-12-02 06:33:33', NULL, '2025-12-02 06:25:53', '2025-12-02 06:33:33'),
(166, 'App\\Models\\User', 3, 'token', '686c7e9713466f203745da21f64fb7a5eb1a1f7a2433bc93a113a401021e67ae', '[\"*\"]', '2025-12-02 06:36:39', NULL, '2025-12-02 06:36:32', '2025-12-02 06:36:39'),
(167, 'App\\Models\\User', 4, 'token', 'f29f9827d79d515c9f949ef742a91056cf0bc132dd2071da980495c1681ba6c8', '[\"*\"]', '2025-12-02 06:37:22', NULL, '2025-12-02 06:37:14', '2025-12-02 06:37:22'),
(168, 'App\\Models\\User', 6, 'token', '21f6faccada50193544ad1794cddfa7c672ba6abeb373c29fc7cbf5e2c461fbe', '[\"*\"]', '2025-12-02 07:01:59', NULL, '2025-12-02 06:51:10', '2025-12-02 07:01:59'),
(169, 'App\\Models\\User', 5, 'token', 'a83d74b56a5acc20c13dff615a1e43165a0a2ca3f215e46f926649a70a94711b', '[\"*\"]', '2025-12-02 07:18:15', NULL, '2025-12-02 07:17:34', '2025-12-02 07:18:15'),
(170, 'App\\Models\\User', 5, 'token', '080314306f824415cb7e659f59794553510865b6674b543355678a44f5bf8cad', '[\"*\"]', '2025-12-02 07:33:51', NULL, '2025-12-02 07:32:39', '2025-12-02 07:33:51'),
(171, 'App\\Models\\User', 5, 'token', '9e517b6daa220f9142221741072c2f5d80f437dcc2245329cd46eec1a0c66bca', '[\"*\"]', '2025-12-02 07:41:39', NULL, '2025-12-02 07:41:08', '2025-12-02 07:41:39'),
(172, 'App\\Models\\User', 5, 'token', 'a0618c27f3b9208d83e97523b296f665e5baa7a8b1dc10587a594773a705f75f', '[\"*\"]', '2025-12-03 01:09:59', NULL, '2025-12-03 00:48:06', '2025-12-03 01:09:59'),
(173, 'App\\Models\\User', 5, 'token', '9affd827a80a5378905247a9cbedfff6f09a6399968e2493e7bf8042d75402f1', '[\"*\"]', '2025-12-03 01:24:31', NULL, '2025-12-03 01:13:06', '2025-12-03 01:24:31'),
(174, 'App\\Models\\User', 3, 'token', '10b97e2469cc1b96d5defa0e87ef4ec9ce64838245c576d17c65e3bbfe0b22dc', '[\"*\"]', '2025-12-03 01:31:18', NULL, '2025-12-03 01:25:03', '2025-12-03 01:31:18'),
(175, 'App\\Models\\User', 5, 'token', 'd0faf130a0f0ee32c8b4596952749a0ecd9277b524f9a713d643282ba7511e3a', '[\"*\"]', '2025-12-03 01:34:13', NULL, '2025-12-03 01:31:39', '2025-12-03 01:34:13'),
(176, 'App\\Models\\User', 3, 'token', '105ab3e08b83de10d06192005a83177f29accb0ae8c5d3048bd3f215b911f5fa', '[\"*\"]', '2025-12-03 01:35:57', NULL, '2025-12-03 01:34:47', '2025-12-03 01:35:57'),
(177, 'App\\Models\\User', 5, 'token', 'dbcc1d8025e923047038e600503eb20e9915401d1e8c668e3a75ade7ce6a128f', '[\"*\"]', '2025-12-03 01:38:45', NULL, '2025-12-03 01:36:26', '2025-12-03 01:38:45'),
(178, 'App\\Models\\User', 6, 'token', 'cd2b739ff182a5916e19d56a463822f1dba8ea0a7c11d1862dd541260d0ff8fb', '[\"*\"]', '2025-12-03 01:46:11', NULL, '2025-12-03 01:39:14', '2025-12-03 01:46:11'),
(179, 'App\\Models\\User', 5, 'token', 'e65a8947d2ec3cc11c5d16a027d545ef255c32d894cea58dee84fedd1f033278', '[\"*\"]', '2025-12-03 02:09:06', NULL, '2025-12-03 01:53:10', '2025-12-03 02:09:06'),
(180, 'App\\Models\\User', 5, 'token', '13b7c9292b7635c4685fabee5f0c8ae467720afbde6636aaf1c9a69610eb547e', '[\"*\"]', '2025-12-03 02:18:31', NULL, '2025-12-03 02:16:58', '2025-12-03 02:18:31'),
(181, 'App\\Models\\User', 5, 'token', '38c07aa6deaab1013afd8b4f2408843e96d2c64bf9dcac20b16b42a3c01d3f62', '[\"*\"]', '2025-12-03 02:24:32', NULL, '2025-12-03 02:23:09', '2025-12-03 02:24:32'),
(182, 'App\\Models\\User', 3, 'token', 'c739a5056275e973b28462ad8262dc6013212252fdcbfc03940cb3f735686ff5', '[\"*\"]', '2025-12-03 02:29:13', NULL, '2025-12-03 02:25:34', '2025-12-03 02:29:13'),
(183, 'App\\Models\\User', 5, 'token', '72818cbbbb89dc38ab2c7cab74edb4735cfceffb0b174d77a4fed81bb4063b3e', '[\"*\"]', '2025-12-03 18:08:14', NULL, '2025-12-03 18:07:53', '2025-12-03 18:08:14'),
(184, 'App\\Models\\User', 5, 'token', '70ddf9fd6f2db4b229f6b219defef809012d1f8e267639def97a97a15aec4160', '[\"*\"]', '2025-12-03 19:29:19', NULL, '2025-12-03 19:29:07', '2025-12-03 19:29:19'),
(185, 'App\\Models\\User', 5, 'token', 'eca8398c2d0a27232866ddccb554f1d8c617f785b08efa09c7a62827533fa71f', '[\"*\"]', '2025-12-03 19:47:24', NULL, '2025-12-03 19:46:56', '2025-12-03 19:47:24'),
(186, 'App\\Models\\User', 5, 'token', '8b689d30ff3c7d60b78b35aab5cb709932f2679be7c528f1a01b562133ff6cee', '[\"*\"]', '2025-12-03 20:08:15', NULL, '2025-12-03 20:07:06', '2025-12-03 20:08:15'),
(187, 'App\\Models\\User', 5, 'token', 'f79aec6ac58ae6c4aab030a90544268a48c52673f9578ab586b32998c6689371', '[\"*\"]', '2025-12-03 20:16:30', NULL, '2025-12-03 20:14:34', '2025-12-03 20:16:30'),
(188, 'App\\Models\\User', 5, 'token', '0620c8f66b62afa186c96cbd2118e79aab37fe16bfa66044942b64e4851b88d0', '[\"*\"]', '2025-12-03 20:41:45', NULL, '2025-12-03 20:34:45', '2025-12-03 20:41:45'),
(189, 'App\\Models\\User', 6, 'token', '98d3845f7ed224b32d63544eda5760e8632e217259967867db73efb5010f87fc', '[\"*\"]', '2025-12-03 20:43:35', NULL, '2025-12-03 20:42:27', '2025-12-03 20:43:35'),
(190, 'App\\Models\\User', 5, 'token', '97038e708a0fd0be2531a9a4c7c63cc9b2d1cd94201bb87b599675381de1c912', '[\"*\"]', '2025-12-03 20:46:24', NULL, '2025-12-03 20:43:53', '2025-12-03 20:46:24'),
(191, 'App\\Models\\User', 6, 'token', '1a794302d57ea7bb2ce888589a9000fbf0779db0a2d9f42af13232c1fef2152a', '[\"*\"]', '2025-12-03 21:01:26', NULL, '2025-12-03 20:47:02', '2025-12-03 21:01:26'),
(192, 'App\\Models\\User', 6, 'token', '175a3bf82a4884c18eeba0cf8b496168c55272b17e705bed96fd3f178a5afe22', '[\"*\"]', '2025-12-03 21:24:00', NULL, '2025-12-03 21:04:07', '2025-12-03 21:24:00'),
(193, 'App\\Models\\User', 6, 'token', 'bf73ca24cba9a363602f310b52a175174290129bc1bf628f34f31f66d6e20c29', '[\"*\"]', '2025-12-03 23:23:24', NULL, '2025-12-03 21:42:04', '2025-12-03 23:23:24'),
(194, 'App\\Models\\User', 6, 'token', 'd310cd3b48caaf82dec7afa9c6d0fc8826ef10b67f983ed3ca9339e8fcff1a1e', '[\"*\"]', '2025-12-03 23:29:27', NULL, '2025-12-03 23:26:01', '2025-12-03 23:29:27'),
(195, 'App\\Models\\User', 6, 'token', '4413c1aadc6a086d3b18c18a522053edc11fc6e2b442240c9881f3131650f770', '[\"*\"]', '2025-12-04 00:01:15', NULL, '2025-12-03 23:37:45', '2025-12-04 00:01:15'),
(196, 'App\\Models\\User', 6, 'token', '2d37c9ee04d3f8c4232d6b42543ed44e3aee10f6d5b2d863c6f10021966168d0', '[\"*\"]', '2025-12-04 00:09:21', NULL, '2025-12-04 00:03:54', '2025-12-04 00:09:21'),
(197, 'App\\Models\\User', 6, 'token', 'e1246f60a3a23f07671d4d20d1f6bb3cd20c225d10139433fa3cbaa8465e3fb0', '[\"*\"]', '2025-12-04 00:25:07', NULL, '2025-12-04 00:18:43', '2025-12-04 00:25:07'),
(198, 'App\\Models\\User', 6, 'token', '749b890f786e9e21af8ba189a071e7475dbb5e86be850bd27c0542786be17bb8', '[\"*\"]', '2025-12-04 00:34:09', NULL, '2025-12-04 00:28:00', '2025-12-04 00:34:09'),
(199, 'App\\Models\\User', 6, 'token', 'af0f1fb2a8442340be5c280c479eb4cdb8583cbfe3aca6947f38bbee15cf0365', '[\"*\"]', '2025-12-04 00:46:52', NULL, '2025-12-04 00:36:20', '2025-12-04 00:46:52'),
(200, 'App\\Models\\User', 6, 'token', '0ebec91ba6ed55ee23b114ea9240dca44d4784ff4eefee7cd712a52f533f246a', '[\"*\"]', '2025-12-04 00:50:38', NULL, '2025-12-04 00:49:28', '2025-12-04 00:50:38');

-- --------------------------------------------------------

--
-- Table structure for table `request_barang`
--

CREATE TABLE `request_barang` (
  `id` bigint UNSIGNED NOT NULL,
  `id_user` bigint UNSIGNED NOT NULL,
  `id_barang` bigint UNSIGNED NOT NULL,
  `qty` int NOT NULL,
  `tanggal_request` date NOT NULL,
  `status` enum('pending','approved','rejected','done') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `alasan_penolakan` text COLLATE utf8mb4_unicode_ci,
  `approved_by` bigint UNSIGNED DEFAULT NULL,
  `tanggal_approve` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `request_barang`
--

INSERT INTO `request_barang` (`id`, `id_user`, `id_barang`, `qty`, `tanggal_request`, `status`, `alasan_penolakan`, `approved_by`, `tanggal_approve`, `created_at`, `updated_at`) VALUES
(4, 6, 6, 100, '2025-11-26', 'done', NULL, 5, '2025-11-26', '2025-11-25 17:54:00', '2025-11-25 19:17:30'),
(5, 6, 6, 17, '2025-11-26', 'done', NULL, 4, '2025-11-26', '2025-11-25 18:07:35', '2025-11-25 19:15:11'),
(6, 6, 8, 10, '2025-11-26', 'done', NULL, 5, '2025-11-26', '2025-11-25 20:57:02', '2025-11-25 20:59:11'),
(7, 6, 4, 5, '2025-11-26', 'done', NULL, 5, '2025-11-26', '2025-11-25 21:29:24', '2025-11-25 21:38:12'),
(8, 6, 7, 2, '2025-11-26', 'done', NULL, 4, '2025-11-26', '2025-11-25 21:43:59', '2025-11-26 01:13:28'),
(9, 6, 3, 1, '2025-11-26', 'approved', NULL, 4, '2025-11-26', '2025-11-26 01:08:12', '2025-11-26 01:12:04'),
(10, 6, 8, 4, '2025-11-26', 'approved', NULL, 4, '2025-11-26', '2025-11-26 01:15:30', '2025-11-26 01:16:28'),
(11, 6, 8, 7, '2025-11-26', 'approved', NULL, 4, '2025-11-26', '2025-11-26 01:43:58', '2025-11-26 01:44:33'),
(12, 6, 4, 8, '2025-11-26', 'approved', NULL, 4, '2025-11-26', '2025-11-26 01:57:49', '2025-11-26 01:58:44');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('2okt1IG1gcMjGd5XbmLF4N43lETs5AE2hN8JvqeO', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWlB4U1lvdGx2MndCUWFFcThzMFdiaXBqMmJKalc4d3pwSGxkbHVBYyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1763963515),
('IZI8zPEtaqqb8IZ9B3lVSgzADBnQBzIiNX8HzUUH', NULL, '127.0.0.1', 'PostmanRuntime/7.49.1', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNkxGdENxUzJJR1poU05DQTUwUzF4czNoSE5XWUFZUjJkbVRXOGR5WSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1763953276);

-- --------------------------------------------------------

--
-- Table structure for table `supplier`
--

CREATE TABLE `supplier` (
  `id` bigint UNSIGNED NOT NULL,
  `nama_supplier` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `kontak` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `alamat` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `supplier`
--

INSERT INTO `supplier` (`id`, `nama_supplier`, `kontak`, `alamat`, `created_at`, `updated_at`) VALUES
(2, 'Toko Maduraaa', '083824757542', 'Tangerang', '2025-11-24 07:04:22', '2025-11-26 00:58:40'),
(3, 'Toko Betawi', '088789889898928', 'Majaengka', '2025-11-25 03:27:19', '2025-11-25 20:48:09'),
(4, 'Toko Jawa', '08900989228731', 'Jakarta', '2025-11-25 03:27:19', '2025-11-25 20:48:29');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `nama` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('admin','operator','manager','karyawan') COLLATE utf8mb4_unicode_ci NOT NULL,
  `foto` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `nama`, `email`, `password`, `role`, `foto`, `created_at`, `updated_at`) VALUES
(3, 'Operator Satuu', 'operator1@example.test', '$2y$12$86u9CuGlzMmGn8S.lXhaVuHBuY8zWGSgEpE30ozD0GaiZDj85sBOG', 'operator', NULL, '2025-11-23 20:58:35', '2025-11-24 01:05:55'),
(4, 'Manager Satu', 'manager1@example.test', '$2y$12$zn9NdOAhZId2WcSbRJYCGug6193KwMG0pz4ZdazSz1hyklUfculqm', 'manager', NULL, '2025-11-23 21:00:53', '2025-11-23 21:00:53'),
(5, 'Admin Satu', 'admin1@example.test', '$2y$12$NsK4lfOFojlnzMycRm83uO5P/8VUyTpGkvLS9S7TrlJGcr7K8HaR2', 'admin', NULL, '2025-11-23 21:35:44', '2025-11-23 21:35:44'),
(6, 'Karyawan Satu', 'karyawan1@example.test', '$2y$12$GEMsWGCfys56zJyMgMzYzu11tgARto8YibWKjAjNAShq1oOGzhL1S', 'karyawan', NULL, '2025-11-23 23:23:41', '2025-11-23 23:23:41'),
(8, 'Admin Test', 'admin@test.local', '$2y$12$WyfhmhhZTCPhLtS3P9I9a.QeUh9gKamlSeMPEL7V/6xQ6TpokyW3O', 'admin', NULL, '2025-11-24 07:33:47', '2025-11-24 07:33:47'),
(9, 'op', 'operator@gmail.com', '$2y$12$YCzDKJc/hs6e6ldv4vfELeLxlpq03zU2Df0YAitwzdOjx6B8DHm0q', 'operator', NULL, '2025-11-24 21:58:25', '2025-11-24 21:58:25'),
(10, 'Operator Tiga', 'operator3@example.test', '$2y$12$OZ8cq1i94d7TL6DdK9DCAOugxeegdsPWeDzSVXBvtkjZ6qoZkJrMG', 'operator', NULL, '2025-11-24 22:30:27', '2025-11-24 22:30:27'),
(11, 'Test User', 'test@example.com', '$2y$12$8t7SF0Q5txjVOMCkYxfcH.VnzOeNfg7Hw4tZ4SIkoO0ql7EndPnUi', 'admin', NULL, '2025-11-25 03:27:18', '2025-11-25 03:27:18');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `barang`
--
ALTER TABLE `barang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `barang_kode_barang_unique` (`kode_barang`),
  ADD KEY `barang_id_supplier_foreign` (`id_supplier`),
  ADD KEY `barang_id_kategori_foreign` (`id_kategori`);

--
-- Indexes for table `barang_keluar`
--
ALTER TABLE `barang_keluar`
  ADD PRIMARY KEY (`id`),
  ADD KEY `barang_keluar_id_barang_foreign` (`id_barang`),
  ADD KEY `barang_keluar_id_user_foreign` (`id_user`),
  ADD KEY `barang_keluar_id_request_foreign` (`id_request`);

--
-- Indexes for table `barang_masuk`
--
ALTER TABLE `barang_masuk`
  ADD PRIMARY KEY (`id`),
  ADD KEY `barang_masuk_id_barang_foreign` (`id_barang`),
  ADD KEY `barang_masuk_id_supplier_foreign` (`id_supplier`),
  ADD KEY `barang_masuk_id_user_foreign` (`id_user`),
  ADD KEY `barang_masuk_approved_by_foreign` (`approved_by`),
  ADD KEY `barang_masuk_rejected_by_foreign` (`rejected_by`);

--
-- Indexes for table `kategori`
--
ALTER TABLE `kategori`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `log_aktivitas`
--
ALTER TABLE `log_aktivitas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `log_aktivitas_id_user_foreign` (`id_user`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  ADD KEY `personal_access_tokens_expires_at_index` (`expires_at`);

--
-- Indexes for table `request_barang`
--
ALTER TABLE `request_barang`
  ADD PRIMARY KEY (`id`),
  ADD KEY `request_barang_id_user_foreign` (`id_user`),
  ADD KEY `request_barang_id_barang_foreign` (`id_barang`),
  ADD KEY `request_barang_approved_by_foreign` (`approved_by`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `supplier`
--
ALTER TABLE `supplier`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `barang`
--
ALTER TABLE `barang`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `barang_keluar`
--
ALTER TABLE `barang_keluar`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `barang_masuk`
--
ALTER TABLE `barang_masuk`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `kategori`
--
ALTER TABLE `kategori`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `log_aktivitas`
--
ALTER TABLE `log_aktivitas`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=201;

--
-- AUTO_INCREMENT for table `request_barang`
--
ALTER TABLE `request_barang`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `supplier`
--
ALTER TABLE `supplier`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `barang`
--
ALTER TABLE `barang`
  ADD CONSTRAINT `barang_id_kategori_foreign` FOREIGN KEY (`id_kategori`) REFERENCES `kategori` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `barang_id_supplier_foreign` FOREIGN KEY (`id_supplier`) REFERENCES `supplier` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `barang_keluar`
--
ALTER TABLE `barang_keluar`
  ADD CONSTRAINT `barang_keluar_id_barang_foreign` FOREIGN KEY (`id_barang`) REFERENCES `barang` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `barang_keluar_id_request_foreign` FOREIGN KEY (`id_request`) REFERENCES `request_barang` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `barang_keluar_id_user_foreign` FOREIGN KEY (`id_user`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `barang_masuk`
--
ALTER TABLE `barang_masuk`
  ADD CONSTRAINT `barang_masuk_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `barang_masuk_id_barang_foreign` FOREIGN KEY (`id_barang`) REFERENCES `barang` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `barang_masuk_id_supplier_foreign` FOREIGN KEY (`id_supplier`) REFERENCES `supplier` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `barang_masuk_id_user_foreign` FOREIGN KEY (`id_user`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `barang_masuk_rejected_by_foreign` FOREIGN KEY (`rejected_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `log_aktivitas`
--
ALTER TABLE `log_aktivitas`
  ADD CONSTRAINT `log_aktivitas_id_user_foreign` FOREIGN KEY (`id_user`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `request_barang`
--
ALTER TABLE `request_barang`
  ADD CONSTRAINT `request_barang_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `request_barang_id_barang_foreign` FOREIGN KEY (`id_barang`) REFERENCES `barang` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `request_barang_id_user_foreign` FOREIGN KEY (`id_user`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
