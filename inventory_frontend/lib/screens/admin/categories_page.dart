import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/role_drawer.dart';
import '../../services/auth_service.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  bool _loading = false;
  List<Map<String, dynamic>> _categories = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _searchController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    if (!mounted) return;
    setState(() => _loading = true);
    final auth = Provider.of<AuthService>(context, listen: false);
    final list = await auth.getCategories();
    if (!mounted) return;
    setState(() {
      _categories = list;
      _loading = false;
    });
  }

  Future<void> _showCategoryDialog({Map<String, dynamic>? category}) async {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController nameCtrl = TextEditingController(
      text: category?['nama_kategori'] ?? category?['name'] ?? '',
    );
    final TextEditingController descCtrl = TextEditingController(
      text: category?['deskripsi'] ?? category?['description'] ?? '',
    );

    final messenger = ScaffoldMessenger.of(context);
    final authBefore = Provider.of<AuthService>(context, listen: false);
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.85,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              category == null
                                  ? 'Tambah Kategori'
                                  : 'Edit Kategori',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.pop(context, false),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: nameCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Nama Kategori',
                                  filled: true,
                                ),
                                validator: (v) => (v == null || v.isEmpty)
                                    ? 'Nama required'
                                    : null,
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: descCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Deskripsi',
                                  filled: true,
                                ),
                                maxLines: 3,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Batal'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.save),
                              label: const Text('Simpan'),
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) return;
                                final auth = Provider.of<AuthService>(
                                  context,
                                  listen: false,
                                );
                                bool ok = false;
                                final nama = nameCtrl.text.trim();
                                final deskripsi = descCtrl.text.trim();
                                if (category == null) {
                                  ok = await auth.createCategory({
                                    'nama_kategori': nama,
                                    'deskripsi': deskripsi,
                                  });
                                } else {
                                  final id = category['id'] is int
                                      ? category['id']
                                      : int.parse(category['id'].toString());
                                  ok = await auth.updateCategory(id, {
                                    'nama_kategori': nama,
                                    'deskripsi': deskripsi,
                                  });
                                }
                                Navigator.pop(context, ok);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    nameCtrl.dispose();
    descCtrl.dispose();

    if (!mounted) return;
    if (result == true) {
      messenger.showSnackBar(const SnackBar(content: Text('Berhasil')));
      await _loadCategories();
    } else if (result == false) {
      messenger.showSnackBar(
        SnackBar(content: Text(authBefore.lastError ?? 'Gagal')),
      );
    }
  }

  Future<void> _deleteCategory(Map<String, dynamic> category) async {
    final messenger = ScaffoldMessenger.of(context);
    final auth = Provider.of<AuthService>(context, listen: false);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Hapus kategori'),
        content: Text(
          'Hapus ${category['nama_kategori'] ?? category['name'] ?? '-'} ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    final id = category['id'] is int
        ? category['id']
        : int.parse(category['id'].toString());
    final ok = await auth.deleteCategory(id);
    if (!mounted) return;
    if (ok) {
      messenger.showSnackBar(const SnackBar(content: Text('Terhapus')));
      await _loadCategories();
    } else {
      messenger.showSnackBar(
        SnackBar(content: Text(auth.lastError ?? 'Gagal menghapus')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      drawer: const RoleDrawer(),
      appBar: AppBar(
        title: const Text('Data Kategori'),
        backgroundColor: Colors.teal.shade700,
        elevation: 0,
        foregroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            tooltip: 'Menu',
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadCategories,
              color: Colors.teal.shade700,
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount:
                    _categories.where((c) {
                      final q = _searchController.text.trim().toLowerCase();
                      if (q.isEmpty) return true;
                      final name = (c['nama_kategori'] ?? c['name'] ?? '')
                          .toString()
                          .toLowerCase();
                      final desc = (c['deskripsi'] ?? c['description'] ?? '')
                          .toString()
                          .toLowerCase();
                      return name.contains(q) || desc.contains(q);
                    }).length +
                    1,
                itemBuilder: (context, index) {
                  final filtered = _categories.where((c) {
                    final q = _searchController.text.trim().toLowerCase();
                    if (q.isEmpty) return true;
                    final name = (c['nama_kategori'] ?? c['name'] ?? '')
                        .toString()
                        .toLowerCase();
                    final desc = (c['deskripsi'] ?? c['description'] ?? '')
                        .toString()
                        .toLowerCase();
                    return name.contains(q) || desc.contains(q);
                  }).toList();

                  if (index == 0) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Cari nama atau deskripsi',
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Data Kategori',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              '${filtered.length} categories',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    );
                  }

                  final c = filtered[index - 1];
                  final name = c['nama_kategori'] ?? c['name'] ?? '';
                  final desc = c['deskripsi'] ?? c['description'] ?? '';

                  String initials(String s) {
                    final parts = s.toString().split(' ');
                    if (parts.isEmpty) return '';
                    if (parts.length == 1)
                      return parts.first.substring(0, 1).toUpperCase();
                    return (parts[0][0] + parts[1][0]).toUpperCase();
                  }

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 1,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal.shade50,
                        child: Text(
                          initials(name),
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ),
                      title: Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            desc,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'ID: ${c['id'] ?? '-'}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showCategoryDialog(category: c),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteCategory(c),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCategoryDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
        tooltip: 'Tambah kategori',
      ),
    );
  }
}
