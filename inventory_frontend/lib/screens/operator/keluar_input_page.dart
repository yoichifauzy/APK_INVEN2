import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../../widgets/role_drawer.dart';

class OperatorKeluarInputPage extends StatefulWidget {
  const OperatorKeluarInputPage({Key? key}) : super(key: key);

  @override
  State<OperatorKeluarInputPage> createState() =>
      _OperatorKeluarInputPageState();
}

class _OperatorKeluarInputPageState extends State<OperatorKeluarInputPage> {
  final _formKey = GlobalKey<FormState>();
  bool _loadingItems = false;
  bool _submitting = false;
  List<Map<String, dynamic>> _items = [];
  Map<String, dynamic>? _selectedItem;
  String _qty = '1';
  String _keterangan = '';

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    setState(() => _loadingItems = true);
    final auth = Provider.of<AuthService>(context, listen: false);
    final items = await auth.getItems();
    if (!mounted) return;
    setState(() {
      _items = items;
      if (_items.isNotEmpty) {
        _selectedItem = _items.first;
      }
      _loadingItems = false;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    if (_selectedItem == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Pilih barang terlebih dahulu'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final auth = Provider.of<AuthService>(context, listen: false);
    setState(() => _submitting = true);
    final payload = {
      'id_barang': _selectedItem!['id'],
      'qty': int.tryParse(_qty) ?? 1,
      'keterangan': _keterangan,
    };
    final ok = await auth.createBarangKeluar(payload);
    if (!mounted) return;
    setState(() => _submitting = false);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Barang keluar berhasil disimpan (pending)'),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pushReplacementNamed(context, '/operator/riwayat');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.lastError ?? 'Gagal menyimpan data'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Barang Keluar'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: const RoleDrawer(),
      body: _loadingItems
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.teal.shade700),
              ),
            )
          : _items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada data barang',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tambah data barang terlebih dahulu sebelum membuat barang keluar manual.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: const Text(
                        'Gunakan form ini untuk mencatat barang keluar manual oleh operator. '
                        'Transaksi akan berstatus pending dan dapat direview oleh Admin/Manager.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Pilih Barang',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<Map<String, dynamic>>(
                      value: _selectedItem,
                      items: _items
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e['nama_barang']?.toString() ??
                                    e['nama']?.toString() ??
                                    'Barang #${e['id']}',
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _selectedItem = v),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _qty,
                      decoration: const InputDecoration(
                        labelText: 'Qty',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Qty wajib diisi' : null,
                      onSaved: (v) => _qty = v ?? '1',
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Keperluan / Keterangan',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      onSaved: (v) => _keterangan = v ?? '',
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _submitting ? null : _submit,
                        icon: _submitting
                            ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Icon(Icons.save),
                        label: Text(
                          _submitting ? 'Menyimpan...' : 'Simpan Barang Keluar',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
