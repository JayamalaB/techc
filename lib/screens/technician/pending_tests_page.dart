import 'package:flutter/material.dart';
import 'base_test_list_page.dart';

class PendingTestsPage extends StatelessWidget {
  const PendingTestsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BaseTestListPage(
      pageTitle: 'Pending Tests',
      statusFilter: 'pending',
    );
  }
}