import 'package:flutter/material.dart';
import '../../widgets/requests_list.dart';

class RiwayatPermintaanPage extends StatelessWidget {
  const RiwayatPermintaanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const RequestsList(mode: RequestMode.history);
  }
}
