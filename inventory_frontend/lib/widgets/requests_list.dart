import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../services/auth_service.dart';
import '../widgets/role_drawer.dart';

enum RequestMode { tracking, history }

class RequestsList extends StatefulWidget {
  final RequestMode mode;
  const RequestsList({Key? key, required this.mode}) : super(key: key);

  @override
  State<RequestsList> createState() => _RequestsListState();
}

class _RequestsListState extends State<RequestsList> {
  late bool _isTracking;
  String _title = '';
  Color _accentColor = Colors.teal;
  bool _loading = false;
  DateTime? _from;
  DateTime? _to;
  String _query = '';
  String _statusFilter = 'all';
  List<Map<String, dynamic>> _requests = [];
  final Map<int, bool> _actionLoading = {};
  Timer? _pollTimer;

  List<Map<String, dynamic>> get _visibleRequests {
    var list = _requests;
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      list = list.where((r) {
        return r.values.any((v) => v.toString().toLowerCase().contains(q));
      }).toList();
    }
    if (_statusFilter != 'all') {
      list = list
          .where(
            (r) =>
                (r['status'] ?? '').toString().toLowerCase() == _statusFilter,
          )
          .toList();
    }
    return list;
  }

  IconData get _emptyIcon => Icons.inbox;

  @override
  void initState() {
    super.initState();
    _isTracking = widget.mode == RequestMode.tracking;
    _title = _isTracking ? 'Tracking Requests' : 'Riwayat Permintaan';
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
    _pollTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (!mounted) return;
      if (!_loading) _load(background: true);
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _load({bool background = false}) async {
    if (!background) setState(() => _loading = true);
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      final res = await auth.getRequestBarang();
      if (res is List) {
        _requests = res
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      } else {
        _requests = [];
      }
    } catch (_) {
      _requests = [];
    }
    if (!background && mounted) setState(() => _loading = false);
    if (background && mounted) setState(() {});
  }

  Future<void> _editRequest(Map<String, dynamic> r) async {
    // Only allow edit if still pending on server side; this is a placeholder
    final rawId = r['id'];
    var idStr = rawId?.toString() ?? '';
    if (idStr.contains(':')) idStr = idStr.split(':').first;
    final id = rawId is int ? rawId : int.tryParse(idStr) ?? 0;
    if (id == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('ID request tidak valid')));
      return;
    }

    // TODO: open edit form; for now show info
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fitur edit belum diimplementasikan')),
    );
  }

  Future<void> _deleteRequest(Map<String, dynamic> r) async {
    // ensure current status still pending
    final curStatus = r['status']?.toString().toLowerCase() ?? '';
    if (curStatus != 'pending') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hanya bisa hapus jika status Pending')),
      );
      return;
    }

    // normalize id to int (handle '13:1' style values)
    final rawId = r['id'];
    var idStr = rawId?.toString() ?? '';
    if (idStr.contains(':')) idStr = idStr.split(':').first;
    final id = rawId is int ? rawId : int.tryParse(idStr) ?? 0;
    if (id == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('ID request tidak valid')));
      return;
    }

    final auth = Provider.of<AuthService>(context, listen: false);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Request'),
        content: const Text('Yakin ingin menghapus request ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    _actionLoading[id] = true;
    if (!mounted) return;
    setState(() {});
    final messenger = ScaffoldMessenger.of(context);
    final ok = await auth.deleteRequest(id);
    _actionLoading[id] = false;
    if (!mounted) return;
    setState(() {});
    if (ok) {
      messenger.showSnackBar(const SnackBar(content: Text('Request dihapus')));
      _load(background: true);
    } else {
      messenger.showSnackBar(
        SnackBar(content: Text(auth.lastError ?? 'Gagal menghapus request')),
      );
    }
  }

  Future<void> _exportReport(String format) async {
    final auth = Provider.of<AuthService>(context, listen: false);
    final url = auth.getReportUrl(
      'requests',
      format: format,
      from: _from?.toIso8601String(),
      to: _to?.toIso8601String(),
    );
    final messenger = ScaffoldMessenger.of(context);
    try {
      await launchUrlString(url);
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('Membuka laporan ($format)')),
      );
    } catch (e) {
      await Clipboard.setData(ClipboardData(text: url));
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('Gagal membuka. Link disalin ke clipboard')),
      );
    }
  }

  String _formatDate(dynamic val) {
    if (val == null) return '-';
    try {
      final s = val.toString();
      if (s.contains('T')) return s.split('T').first;
      return s;
    } catch (e) {
      return val.toString();
    }
  }

  Widget _statusChip(String? status) {
    final s = (status ?? '').toLowerCase();
    Color color = Colors.grey;
    String label = s.isEmpty ? '-' : s;
    if (s == 'pending') color = Colors.orange;
    if (s == 'approved' || s == 'done') color = Colors.green;
    if (s == 'rejected') color = Colors.red;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  IconData _statusIcon(String? status) {
    final s = (status ?? '').toLowerCase();
    if (s == 'pending') return Icons.hourglass_top;
    if (s == 'approved' || s == 'done') return Icons.check_circle;
    if (s == 'rejected') return Icons.cancel;
    return Icons.help_outline;
  }

  Color _statusIconColor(String? status) {
    final s = (status ?? '').toLowerCase();
    if (s == 'pending') return Colors.orange.shade700;
    if (s == 'approved' || s == 'done') return Colors.green.shade700;
    if (s == 'rejected') return Colors.red.shade700;
    return Colors.grey.shade600;
  }

  String _barangName(Map<String, dynamic> r) {
    return (r['barang']?['nama'] ??
            r['nama_barang'] ??
            r['barang_nama'] ??
            'Unknown')
        .toString();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final bool isStaff =
        auth.user != null &&
        (auth.user!.hasRole('staff') || auth.user!.hasRole('karyawan'));
    return Scaffold(
      backgroundColor: Colors.grey[50],
      drawer: const RoleDrawer(),
      appBar: AppBar(
        title: Text(_title),
        backgroundColor: _accentColor,
        elevation: 0,
        foregroundColor: Colors.white,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              final scaffold = Scaffold.of(ctx);
              if (scaffold.isDrawerOpen) {
                Navigator.pop(ctx);
              } else {
                scaffold.openDrawer();
              }
            },
          ),
        ),
        actions: [
          if (_isTracking)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _load(),
              tooltip: 'Refresh',
            ),
          if (!_isTracking && !isStaff)
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fitur eksport telah dinonaktifkan'),
                  ),
                );
              },
              tooltip: 'Export',
            ),
        ],
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(_accentColor),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  if (_isTracking) ...[
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Cari nama atau keterangan...',
                              prefixIcon: Icon(Icons.search),
                              isDense: true,
                            ),
                            onChanged: (v) => setState(() => _query = v),
                          ),
                        ),
                        const SizedBox(width: 8),
                        PopupMenuButton<String>(
                          initialValue: _statusFilter,
                          onSelected: (v) => setState(() => _statusFilter = v),
                          itemBuilder: (ctx) => [
                            const PopupMenuItem(
                              value: 'all',
                              child: Text('Semua'),
                            ),
                            const PopupMenuItem(
                              value: 'pending',
                              child: Text('Pending'),
                            ),
                            const PopupMenuItem(
                              value: 'approved',
                              child: Text('Disetujui'),
                            ),
                            const PopupMenuItem(
                              value: 'done',
                              child: Text('Selesai'),
                            ),
                            const PopupMenuItem(
                              value: 'rejected',
                              child: Text('Ditolak'),
                            ),
                          ],
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _statusFilter == 'all'
                                      ? 'Semua'
                                      : _statusFilter,
                                ),
                                const Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],

                  // History mode: responsive date filters and export
                  if (!_isTracking) ...[
                    Card(
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LayoutBuilder(
                          builder: (ctx, constraints) {
                            final isNarrow = constraints.maxWidth < 520;
                            if (isNarrow) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () async {
                                            final d = await showDatePicker(
                                              context: context,
                                              initialDate:
                                                  _from ?? DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime.now(),
                                            );
                                            if (d != null) {
                                              if (!mounted) return;
                                              setState(() => _from = d);
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade50,
                                              border: Border.all(
                                                color: Colors.grey.shade200,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.calendar_today,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 8),
                                                Flexible(
                                                  child: Text(
                                                    _from == null
                                                        ? 'Dari tanggal'
                                                        : '${_from!.day}/${_from!.month}/${_from!.year}',
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade800,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () async {
                                            final d = await showDatePicker(
                                              context: context,
                                              initialDate:
                                                  _to ?? DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime.now(),
                                            );
                                            if (d != null) {
                                              if (!mounted) return;
                                              setState(() => _to = d);
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade50,
                                              border: Border.all(
                                                color: Colors.grey.shade200,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.calendar_today,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 8),
                                                Flexible(
                                                  child: Text(
                                                    _to == null
                                                        ? 'Sampai tanggal'
                                                        : '${_to!.day}/${_to!.month}/${_to!.year}',
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade800,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  if (!isStaff)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          onPressed: () => _exportReport('pdf'),
                                          color: Colors.red.shade700,
                                          icon: const Icon(
                                            Icons.picture_as_pdf,
                                          ),
                                          tooltip: 'PDF',
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          onPressed: () =>
                                              _exportReport('xlsx'),
                                          color: Colors.green.shade700,
                                          icon: const Icon(Icons.grid_on),
                                          tooltip: 'Excel',
                                        ),
                                      ],
                                    ),
                                ],
                              );
                            }

                            // wide layout
                            return Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      final d = await showDatePicker(
                                        context: context,
                                        initialDate: _from ?? DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime.now(),
                                      );
                                      if (d != null) {
                                        if (!mounted) return;
                                        setState(() => _from = d);
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade50,
                                        border: Border.all(
                                          color: Colors.grey.shade200,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_today,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            _from == null
                                                ? 'Dari tanggal'
                                                : '${_from!.day}/${_from!.month}/${_from!.year}',
                                            style: TextStyle(
                                              color: Colors.grey.shade800,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      final d = await showDatePicker(
                                        context: context,
                                        initialDate: _to ?? DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime.now(),
                                      );
                                      if (d != null) {
                                        if (!mounted) return;
                                        setState(() => _to = d);
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade50,
                                        border: Border.all(
                                          color: Colors.grey.shade200,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_today,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            _to == null
                                                ? 'Sampai tanggal'
                                                : '${_to!.day}/${_to!.month}/${_to!.year}',
                                            style: TextStyle(
                                              color: Colors.grey.shade800,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                if (!isStaff) ...[
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red.shade700,
                                    ),
                                    onPressed: () => _exportReport('pdf'),
                                    icon: const Icon(Icons.picture_as_pdf),
                                    label: const Text('PDF'),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green.shade700,
                                    ),
                                    onPressed: () => _exportReport('xlsx'),
                                    icon: const Icon(Icons.grid_on),
                                    label: const Text('Excel'),
                                  ),
                                ],
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  Expanded(
                    child: _visibleRequests.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _emptyIcon,
                                  size: 80,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _isTracking
                                      ? 'Belum ada request'
                                      : 'Belum ada riwayat permintaan',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _isTracking
                                      ? 'Request yang Anda buat akan muncul di sini'
                                      : 'Permintaan yang Anda buat akan muncul di sini',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _load,
                            color: _accentColor,
                            child: LayoutBuilder(
                              builder: (ctx, constraints) {
                                final narrow = constraints.maxWidth < 720;
                                if (_isTracking) {
                                  // keep tracking list as before
                                  return ListView.builder(
                                    padding: const EdgeInsets.all(16),
                                    itemCount: _visibleRequests.length,
                                    itemBuilder: (c, i) {
                                      final r = _visibleRequests[i];
                                      final status = r['status']
                                          ?.toString()
                                          .toLowerCase();
                                      final tanggal = _formatDate(
                                        r['tanggal_request'],
                                      );

                                      return Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withAlpha(13),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: ListTile(
                                          contentPadding: const EdgeInsets.all(
                                            16,
                                          ),
                                          leading: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: _statusIconColor(
                                                status,
                                              ).withAlpha(26),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              _statusIcon(status),
                                              color: _statusIconColor(status),
                                              size: 20,
                                            ),
                                          ),
                                          title: Text(
                                            _barangName(r),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 4),
                                              Text(
                                                'Qty: ${r['qty']}',
                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                'Tanggal: $tanggal',
                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                              if (r['keterangan'] != null &&
                                                  r['keterangan']
                                                      .toString()
                                                      .isNotEmpty) ...[
                                                const SizedBox(height: 2),
                                                Text(
                                                  'Keterangan: ${r['keterangan']}',
                                                  style: TextStyle(
                                                    color: Colors.grey.shade600,
                                                    fontSize: 12,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                              if (r['alasan_penolakan'] !=
                                                      null &&
                                                  r['alasan_penolakan']
                                                      .toString()
                                                      .isNotEmpty) ...[
                                                const SizedBox(height: 2),
                                                Text(
                                                  'Alasan: ${r['alasan_penolakan']}',
                                                  style: TextStyle(
                                                    color: Colors.red.shade600,
                                                    fontSize: 12,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ],
                                          ),
                                          trailing: status == 'pending'
                                              ? Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.edit,
                                                        color: Colors.blue,
                                                      ),
                                                      onPressed: () =>
                                                          _editRequest(r),
                                                      tooltip: 'Edit',
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                      ),
                                                      onPressed: () =>
                                                          _deleteRequest(r),
                                                      tooltip: 'Hapus',
                                                    ),
                                                  ],
                                                )
                                              : _statusChip(status),
                                        ),
                                      );
                                    },
                                  );
                                }

                                if (narrow) {
                                  // for history on narrow screens show card list instead of wide table
                                  return ListView.separated(
                                    padding: const EdgeInsets.all(12),
                                    itemCount: _visibleRequests.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(height: 8),
                                    itemBuilder: (ctx, i) {
                                      final r = _visibleRequests[i];
                                      final status = r['status']
                                          ?.toString()
                                          .toLowerCase();
                                      return Card(
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      '${i + 1}. ${_barangName(r)}',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ),
                                                  _statusChip(status),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Qty: ${r['qty']}',
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade700,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Text(
                                                    'Tanggal: ${_formatDate(r['tanggal_request'])}',
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade700,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              if (r['keterangan'] != null &&
                                                  r['keterangan']
                                                      .toString()
                                                      .isNotEmpty) ...[
                                                const SizedBox(height: 8),
                                                Text(
                                                  r['keterangan']?.toString() ??
                                                      '-',
                                                  style: TextStyle(
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }

                                // wide: show DataTable
                                return Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      columnSpacing: 28,
                                      headingRowColor:
                                          MaterialStateProperty.resolveWith(
                                            (states) => Colors.grey.shade100,
                                          ),
                                      headingTextStyle: TextStyle(
                                        color: Colors.grey.shade800,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      columns: const [
                                        DataColumn(label: Text('No')),
                                        DataColumn(label: Text('Nama Barang')),
                                        DataColumn(label: Text('Qty')),
                                        DataColumn(label: Text('Tanggal')),
                                        DataColumn(label: Text('Status')),
                                        DataColumn(label: Text('Keterangan')),
                                      ],
                                      rows: List<DataRow>.generate(
                                        _visibleRequests.length,
                                        (i) {
                                          final r = _visibleRequests[i];
                                          return DataRow(
                                            cells: [
                                              DataCell(
                                                Text((i + 1).toString()),
                                              ),
                                              DataCell(Text(_barangName(r))),
                                              DataCell(
                                                Text(
                                                  (r['qty'] ?? '').toString(),
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                  _formatDate(
                                                    r['tanggal_request'],
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                _statusChip(
                                                  r['status']?.toString(),
                                                ),
                                              ),
                                              DataCell(
                                                ConstrainedBox(
                                                  constraints:
                                                      const BoxConstraints(
                                                        maxWidth: 300,
                                                      ),
                                                  child: Text(
                                                    r['keterangan']
                                                            ?.toString() ??
                                                        '-',
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
