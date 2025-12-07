import 'package:flutter/material.dart';
import '../../widgets/requests_list.dart';

class TrackingPage extends StatelessWidget {
  const TrackingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const RequestsList(mode: RequestMode.tracking);
  }
}
