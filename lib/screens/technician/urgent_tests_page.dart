import 'package:flutter/material.dart';
import 'base_test_list_page.dart';

class UrgentTestsPage extends StatelessWidget {
  const UrgentTestsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BaseTestListPage(
      pageTitle: 'Urgent Tests',
      statusFilter: 'urgent',
    );
  }
}