import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Save bytes to a temporary file on IO platforms.
///
/// Catatan: sebelumnya file ini juga melakukan share memakai `share_plus`,
/// tapi paket tersebut sudah dihapus. Sekarang fungsi ini hanya menyimpan
/// file ke storage sementara dan mengembalikan Future selesai.
Future<void> saveFileBytes(List<int> bytes, String fileName) async {
  final dir = await getTemporaryDirectory();
  final path = '${dir.path}/$fileName';
  final file = File(path);
  await file.writeAsBytes(bytes, flush: true);
}
